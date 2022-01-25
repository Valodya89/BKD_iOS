//
//  AccessoriesViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 27-06-21.
//

import UIKit
import SwiftUI

class AccessoriesViewModel: NSObject {
   
    /// Get accessories total price
    func getTotalAccesories(accessoryPrice: Double,
                              totalPrice: Double,
                              isIncrease: Bool,
                              didResult: @escaping (String) -> ()) {
        var value: Double = 0.0
        if isIncrease {
            value = totalPrice + accessoryPrice
        } else {
            value = totalPrice - accessoryPrice
        }
       // let newValue = String(value).replacingOccurrences(of: ".", with: ",")

        didResult(String(value))
    }
    
    /// get accessories  list
     func getAccessories(carID: String, completion: @escaping ([Accessories]?, String?) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getAccessories(carID: carID))) {  (result) in
            
            switch result {
            case .success(let data):
                guard let accessories = BkdConverter<BaseResponseModel<[Accessories]>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil, nil)
                    return
                }
                completion(accessories.content, nil)
            case .failure(let error):
                print(error.description)
                completion(nil,error.description)
                break
            }
        }
    }
    
    ///Get accessories which status is active
    func getActiveAccessoryList(accessories:[Accessories]) -> [AccessoriesEditModel] {
        var activeAccessories:[AccessoriesEditModel] = []
        accessories.forEach { accessory in
            if accessory.active {
                let accesoryedit = AccessoriesEditModel(id: accessory.id,
                                                        imageUrl: accessory.image.getURL() ,
                                                        name: accessory.name,
                                                        maxCount: accessory.maxCount, price: accessory.price)
                activeAccessories.append(accesoryedit)
            }
        }
        return activeAccessories
    }
    
    
    ///Get edit accessories edit list
    func getAccessoriesEditList(rent: Rent?, accessoriesList:[AccessoriesEditModel]) -> (accessories: [AccessoriesEditModel]?, totalPrice: Double) {
        
        guard let rentAccessories = rent?.accessories else {return (nil, 0.0)}
        var activeAccessories:[AccessoriesEditModel] = []
        var totalPrice = 0.0
        
        accessoriesList.forEach { accessory in
            
            let rentAccessory = rentAccessories.filter{$0.id == accessory.id}.first
            if rentAccessory != nil {
                totalPrice += (accessory.price! * rentAccessory!.count)
                let accesoryEdit = AccessoriesEditModel(id: rentAccessory!.id as String,
                                                        imageUrl: accessory.imageUrl,
                                                        name: accessory.name,
                                                        count: Int(rentAccessory!.count),
                                                        maxCount: accessory.maxCount,
                                                        isAdded: true,
                                                        price: accessory.price,
                                                        totalPrice: totalPrice)
                activeAccessories.append(accesoryEdit)
            } else {
                activeAccessories.append(accessory)
            }
        }
        return (activeAccessories, totalPrice)
    }
    
    ///Set edit accessories
    func getEditAccessories(accessories: [AccessoriesEditModel]?) -> [EditAccessory] {
        var editList:[EditAccessory] = []
        accessories?.forEach({ accessory in
            if accessory.isAdded {
                editList.append(EditAccessory(id: accessory.id ?? "", count: Double(accessory.count ?? 0), accessory: accessory))
            }
        })
        return editList
    }
    
    ///Edit reservation accessories
    func editReservationAccessories( isAdd: Bool,
                                     editAccessiries: AccessoriesEditModel,
                                     editReservationAccessories: [EditAccessory]?, completion: @escaping ([EditAccessory]) -> Void) {
        guard var editList = editReservationAccessories else {
            completion([])
            return
        }
        
        if isAdd { //Add accessory
            if editList.count > 0 {
                let editResrerAccessory = editList.filter {$0.id == editAccessiries.id}.first
                if editResrerAccessory == nil { //Add accessory
                    let edit = EditAccessory(id: editAccessiries.id ?? "",
                                             count: Double(editAccessiries.count ?? 0), accessory: editAccessiries)
                    editList.append(edit)
                } else { //Increase or decrease accessory
                    for i in 0 ..< editList.count {
                        if editList[i].id == editAccessiries.id {
                            editList[i].count = Double(editAccessiries.count ?? 0)
                            editList[i].accessory = editAccessiries
                            completion(editList)
                        }
                    }
                }
           
            } else  {
                let edit = EditAccessory(id: editAccessiries.id ?? "",
                                         count: Double(editAccessiries.count ?? 0), accessory: editAccessiries)
                editList.append(edit)
            }
        } else { //delete accessory
            for i in 0 ..< editList.count {
                if editList[i].id == editAccessiries.id {
                    editList.remove(at: i)
                    completion(editList)
                    return
                }
            }
        }
        completion(editList)
    }
    
    
    ///Is add button enabled
    func isAddEnabled(editedAccessories: [EditAccessory]?, currItem: AccessoriesEditModel) -> Bool {
        let item = editedAccessories?.filter({$0.id == currItem.id}).first
        guard item != nil else {return true}
        
        return false
    }
    
   ///Is decrease enambled
    func isDecreaseEnabled(editedAccessories: [EditAccessory]?, currItem: AccessoriesEditModel) -> Bool {
        let oldItem = editedAccessories?.filter({$0.id == currItem.id}).first
        guard oldItem != nil else {return true}
        return oldItem!.count < Double(currItem.count ?? 0)
    }
    
    ///Is edited accessory list
    func isEditedAccessoryList(oldAccessories: [EditAccessory],
                               editedAccessories: [EditAccessory]) -> Bool {
        if oldAccessories.count < editedAccessories.count {
            return true
        } else if oldAccessories.count == editedAccessories.count {
            
            for i in 0 ..< oldAccessories.count {
                if (oldAccessories[i].id == editedAccessories[i].id) &&
                    (oldAccessories[i].count < editedAccessories[i].count) {
                    return true
                }
            }
        }
        return false
    }
}
