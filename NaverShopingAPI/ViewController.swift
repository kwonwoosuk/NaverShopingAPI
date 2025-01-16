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
        guard let text = searchBar.text, !text.isEmpty else {
//            .showAlert
            showAlert(
                title: "검색어 오류",
                message: "검색어를 입력해주세요",
                button: "확인"
            ) {// 확인을 눌렀을때 실행되는 구문 -이거 하려고 클로저 쓰는건가...
                self.dismiss(animated: true)
            }
            return
        }
        
        
        if text.count < 2 {
            showAlert(
                title: "⭐️다시 입력⭐️",
                message: "2글자 이상 입력해주세요",
                button: "확인"
            ) {}
            return
        }
        
        let vc = NaverShopViewController()
        vc.searchText = text
        self.navigationController?.pushViewController(vc, animated: true)
        searchBar.endEditing(true)
    }
}

extension UIViewController {
    func showAlert(title: String, message: String, button: String, completionHadler: @escaping () -> () ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) // alert스타일로 나타나는 알럿창 생성
        
        let button = UIAlertAction(title: button, style: .default) { action in // -> 버튼을 탭할때에 실행할거라서 {}안에 있는게 action시 실행하도록 클로저 작성
            completionHadler()
        }
        
        
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        
        alert.addAction(cancel)//버튼을 원래대로 추가해준거고
        alert.addAction(button)
        
        self.present(alert, animated: true) // 알림창을 띄워주는거 마지막에 있어야되고
    }
}
// showAlert이라는 함수는 중간에 들어간 button에 Action이 있을때 생성할 행동에 대한 것을 파라미터로 받고 파라미터는 함수의 생명주기가 끝난후에도 Void로 액션을 전달할 것이고
// 버튼 클릭 이벤트가 발생할때까지 메모리에 저장되어있어야 하니까 @escaping 어트리뷰트가 필요한것 -> 메서드 종료후에도 클로저가 실행될 수 있음을 의미한단다


/*
 
 
 
 
 @objc func resetButtonTapped() {
         let alert = UIAlertController(title: "비밀번호 바꾸기", message: "비밀번호를 바꾸시겠습니까?", preferredStyle: .alert)
         
         let succes = UIAlertAction(title: "확인", style: .default) { action in
             print("확인버튼이 눌렸습니다.")
         }
         
         let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in
             print("취소버튼이 눌렸습니다.")
         }❓ 클로저였어?
         
         alert.addAction(succes)
         alert.addAction(cancel)
         
     
         // 다음화면으로 넘어가기
         present(alert, animated: true, completion: nil)
         
         
     }
 */
