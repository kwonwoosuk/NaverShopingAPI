//
//  SearchViewController.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/26/25.
//
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SearchViewController: BaseViewController {
    
    private let mainView = SearchView()
    private let viewModel = SearchViewModel()
    private let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: nil, action: nil)
    private let LeftBarButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: nil, action: nil)
    
    override func loadView() {
        view = mainView
    }
    
    override func configureView() {
        navigationItem.title = "도봉러의 쑈핑쑈핑"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.leftBarButtonItem = LeftBarButton
        
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
        
        rightBarButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = WishFolderViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        LeftBarButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(FavoriteListViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc private func dismissKeyboard() {
        mainView.searchBar.resignFirstResponder()
    }
}
