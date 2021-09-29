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
    
    
    ///Add damage side in the list
    func addAccidentForm(accidentFormList:[AccidentFormModel]) -> [AccidentFormModel]{
        
        let accidentFormModel = AccidentFormModel(accidentFormImg: nil,
                                                  isTakePhoto: true)
       var  newAccidentFormList =  accidentFormList
        newAccidentFormList.append(accidentFormModel)
        return newAccidentFormList
    }
    
    
    ///Update damage side list
    func updateAccidentFormList(img: UIImage?,
                              isTakePhoto:Bool?,
                              accidentFormArr:[AccidentFormModel],
                              currIndex: Int) -> [AccidentFormModel] {
        
        var newImg = img
        if img == nil {
            newImg = accidentFormArr[currIndex].accidentFormImg
            
        }
        var newIsTakePhoto = isTakePhoto
        if isTakePhoto == nil {
            newIsTakePhoto = accidentFormArr[currIndex].isTakePhoto
            
        }
        let accidentFormModel = AccidentFormModel( accidentFormImg: newImg, isTakePhoto: newIsTakePhoto ?? false)
       var  accidentFormList =  accidentFormArr
        accidentFormList[currIndex] = accidentFormModel
        
        return accidentFormList
    }
    
    
    ///Check is accident form is filled
    func isAccidentFormIsFilled(accidentFormList: [AccidentFormModel])  -> Bool{
        if accidentFormList.count == 1 && accidentFormList.last?.accidentFormImg == nil {
            return false
        }
        return true
    }
    
    ///Check is damages side is filled
    func isDamagesSideIsFilled(damagesSideList:[DamagesSideModel]) -> (Bool, [DamagesSideModel]) {
        
        if damagesSideList.count == 1 &&
            damagesSideList.last?.damageImg == nil  {
            
            let damageSideModel = DamagesSideModel(damageSide:damagesSideList.last?.damageSide,  isTakePhotoError: true )
            var newDamagesSideList = damagesSideList
            newDamagesSideList[0] = damageSideModel
            
            return (isError: false, list: newDamagesSideList)
            
        } else if damagesSideList.last?.damageImg != nil &&
                    damagesSideList.last?.damageSide == nil {
            let damageSideModel = DamagesSideModel( damageImg: damagesSideList.last?.damageImg, isTakePhoto: false, isDamageSideError: true)
            var newDamagesSideList = damagesSideList
            newDamagesSideList[0] = damageSideModel
            
            return (isError: false, list: newDamagesSideList)
            
        }
        return (isError: true, list: damagesSideList)
    }

}
