//
//  FavoriteTableViewCell.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 3/4/25.
//

import UIKit
import SnapKit

class FavoriteTableViewCell: UITableViewCell {
    
    static let identifier = "FavoriteTableViewCell"
    
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let likeButton = UIButton()
    //좋아요 버튼 눌렀을떄 제거,,, didselect로 내주시려던거 아니였나요...
    var likeButtonTapHandler: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [mallNameLabel, titleLabel, priceLabel, likeButton].forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        mallNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.trailing.equalTo(likeButton.snp.leading).offset(-8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            make.trailing.equalTo(likeButton.snp.leading).offset(-8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
            make.trailing.equalTo(likeButton.snp.leading).offset(-8)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
    }
    
    private func configureView() {
        backgroundColor = .black
        selectionStyle = .none
        
        mallNameLabel.textColor = .lightGray
        mallNameLabel.font = .systemFont(ofSize: 12)
        
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 2
        
        priceLabel.textColor = .white
        priceLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = .red
        likeButton.backgroundColor = .clear
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func likeButtonTapped() {
        likeButtonTapHandler?()
    }
    
    func configure(with item: FavoriteItem) {
        mallNameLabel.text = item.mallName
        titleLabel.text = item.title
        priceLabel.text = "\(item.price.formatted())원"
    }
}
