//
//  NaverShopCollectionViewCell.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 1/15/25.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit
/*
 
 상품 전체(총) 갯수 total 컬렉션뷰에 고정으로 구현
 
 셀에서 image, mallName, title(2줄까지), lprice  //  좋아요 기능 travelApp참고 ... 테이블뷰라..으ㅡ음
 option 정렬 영역, 다른파라미터로 정렬기능 구현-> 네트워크 통신 다시호출 button으로 만들어야하ㄴ?
 
 struct List: Decodable {
 //let lastBuildDate: String 정렬옵션에서 날짜순할때 쓰면될거같고
 let total: Int
 let start: Int
 let display: Int
 let items: [Item]
 }
 struct Item: Decodable {
 let image: String //이미지 보여주고
 let mallName: String // 월드캠핑카
 let title: String // 스타리아 2층캠핑카 어쩌고저쩌고 두줄
 let lprice: String // 얼마얼마     - 가격높은순?sort 를 asc가격순으로 오름차순 정렬 dsc가격순으로 내림차순 정렬 -메서드 만들어서 네트워크 다시 불러오면 알아서 정렬해줄듯  ⭐️sim 정확도순으로 내림차순 이걸 기본으로 해두자
 }
 */

class NaverShopCollectionViewCell: UICollectionViewCell {
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let mallNameLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let likeButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .highlighted) //엄...네.. 눌리지는 않아요 하하^^ bottom trailing
        button.tintColor = .black
        return button
    }()
    
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        contentView.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        [imageView, mallNameLabel, titleLabel, priceLabel, likeButton].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(imageView).inset(10)
            make.size.equalTo(30)
        }
        likeButton.layer.cornerRadius = likeButton.frame.height / 2
        likeButton.clipsToBounds = true
        
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
    
    func configure(item: Item) {
        let url = URL(string: item.image)
        imageView.kf.setImage(with: url)
        mallNameLabel.text = item.mallName
        titleLabel.text = item.deleteTagTitle// 뭔 이상한 /\제거 아이고 ㅈ
        
        if let price = Int(item.lprice) {
            priceLabel.text = "\(price.formatted())원"
        }
    }
}
