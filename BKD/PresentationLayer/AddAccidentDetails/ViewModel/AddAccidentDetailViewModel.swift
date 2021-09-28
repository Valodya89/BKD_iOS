//
//  AddAccidentDetailViewModel.swift
//  AddAccidentDetailViewModel
//
//  Created by Karine Karapetyan on 27-09-21.
//

import UIKit

class AddAccidentDetailViewModel {


    ///Update damage side list
    func updateDamageSideList(side: String?,
                              img: UIImage?,
                              isTakePhoto:Bool?,
                              damageSideArr:[DamagesSideModel],
                              currIndex: Int) -> [DamagesSideModel] {
        
        var newSide = side
        if side == nil {
            newSide = damageSideArr[currIndex].damageSide
            
        }
        var newImg = img
        if img == nil {
            newImg = damageSideArr[currIndex].damageImg
            
        }
        var newIsTakePhoto = isTakePhoto
        if isTakePhoto == nil {
            newIsTakePhoto = damageSideArr[currIndex].isTakePhoto
            
        }
        let damageModel = DamagesSideModel(damageSide: newSide, damageImg: newImg, isTakePhoto: newIsTakePhoto ?? false)
       var  damageList =  damageSideArr
        damageList[currIndex] = damageModel
        return damageList
    
    }
    
    
    
    ///Add damage side in the list
    func addDamageSide(damageSideArr:[DamagesSideModel]) -> [DamagesSideModel]{
        
        let damageModel = DamagesSideModel(damageSide: nil,
                                           damageImg: nil,
                                           isTakePhoto: true)
       var  damageList =  damageSideArr
        damageList.append(damageModel)
        return damageList
    }
    

}
