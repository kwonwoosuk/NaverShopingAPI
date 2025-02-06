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

class MainViewController: UIViewController {
    
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
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeUINaviCon()
        configureView()
        keyboardDismiss()
        bindData()
    }
    // 값받으면
    private func bindData() {
        viewModel.outputSearchBatText.lazybind { text in
            let vc = NaverShopViewController()
            vc.viewModel.outputSearchText.value = text
            vc.navigationItem.title = vc.viewModel.outputSearchText.value
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.outputValidAleart.bind { isInValid in
            if isInValid {
                self.showAlert(title: "글자수 오류!", message: "2글자 이상 입력해주세용", button: "확인") {
                    self.searchBar.becomeFirstResponder()
                }
            }
        }
    }
    
    
}
// 눌렀다! 눌린값 던진다 ! 니가 알아서 해 !
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        viewModel.inputSearchBarText.value = searchBar.text
        searchBar.resignFirstResponder()
        
        //        let vc = NaverShopViewController()
        //        vc.searchText = text
        //        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}



extension UIViewController {
    func showAlert(title: String, message: String, button: String, completionHadler: @escaping () -> () ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) 
        
        let button = UIAlertAction(title: button, style: .default) { action in
            completionHadler()
        }
        
        
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        
        alert.addAction(cancel)
        alert.addAction(button)
        
        self.present(alert, animated: true)
    }
}






extension MainViewController {
    
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
        view.addSubview(searchBar)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(400)
        }
        searchBar.delegate = self
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }
    
    
    
}
