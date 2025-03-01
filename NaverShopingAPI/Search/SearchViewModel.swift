//
//  SearchViewModel.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/26/25.
//


import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchText: ControlProperty<String?> // 검색어
        let searchButtonTapped: ControlEvent<Void> // 검색 버튼 탭
    }
    
    struct Output {
        let validSearchText: Driver<String?> // 유효한 검색어
        let showAlertMessage: Driver<String?> // 알림창 표시
    }

    func transform(input: Input) -> Output {
        let validSearchText = PublishRelay<String?>()
        let showAlertMessage = PublishRelay<String?>()
        
        input.searchButtonTapped
            .withLatestFrom(input.searchText)
            .subscribe(with: self) { owner, text in
                guard let text = text?.trimmingCharacters(in: .whitespaces), !text.isEmpty else {
                    showAlertMessage.accept("검색어를 입력해주세요")
                    return
                }
                
                if text.count < 2 {
                    showAlertMessage.accept("검색어는 2글자 이상 입력해주세요")
                    return
                }
                
                validSearchText.accept(text)
            }
            .disposed(by: disposeBag)
        
        return Output(
            validSearchText: validSearchText.asDriver(onErrorJustReturn: nil),
            showAlertMessage: showAlertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
}
