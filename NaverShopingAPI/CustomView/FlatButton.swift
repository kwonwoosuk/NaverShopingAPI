//
//  FlatButton.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 1/17/25.
//


import UIKit

class FlatUIButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        setTitleColor(.white, for: .normal)
        setTitleColor(.black, for: .selected)
        titleLabel?.font = .systemFont(ofSize: 12)
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
    
    
}
