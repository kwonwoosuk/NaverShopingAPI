//
//  WishFolder.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 3/6/25.
//

import Foundation
import RealmSwift

final class WishFolder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var wishList: RealmSwift.List<WishList>
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
