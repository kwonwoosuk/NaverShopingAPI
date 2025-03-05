//
//  WishList.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 3/6/25.
//

import Foundation
import RealmSwift

final class WishList: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var date: Date
    @Persisted(originProperty: "wishList") var folder: LinkingObjects<WishFolder>
    
    convenience init(name: String) {
        self.init()
        self.name = name
        self.date = Date()
    }
}
