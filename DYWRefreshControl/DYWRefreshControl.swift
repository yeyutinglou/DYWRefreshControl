//
//  DYWRefreshControl.swift
//  DYWRefreshControl
//
//  Created by dyw on 2022/5/8.
//

import UIKit

// 临界值
private let DYWRefreshOffset: CGFloat = 60

enum DYWRefreshState {
    case normal //没到达临界值
    case pulling //超过临界值
    case refreshing //刷新
}

class DYWRefreshControl: UIControl {
    
    
    lazy var refreshView = DYWRefreshView()
    
    
    
    private weak var scrollView: UIScrollView?
    
    
    init() {
        super.init(frame: CGRect())
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let sv = newSuperview as? UIScrollView else { return  }
        
        scrollView = sv
        
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
       
        guard let sv = scrollView else {
            return
        }
        let height = -(sv.contentOffset.y + sv.contentInset.top)
        
        if height < 0{
            return
        }
        
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        if sv.isDragging {
            //下拉
            if height > DYWRefreshOffset && refreshView.refreshState == .normal {
                refreshView.refreshState = .pulling
            } else if height <= DYWRefreshOffset && refreshView.refreshState == .pulling {
                refreshView.refreshState = .normal
            }
        } else {
            //松手
            if refreshView.refreshState == .pulling {
                beginRefreshing()
                sendActions(for: .valueChanged)
            }
        }
        
    }
    
    func beginRefreshing() {
        print("开始刷新")
        guard let sv = scrollView else {
            return
        }
        if refreshView.refreshState == .refreshing {
            return
        }
        refreshView.refreshState = .refreshing
        
        var inset = sv.contentInset
        inset.top += DYWRefreshOffset
        sv.contentInset = inset
        
    }

    
    func endRefreshing() {
        print("结束刷新")
        guard let sv = scrollView else {
            return
        }
        refreshView.refreshState = .normal
        var inset = sv.contentInset
        inset.top -= DYWRefreshOffset
        sv.contentInset = inset
        
        
    }
    
    
    
}

extension DYWRefreshControl {
    private func setupUI() {

        backgroundColor = superview?.backgroundColor
        addSubview(refreshView)
        
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        refreshView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        refreshView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        refreshView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        refreshView.heightAnchor.constraint(equalToConstant: DYWRefreshOffset).isActive = true
        
    }
}
