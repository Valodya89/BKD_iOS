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
    func getAccessoriesEditList(rent: Rent?, accessories:[Accessories]) -> (accessories: [AccessoriesEditModel]?, totalPrice: Double) {
        
        guard let rentAccessories = rent?.accessories else {return (nil, 0.0)}
        var activeAccessories:[AccessoriesEditModel] = []
        var totalPrice = 0.0
        
        rentAccessories.forEach { rentAccessory in
            accessories.forEach { accessory in
                
                if accessory.active {
                    if accessory.id == rentAccessory.id {
                        totalPrice += (accessory.price * rentAccessory.count)
                        let accesoryEdit = AccessoriesEditModel(id: accessory.id,
                                                                imageUrl: accessory.image.getURL(),
                                                                name: accessory.name,
                                                                count: Int(rentAccessory.count),
                                                                maxCount: accessory.maxCount,
                                                                isAdded: true,
                                                                price: accessory.price)
                        activeAccessories.append(accesoryEdit)
                    } else {
                        let accesoryEdit = AccessoriesEditModel(id: accessory.id,
                                                                imageUrl: accessory.image.getURL(),
                                                                name: accessory.name,
                                                                maxCount: accessory.maxCount, price: accessory.price)
                        activeAccessories.append(accesoryEdit)
                    }
                }
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
                }
            }
            
            
        }
        completion(editList)
    }
}
