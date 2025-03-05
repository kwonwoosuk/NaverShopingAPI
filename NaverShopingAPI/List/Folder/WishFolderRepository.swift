//
//  WishFolderRepository.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 3/6/25.
//

import Foundation
import RealmSwift

protocol WishFolderRepository {
    func createItem(name: String)
    func fetchAll() -> Results<WishFolder>
}

final class WishFolderTableRepository: WishFolderRepository {
    private let realm = try! Realm()
    
    func createItem(name: String) {
        do {
            try realm.write {
                let wishFolder = WishFolder(name: name)
                realm.add(wishFolder)
            }
        } catch {
            print("폴더 저장 실패")
        }
    }
    
    func fetchAll() -> Results<WishFolder> {
        return realm.objects(WishFolder.self)
    }
}
