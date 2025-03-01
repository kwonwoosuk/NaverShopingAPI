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
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .flatMap { query in
                NetworkManager.shared.searchShopItems(query: query, sort: .sim)
            }
            .debug("ViewDidLoad")
            .subscribe { result in
                sortTypeRelay.accept(.sim)
                
                switch result {
                case .success(let data):
                    itemsRelay.accept(data.items)
                    totalCountRelay.accept("\(data.total.formatted())개의 검색 결과")
                case .failure(let error):
                    errorRelay.accept(error.message)
                    itemsRelay.accept([])
                }
            }
            .disposed(by: disposeBag)
        
        // 정확도순 버튼 탭
        input.accuracyButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .flatMap { query in
                NetworkManager.shared.searchShopItems(query: query, sort: .sim)
            }
            .debug("AccuracyButton")
            .subscribe { result in
                sortTypeRelay.accept(.sim)
                
                switch result {
                case .success(let data):
                    itemsRelay.accept(data.items)
                    totalCountRelay.accept("\(data.total.formatted())개의 검색 결과")
                case .failure(let error):
                    errorRelay.accept(error.message)
                    itemsRelay.accept([])
                }
            }
            .disposed(by: disposeBag)
        
        // 날짜순 버튼 탭
        input.dateButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .flatMap { query in
                NetworkManager.shared.searchShopItems(query: query, sort: .date)
            }
            .debug("DateButton")
            .subscribe { result in
                sortTypeRelay.accept(.date)
                
                switch result {
                case .success(let data):
                    itemsRelay.accept(data.items)
                    totalCountRelay.accept("\(data.total.formatted())개의 검색 결과")
                case .failure(let error):
                    errorRelay.accept(error.message)
                    itemsRelay.accept([])
                }
            }
            .disposed(by: disposeBag)
        
        // 가격높은순 버튼 탭
        input.priceHighButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .flatMap { query in
                NetworkManager.shared.searchShopItems(query: query, sort: .dsc)
            }
            .debug("PriceHighButton")
            .subscribe { result in
                sortTypeRelay.accept(.dsc)
                
                switch result {
                case .success(let data):
                    itemsRelay.accept(data.items)
                    totalCountRelay.accept("\(data.total.formatted())개의 검색 결과")
                case .failure(let error):
                    errorRelay.accept(error.message)
                    itemsRelay.accept([])
                }
            }
            .disposed(by: disposeBag)
        
        // 가격낮은순 버튼 탭
        input.priceLowButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .flatMap { query in
                NetworkManager.shared.searchShopItems(query: query, sort: .asc)
            }
            .debug("PriceLowButton")
            .subscribe { result in
                sortTypeRelay.accept(.asc)
                
                switch result {
                case .success(let data):
                    itemsRelay.accept(data.items)
                    totalCountRelay.accept("\(data.total.formatted())개의 검색 결과")
                case .failure(let error):
                    errorRelay.accept(error.message)
                    itemsRelay.accept([])
                }
            }
            .disposed(by: disposeBag)
        
     
        return Output(
            items: itemsRelay.asDriver(),
            totalCount: totalCountRelay.asDriver(),
            sortType: sortTypeRelay.asDriver(),
            isLoading: loadingRelay.asDriver(),
            backButtonTapped: input.backButtonTapped?.asDriver(),
            error: errorRelay.asDriver(onErrorJustReturn: nil)
        )
    }
}
