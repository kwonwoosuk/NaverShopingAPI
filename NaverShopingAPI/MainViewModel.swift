//
//  MainViewModel.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/7/25.
//

import Foundation

class MainViewModel {
    
    //searchTextField에서 받을 텍스트
    let inputSearchBarText: Observable<String?> = Observable(nil)
    let outputSearchBatText: Observable<String?> = Observable(nil)
    
    let outputValidAleart = Observable(false)
    
    init() {
        inputSearchBarText.lazybind { _ in
            self.validateText()
        }
    }
    
    private func validateText() {
        guard let text = self.inputSearchBarText.value else {
            self.outputValidAleart.value = true
            return
        }
        
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        
        guard trimmedText.count >= 2 else {
            self.outputValidAleart.value = true
            return
        }
        self.outputValidAleart.value = false
        self.outputSearchBatText.value = trimmedText
    }
}
