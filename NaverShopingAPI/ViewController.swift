//
//  ViewController.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 1/15/25.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

class ViewController: UIViewController {
    let searchBar = {
        let search = UISearchBar()
        search.barTintColor = .black
        search.searchTextField.textColor = .white
        search.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "브랜드,상품,프로필,태그 등",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        
        )
        return search
    }()
    
    let imageView = {
        let imgview = UIImageView()
        imgview.contentMode = .scaleAspectFit
        imgview.image = UIImage(named: "wantShopping")
        return imgview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeUINaviCon()
        configureSearchBar()
        configureView()
        keyboardDismiss()
    }
    
    
    func keyboardDismiss() {// 추가 하라구 하셨다 기본중에 기본쓰...습관을 들여라 참꺠
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
           searchBar.resignFirstResponder()
       }
    
    
    func changeUINaviCon() {
        navigationItem.title = "도봉러의 쑈핑쑈핑"
        navigationItem.titleView?.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
    }
    
    
    func configureView() {
        view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(400)
        }
    }
    
    func configureSearchBar() {
        
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }

   
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text , text.count >= 2 else {
            searchBar.text = "2글자이상 입력해주세요"
            print("\(searchBar.text ?? "")")
            return
        }
        let vc = NaverShopViewController()
        vc.searchText = text
        self.navigationController?.pushViewController(vc, animated: true)
        //값을 전달하는 함수를 만들던가. 뷰컨을 인스턴스화 하던가
        searchBar.endEditing(true)
        
    }
}
