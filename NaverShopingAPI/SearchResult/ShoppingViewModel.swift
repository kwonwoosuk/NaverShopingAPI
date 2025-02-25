//
//  ShoppingViewModel.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/26/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class ShoppingViewModel : BaseViewModel {
    
    let disposeBag = DisposeBag()
    private let networkManager = NetworkManager.shared
    
    struct Input {
        let viewDidLoad: ControlEvent<Void> // 화면 로드 완료
        let searchText: BehaviorRelay<String?> // 검색어
        let accuracyButtonTapped: ControlEvent<Void> // 정확도순 버튼
        let dateButtonTapped: ControlEvent<Void> // 날짜순 버튼
        let priceHighButtonTapped: ControlEvent<Void> // 가격높은순 버튼
        let priceLowButtonTapped: ControlEvent<Void> // 가격낮은순 버튼
        let backButtonTapped: ControlEvent<Void>? // 뒤로가기 버튼
    }
    
    struct Output {
        let items: Driver<[Item]> // 상품 목록
        let totalCount: Driver<String> // 전체 개수
        let sortType: Driver<SortType> // 정렬 타입
        let isLoading: Driver<Bool> // 로딩 상태
        let backButtonTapped: Driver<Void>?
        let error: Driver<String?> // 오류 메시지
    }
    
    
    func transform(input: Input) -> Output {
        
        let itemsRelay = BehaviorRelay<[Item]>(value: [])
        let totalCountRelay = BehaviorRelay<String>(value: "")
        let sortTypeRelay = BehaviorRelay<SortType>(value: .sim)
        
        let loadingRelay = BehaviorRelay<Bool>(value: false)
        let errorRelay = PublishRelay<String?>()
        
        // 화면 로드 시 정확도순으로 초기 검색
        input.viewDidLoad
            .withLatestFrom(input.searchText)
            .subscribe(onNext: { [weak self] query in
                guard let query = query, !query.isEmpty else { return }
                self?.fetchItems(query: query, sort: .sim, itemsRelay: itemsRelay, totalCountRelay: totalCountRelay, loadingRelay: loadingRelay, errorRelay: errorRelay)
            })
            .disposed(by: disposeBag)
        
        // 정확도순 버튼 탭
        input.accuracyButtonTapped
            .do(onNext: { sortTypeRelay.accept(.sim) })
            .withLatestFrom(input.searchText)
            .subscribe(onNext: { [weak self] query in
                guard let query = query, !query.isEmpty else { return }
                self?.fetchItems(query: query, sort: .sim, itemsRelay: itemsRelay, totalCountRelay: totalCountRelay, loadingRelay: loadingRelay, errorRelay: errorRelay)
            })
            .disposed(by: disposeBag)
        
        // 날짜순 버튼 탭
        input.dateButtonTapped
            .do(onNext: { sortTypeRelay.accept(.date) })
            .withLatestFrom(input.searchText)
            .subscribe(onNext: { [weak self] query in
                guard let query = query, !query.isEmpty else { return }
                self?.fetchItems(query: query, sort: .date, itemsRelay: itemsRelay, totalCountRelay: totalCountRelay, loadingRelay: loadingRelay, errorRelay: errorRelay)
            })
            .disposed(by: disposeBag)
        
        input.priceHighButtonTapped
            .do(onNext: { sortTypeRelay.accept(.dsc) })
            .withLatestFrom(input.searchText)
            .subscribe(onNext: { [weak self] query in
                guard let query = query, !query.isEmpty else { return }
                self?.fetchItems(query: query, sort: .dsc, itemsRelay: itemsRelay, totalCountRelay: totalCountRelay, loadingRelay: loadingRelay, errorRelay: errorRelay)
            })
            .disposed(by: disposeBag)
        
        input.priceLowButtonTapped
            .do(onNext: { sortTypeRelay.accept(.asc) })
            .withLatestFrom(input.searchText)
            .subscribe(onNext: { [weak self] query in
                guard let query = query, !query.isEmpty else { return }
                self?.fetchItems(query: query, sort: .asc, itemsRelay: itemsRelay, totalCountRelay: totalCountRelay, loadingRelay: loadingRelay, errorRelay: errorRelay)
            })
            .disposed(by: disposeBag)
        
        return Output(
            items: itemsRelay.asDriver(),
            totalCount: totalCountRelay.asDriver(),
            sortType: sortTypeRelay.asDriver(),
            isLoading: loadingRelay.asDriver(),
            backButtonTapped: input.backButtonTapped?.asDriver() ,
            error: errorRelay.asDriver(onErrorJustReturn: nil)
        )
    }
    
    private func fetchItems(query: String, sort: SortType, itemsRelay: BehaviorRelay<[Item]>, totalCountRelay: BehaviorRelay<String>, loadingRelay: BehaviorRelay<Bool>, errorRelay: PublishRelay<String?>) {
        
        loadingRelay.accept(true)
        
        networkManager.searchShopItems(query: query, sort: sort)
            .subscribe(onSuccess: { result in
                loadingRelay.accept(false)
                
                switch result {
                case .success(let data):
                    itemsRelay.accept(data.items)
                    totalCountRelay.accept("\(data.total.formatted())개의 검색 결과")
                    
                case .failure(let error):
                    errorRelay.accept(error.message)
                }
                
            }, onFailure: { error in
                loadingRelay.accept(false)
                errorRelay.accept("오류가 발생했습니다: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
