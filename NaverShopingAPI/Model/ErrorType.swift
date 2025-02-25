//
//  ErrorType.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/26/25.
//

import Foundation

enum NaverAPIError: Error {
    case invalidURL                   // URL 형식이 잘못된 경우
    case missingParameter             // 필수 요청 변수 누락 또는 잘못된 이름 (400)
    case notEncodedParameter          // URL 인코딩되지 않은 파라미터 (400)
    case authenticationFailure        // 인증 실패 (401)
    case missingAccessToken           // 접근 토큰 누락 또는 만료 (401)
    case httpsRequired                // HTTP 대신 HTTPS 필요 (403)
    case forbidden                    // 호출 금지 (403)
    case apiNotFound                  // API URL이 잘못됨 (404)
    case methodNotAllowed             // 잘못된 HTTP 메서드 (405)
    case dailyLimitExceeded           // 하루 허용량 초과 (429)
    case rateLimit                    // 초당 호출 한도 초과 (429)
    case serverError                  // 서버 오류 (500)
    case serverMaintenance            // 서버 유지 보수 또는 시스템 오류 (500)
    case unknown                      // 알 수 없는 오류
    
    var message: String {
        switch self {
        case .invalidURL:
            return "URL 형식이 잘못되었습니다."
        case .missingParameter:
            return "필수 요청 변수가 없거나 요청 변수 이름이 잘못되었습니다."
        case .notEncodedParameter:
            return "요청 변수 값이 URL 인코딩으로 변환되지 않았습니다."
        case .authenticationFailure:
            return "인증에 실패했습니다. 클라이언트 ID와 시크릿을 확인하세요."
        case .missingAccessToken:
            return "접근 토큰이 없거나 만료되었습니다."
        case .httpsRequired:
            return "HTTPS가 아닌 HTTP로 호출했습니다."
        case .forbidden:
            return "서버가 호출을 허용하지 않습니다."
        case .apiNotFound:
            return "API 요청 URL이 잘못되었습니다."
        case .methodNotAllowed:
            return "잘못된 HTTP 메서드로 호출했습니다."
        case .dailyLimitExceeded:
            return "하루 API 호출 허용량을 초과했습니다."
        case .rateLimit:
            return "초당 API 호출 한도를 초과했습니다."
        case .serverError:
            return "서버 오류가 발생했습니다."
        case .serverMaintenance:
            return "서버 유지 보수 중이거나 시스템 오류가 발생했습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
    
    static func fromStatusCode(_ statusCode: Int, message: String? = nil) -> NaverAPIError {
        switch statusCode {
        case 400:
            return message?.contains("URL") == true ? .notEncodedParameter : .missingParameter
        case 401:
            return message?.contains("access_token") == true ? .missingAccessToken : .authenticationFailure
        case 403:
            return message?.contains("HTTP") == true ? .httpsRequired : .forbidden
        case 404:
            return .apiNotFound
        case 405:
            return .methodNotAllowed
        case 429:
            return message?.contains("초당") == true ? .rateLimit : .dailyLimitExceeded
        case 500...599:
            return message?.contains("유지 보수") == true ? .serverMaintenance : .serverError
        default:
            return .unknown
        }
    }
}














/*400(요청 변수 확인)    필수 요청 변수가 없거나 요청 변수 이름이 잘못된 경우    API 레퍼런스에서 필수 요청 변수를 확인합니다.
 400(요청 변수 확인)    요청 변수의 값을 URL 인코딩으로 변환하지 않고 전송한 경우    API 레퍼런스에서 해당 요청 변수를 URL 인코딩으로 변환해야 하는지 확인합니다.
 401(인증 실패)    클라이언트 아이디와 클라이언트 시크릿이 없거나 잘못된 값인 경우    내 애플리케이션 메뉴에서 클라이언트 아이디와 클라이언트 시크릿을 확인합니다.
 401(인증 실패)    클라이언트 아이디와 클라이언트 시크릿을 HTTP 헤더에 정확히 설정하지 않고 호출한 경우    클라이언트 아이디와 클라이언트 시크릿은 URL이나 폼이 아니라 지정된 이름의 HTTP 요청 헤더로 전송해야 합니다.
 401(인증 실패)    API 권한이 설정되지 않은 경우    내 애플리케이션 메뉴의 API 설정 탭에서 해당 API가 추가되어 있는지 확인합니다.
 401(인증 실패)    네이버 로그인 API를 호출할 때 접근 토큰 파라미터(access_token)가 없거나 잘못된 값(만료된 접근 토큰)을 설정한 경우    접근 토큰이 HTTP 요청 헤더에 정확하게 설정됐는지, 값이 유효한지 확인합니다.
 403(서버가 허용하지 않는 호출)    HTTPS가 아닌 HTTP로 호출한 경우    API 요청 URL의 프로토콜이 HTTPS인지 확인합니다.
 403(호출 금지)    필수 요청 변수가 없거나 요청 변수 이름이 잘못된 경우    API 레퍼런스에서 필수 요청 변수를 확인합니다.
 403(호출 금지)    요청 변수의 값을 URL 인코딩으로 변환하지 않고 전송한 경우    API 레퍼런스에서 해당 요청 변수를 URL 인코딩으로 변환해야 하는지 확인합니다.
 404(API 없음)    API 요청 URL이 잘못된 경우    API 요청 URL에 오류가 있는지 확인합니다.
 405(메서드 허용 안 함)    HTTP 메서드를 잘못 호출한 경우. POST 방식으로 호출해야 하는데 GET 방식으로 호출한 경우 등입니다.    API 레퍼런스에서 HTTP 메서드를 확인합니다.
 429 (호출 한도 초과 오류)    오픈 API를 호출할 때 하루 허용량을 초과한 경우    하루 허용량 초과 시 제휴 신청을 합니다.
 429 (초당 호출 한도 초과 오류)    검색 API를 호출할 때 초당 호출량을 초과한 경우    https://developers.naver.com/notice/article/10000000000030659365 참고
 500(서버 오류)    필수 요청 변수가 없거나 요청 변수 이름이 잘못된 경우    API 레퍼런스에서 필수 요청 변수를 확인합니다.
 500(서버 오류)    요청 변수의 값을 URL 인코딩으로 변환하지 않고 전송한 경우    API 레퍼런스에서 해당 요청 변수를 URL 인코딩으로 변환해야 하는지 확인합니다.
 500(서버 오류)    API 호출은 정상적으로 했지만, API 서버 유지 보수나 시스템 오류로 인한 오류가 발생한 경우    개발자 포럼에 오류를 신고합니다.*/
