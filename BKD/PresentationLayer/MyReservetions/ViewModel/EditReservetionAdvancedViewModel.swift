//
//  EditReservetionAdvancedViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-01-22.
//

import Foundation

final class EditReservetionAdvancedViewModel {
    
    ///Get edited reservation accessories list
    func getEditedAccessories(editAccessories: [EditAccessory]) -> [AccessoriesEditModel]? {
        
        return AccessoriesEditModel().getEditedAccessories(editAccessories: editAccessories)
        
    }
}
