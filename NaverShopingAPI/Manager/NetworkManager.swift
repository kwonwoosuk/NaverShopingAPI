//
//  NetworkManager.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/26/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

struct NaverErrorResponse: Decodable {
    let errorMessage: String
    let errorCode: String
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func searchShopItems(query: String, sort: SortType) -> Single<Result<List, NaverAPIError>> {
        
        return Single<Result<List, NaverAPIError>>.create { value in
                        
            let urlString = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=100&start=1&sort=\(sort.rawValue)"
            
            guard let _ = URL(string: urlString) else {
                value(.success(.failure(.invalidURL)))
                return Disposables.create()
            }
            
            let headers: HTTPHeaders = [
                "X-Naver-Client-Id": APINAVER.id,
                "X-Naver-Client-Secret": APINAVER.key
            ]
            
            AF.request(urlString, method: .get, headers: headers)
                .validate()
                .responseData { response in
                    
                    if let statusCode = response.response?.statusCode { // HTTP 상태 코드 확인
                        if statusCode == 200 {
                            if let data = response.data {
                                do {
                                    let result = try JSONDecoder().decode(List.self, from: data)
                                    value(.success(.success(result)))
                                } catch {
                                    print("에ㅓㄹ에러‼️ \(error)")
                                    value(.success(.failure(.unknown)))
                                }
                            } else {
                                value(.success(.failure(.unknown)))
                            }
                        } else {
                            var errorMessage: String? = nil
                            
                            if let data = response.data {
                                do {
                                    let errorResponse = try JSONDecoder().decode(NaverErrorResponse.self, from: data)
                                    errorMessage = errorResponse.errorMessage
                                } catch {
                                    print("에러에러‼️ \(error)")
                                }
                            }
                            // 상태 코드에 따라 오류 타입 넣어주기
                            let error = NaverAPIError.fromStatusCode(statusCode, message: errorMessage)
                            value(.success(.failure(error)))
                        }
                    } else {
                        value(.success(.failure(.unknown)))
                    }
                }
            
            return Disposables.create {
                print("API 요청 취소💦")
            }
        }
    }
}
