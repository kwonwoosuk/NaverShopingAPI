//
//  FavoriteItem.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 3/4/25.
//

import Foundation
import RealmSwift

class FavoriteItem: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId

    @Persisted var mallName: String
    @Persisted var title: String
    @Persisted var price: Int
    @Persisted var savedDate: Date
    
    convenience init(mallName: String, title: String, price: Int) {
        self.init()
        self.mallName = mallName
        self.title = title
        self.price = price
        self.savedDate = Date()
    }
}
