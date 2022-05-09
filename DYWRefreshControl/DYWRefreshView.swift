//
//  DYWRefreshView.swift
//  DYWRefreshControl
//
//  Created by dyw on 2022/5/8.
//

import UIKit

class DYWRefreshView: UIView {
    
    var refreshState: DYWRefreshState = .normal {
        didSet {
            switch refreshState {
            case .normal:
                tipLabel.text = "下拉可以刷新"
                imageView.isHidden = false
                indicatorView.stopAnimating()
                UIView.animate(withDuration: 0.2) {
                    self.imageView.transform = CGAffineTransform.identity
                }
               
            case .pulling:
                tipLabel.text = "松开立即刷新"
                UIView.animate(withDuration: 0.2) {
                    self.imageView.transform = CGAffineTransform(rotationAngle: Double.pi)
                }
                
            case .refreshing:
                tipLabel.text = "正在刷新数据中. . ."
                imageView.isHidden = true
                indicatorView.startAnimating()
            
            }
        }
    }

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "arrow")
        return imageView
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView ()
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        imageView.frame = CGRect(x: 20, y: bounds.midY - 20, width: 15, height: 40)
        indicatorView.frame = CGRect(x: 10, y: bounds.midY - 20, width: 40, height: 40)
        tipLabel.frame = CGRect(x: 50, y: bounds.midY - 20, width: 120, height: 40)
        
    }
    
}

extension DYWRefreshView {
    private func setupUI() {
        addSubview(imageView)
        addSubview(tipLabel)
        addSubview(indicatorView)

    }
}
