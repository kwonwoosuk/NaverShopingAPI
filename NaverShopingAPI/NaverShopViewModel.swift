//
//  NaverShopViewModel.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/7/25.
//



import Foundation
import Alamofire



final class NaverShopViewModel {
    //첫화면에 정확ㄷ
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputAccuracyButtonTapped: Observable<Void?> = Observable(nil)  // 정확도순
    let inputDateButtonTapped: Observable<Void?> = Observable(nil)      // 날짜순
    let inputHighPriceButtonTapped: Observable<Void?> = Observable(nil) // 가격높은순
    let inputLowPriceButtonTapped: Observable<Void?> = Observable(nil)  // 가격낮은순
    let inputBackButtonTapped: Observable<Void?> = Observable(nil)
    let inputSearchBarText: Observable<String?> = Observable(nil)
    
    let outputSearchText: Observable<String?> = Observable(nil)
    let outputItems: Observable<[Item]> = Observable([])
    let outputTotalCount: Observable<String?> = Observable(nil)
    let outputBackButtonTapped: Observable<Void?> = Observable(nil)
    let outputSortType: Observable<SortType> = Observable(.accuracy)
    
    private var page: Int = 1
    
    enum SortType: String {
        case accuracy = "sim"
        case date = "date"
        case priceHigh = "dsc"
        case priceLow = "asc"
    }
    
    init() {
        //처음나올땐 원래 정확도 순
        inputViewDidLoadTrigger.bind { [weak self]_ in
            print("작동함")
            self?.callRequest(sort: .accuracy)
        }
        
        inputAccuracyButtonTapped.bind { [weak self] _ in
            self?.sortChanged(.accuracy)
        }
        
        inputDateButtonTapped.bind { [weak self] _ in
            self?.sortChanged(.date)
        }
        
        inputHighPriceButtonTapped.bind { [weak self] _ in
            self?.sortChanged(.priceHigh)
        }
        
        inputLowPriceButtonTapped.bind { [weak self] _ in
            self?.sortChanged(.priceLow)
        }
        
        // 나중에 없애겠어 널ㄹ...
        inputBackButtonTapped.bind { [weak self] _ in
            self?.outputBackButtonTapped.value = ()
        }
    }
    
    private func sortChanged(_ sortType: SortType) {
        outputSortType.value = sortType
        callRequest(sort: sortType)
    }
    
    private func callRequest(sort: SortType) {
        if let query = outputSearchText.value {
            let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=100&start=1&sort=\(sort.rawValue)"
            
            let header: HTTPHeaders = [
                "X-Naver-Client-Id": APINAVER.id,
                "X-Naver-Client-Secret": APINAVER.key
            ]
            
            AF.request(url, method: .get, headers: header)
                .responseDecodable(of: List.self) { response in
                    switch response.result {
                    case .success(let data):
                        self.outputItems.value = data.items
                        self.outputTotalCount.value = "\(data.total.formatted())개의 검색 결과"
                        
                    case .failure(let error):
                        print("API Error:", error)
                    }
                }
        }
    }
}
