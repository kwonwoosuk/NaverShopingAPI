//
//  ShoppingViewController.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/26/25.
//


import UIKit
import RxSwift
import RxCocoa

import SnapKit

final class ShoppingViewController: BaseViewController {
    
    private let mainView = ShoppingView()
    private let viewModel = ShoppingViewModel()
    private let viewDidLoadSubject = PublishSubject<Void>()
    
    let searchText = BehaviorRelay<String?>(value: nil)
    
    override func loadView() {
        view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadSubject.onNext(())
    }
    override func configureView() {
        configureNavigationBar()
        
        navigationItem.title = searchText.value
    }
    
    override func bind() {
        let input = ShoppingViewModel.Input(
            viewDidLoad: ControlEvent(events: viewDidLoadSubject),
            searchText: searchText,
            accuracyButtonTapped: mainView.accuracyButton.rx.tap,
            dateButtonTapped: mainView.dateButton.rx.tap,
            priceHighButtonTapped: mainView.priceDscButton.rx.tap,
            priceLowButtonTapped: mainView.priceAscButton.rx.tap,
            backButtonTapped: navigationItem.leftBarButtonItem?.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.items
            .drive(mainView.collectionView.rx.items(cellIdentifier: ShoppingViewCell.identifier, cellType: ShoppingViewCell.self)) { _, item, cell in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
        
        output.totalCount
            .drive(mainView.totalLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.sortType
            .drive(with: self) { owner, sortType in
                owner.mainView.updateSortButtonsState(for: sortType)
            }
            .disposed(by: disposeBag)
        
        output.error
            .compactMap { $0 }
            .drive(with: self) { owner, errorMessage in
                owner.showAlert(message: errorMessage)
            }
            .disposed(by: disposeBag)
        
        output.backButtonTapped?
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                         style: .plain,
                                         target: nil,
                                         action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
