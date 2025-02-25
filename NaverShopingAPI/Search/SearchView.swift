//
//  SearchView.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/26/25.
//

// MainView.swift
import UIKit
import SnapKit

final class SearchView: BaseView {
    
    let searchBar = UISearchBar()
    let imageView = UIImageView()
    
    override func configureHierarchy() {
        [searchBar, imageView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(400)
        }
    }
    
    override func configureView() {
        backgroundColor = .black
        
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "브랜드,상품,프로필,태그 등",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "wantShopping")
    }
}
