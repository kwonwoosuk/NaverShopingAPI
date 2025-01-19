//
//  BaseView.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 1/17/25.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        configureDelegate()
    }
    
    func configureHierarchy() {}
    
    func configureCollectionView() {}
    
    func configureLayout() {}
    
    func configureDelegate() {}
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
