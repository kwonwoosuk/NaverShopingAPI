//
//  WishListRepository.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 3/6/25.
//

import Foundation
import RealmSwift

protocol WishListRepository {
    func getFileURL()
    func fetchAll() -> Results<WishList>
    func createItemInFolder(folder: WishFolder)
    func createItem(name: String, folder: WishFolder)
    func deleteItem(data: WishList)
//    func updateItem(data: WishList)
}

final class WishListTableRepository: WishListRepository {
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "")
    }
    
    func fetchAll() -> Results<WishList> {
        let data = realm.objects(WishList.self)
            .sorted(byKeyPath: "date", ascending: false)
        
        return data
    }
    
    func createItemInFolder(folder: WishFolder) {
       
        do {
            try realm.write {
                
                let data = realm.objects(WishList.self)
                    .sorted(byKeyPath: "date", ascending: false)
                    .where { $0.folder == folder } // 선택한 폴더에 넣어줘라 !
                    .first!
                
                folder.wishList.append(data)
                realm.add(data)
                print("렘에 저장 완료")
            }
        } catch {
            print("렘에 저장이 실패한 경우")
        }
    }
    
    
    func createItem(name: String, folder: WishFolder) {
        do {
            try realm.write {
                let data = WishList(name: name)
                folder.wishList.append(data)
            }
        } catch {
            print("렘 데이터 저장 실패")
        }
    }
    
    func deleteItem(data: WishList) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("렘 데이터 삭제 실패")
        }
    }
    
 
}
