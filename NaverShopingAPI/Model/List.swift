//
//  List.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 1/17/25.
//

import UIKit

struct List: Decodable {
    //let lastBuildDate: String //  정렬옵션에서 날짜순할때 쓰면될거같고....ㄹ
    let total: Int
    let start: Int
    let display: Int
    let items: [Item]
}

struct Item: Decodable {
    let image: String //이미지 보여주고
    let mallName: String // 월드캠핑카
    let title: String // 스타리아 2층캠핑카 어쩌고저쩌고 두줄
    let lprice: String // 얼마얼마     - 가격높은순?sort 를 asc가격순으로 오름차순 정렬 dsc가격순으로 내림차순 정렬 -메서드 만들어서 네트워크 다시 불러오면 알아서 정렬해줄듯  ⭐️sim 정확도순으로 내림차순 이걸 기본으로 해두자
    var deleteTagTitle: String {
        get {
            title.replacingOccurrences(of: "<[^>]+>|&quot;",
                                        with: "",
                                        options: .regularExpression,
                                        range: nil)
        }
    }
}
