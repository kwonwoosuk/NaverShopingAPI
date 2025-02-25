//
//  ShoppingViewCell.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/26/25.
//


import UIKit
import Kingfisher
import SnapKit

class ShoppingViewCell: UICollectionViewCell {
    
    static let identifier = "ShoppingViewCell"
    
    let imageView = UIImageView()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let likeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [imageView, mallNameLabel, titleLabel, priceLabel, likeButton].forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(imageView).inset(10)
            make.size.equalTo(30)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func configureView() {
        contentView.backgroundColor = .black
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        mallNameLabel.textColor = .lightGray
        mallNameLabel.font = .systemFont(ofSize: 12)
        
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 2
        
        priceLabel.textColor = .white
        priceLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .highlighted)
        likeButton.tintColor = .white
        likeButton.backgroundColor = .black.withAlphaComponent(0.5)
        likeButton.layer.cornerRadius = 15
        likeButton.clipsToBounds = true
    }
    
    func configure(item: Item) {
        let url = URL(string: item.image)
        imageView.kf.setImage(with: url)
        mallNameLabel.text = item.mallName
        titleLabel.text = item.deleteTagTitle
        
        if let price = Int(item.lprice) {
            priceLabel.text = "\(price.formatted())원"
        }
    }
}
