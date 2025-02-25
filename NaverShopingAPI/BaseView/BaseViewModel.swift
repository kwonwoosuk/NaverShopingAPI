//
//  BaseViewModel.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/25/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input) -> Output
}
