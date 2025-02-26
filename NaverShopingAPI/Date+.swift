//
//  Date+.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/26/25.
//

import Foundation
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
