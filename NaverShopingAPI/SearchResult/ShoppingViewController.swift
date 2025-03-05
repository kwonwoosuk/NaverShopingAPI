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
import RealmSwift

final class ShoppingViewController: BaseViewController {
    
    private let mainView = ShoppingView()
    private let viewModel = ShoppingViewModel()
    private let viewDidLoadSubject = PublishSubject<Void>()
    
    private let realm = try! Realm() // 파일 찾아라!!
    
    let searchText = BehaviorRelay<String?>(value: nil)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //컬렉션뷰 리로드
        mainView.collectionView.reloadData()
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
            .drive(mainView.collectionView.rx.items(cellIdentifier: ShoppingViewCell.identifier, cellType: ShoppingViewCell.self)) { [weak self] _, item, cell in
                guard let self = self else { return }
                let isFavorite = self.isItemFavorited(title: item.deleteTagTitle)
                
                cell.configure(item: item, isFavorite: isFavorite)
                
                cell.likeButton.rx.tap
                    .bind(with: self) { owner, _ in
                        if cell.likeButton.isSelected {
                            //이미 선택되어있으면 취소
                            owner.removeFavorites(title: item.deleteTagTitle)
                            cell.likeButton.isSelected = false
                        } else {
                            // 좋아요 추가
                            if let price = Int(item.lprice) {
                                owner.addFavorites(mallName: item.mallName, title: item.deleteTagTitle, price: price)
                                cell.likeButton.isSelected = true
                            }
                        }
                    }
                    .disposed(by: cell.disposeBag)
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
    
    private func isItemFavorited(title: String) -> Bool {
        let favorites = realm.objects(FavoriteItem.self)
        
        for item in favorites {
            if item.title == title { //  primarykey로 사용중인 objectID는 상품과 딱히 연관이 없다 랜덤하게 만들어지는거니까...
                return true //좋아요 눌림
            }
        }
        return false // 안눌려이씀
    }
    
    private func addFavorites(mallName: String, title: String, price: Int) {
            
            if isItemFavorited(title: title) {
                return
            }
            do {
                let item = FavoriteItem(mallName: mallName, title: title, price: price)
                try realm.write {
                    realm.add(item)
                }
            } catch {
                print("좋아요 추가 실패: \(error.localizedDescription)")
            }
    }
    
    private func removeFavorites(title: String) {
        
        let favorites = realm.objects(FavoriteItem.self)
        
        do {
            for item in favorites {
                if item.title == title {
                    
                    try realm.write {
                        realm.delete(item)
                    }
                    break
                }
            }
        } catch {
            print("좋아요 삭제 실패")
        }
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
