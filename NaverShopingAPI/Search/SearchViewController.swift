//
//  SearchViewController.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/26/25.
//

// MainViewController.swift
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SearchViewController: BaseViewController {
    
    private let mainView = SearchView()
    private let viewModel = SearchViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func configureView() {
        navigationItem.title = "도봉러의 쑈핑쑈핑"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func bind() {
        let input = SearchViewModel.Input(
            searchText: mainView.searchBar.rx.text,
            searchButtonTapped: mainView.searchBar.rx.searchButtonClicked
        )
        
        let output = viewModel.transform(input: input)
        
        
        output.validSearchText
            .compactMap { $0 }
            .drive(with: self) { owner, text in
                let vc = ShoppingViewController()
                vc.searchText.accept(text)
                vc.navigationItem.title = text
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.showAlertMessage
            .compactMap { $0 }
            .drive(with: self) { owner, message in
                owner.showAlert(title: "검색 오류", message: message, button: "확인") {
                    owner.mainView.searchBar.becomeFirstResponder()
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func dismissKeyboard() {
        mainView.searchBar.resignFirstResponder()
    }
}
