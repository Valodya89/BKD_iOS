//
//  AddAccidentDetailViewModel.swift
//  AddAccidentDetailViewModel
//
//  Created by Karine Karapetyan on 27-09-21.
//

import UIKit
import CoreLocation


class AddAccidentDetailViewModel {

    ///Get damage side
    func getDamageSide(side: String) -> String {
        switch side {
        case Constant.Texts.frontSide:
            return "FRONT"
        case Constant.Texts.backSide:
            return "BACK"
        case Constant.Texts.rightSide:
            return "RIGHT"
        default:
            return "LEFT"
        }
    }
    
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

    ///Get start accident date
    func getStartAccidanteDate(date: Date, time: Date) -> Double {
        let startDate = Date().combineDate(date: date, withTime: time)
        
        return startDate?.timeIntervalSince1970 ?? 0.0
    }
    
    ///Add accident
    func addAccident(id: String,
                     date: Date,
                     time: Date,
                     address: String,
                     coordinate: CLLocationCoordinate2D,
                     completion: @escaping (AddAccident?) -> Void) {
        //Result<AddAccident?, BkdError>
        let statDate = getStartAccidanteDate(date: date, time: time)
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.addAccident(id: id, statDate: statDate, address: address, longitude: coordinate.longitude, latitude: coordinate.latitude))) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<AddAccident>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                print(result.content as Any)
                completion(result.content)

            case .failure(let error):
                print(error.description)
                completion(nil)
                break
            }
        }
    }
    
    ///Add accident damege wit side
    func addAccidentWithSide(image: UIImage,
                     id: String,
                     side: String,
                     completion: @escaping (AddAccident?, String?) -> Void)  {
            
        let resizeImg = image.resizeImage(targetSize: CGSize(width: 1000, height: 1000))
        let damageSide = getDamageSide(side: side)
        
        SessionNetwork.init().request(with: URLBuilder(from: ImageUploadAPI.addAccidentDamge(image: resizeImg, id: id, side: damageSide))) { result in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<AddAccident>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil, nil)
                    return
                }
                print(result.message as Any)
                completion(result.content, nil)
            case .failure(let error):
                print(error.description)
                completion(nil, error.description)
                break
            }
            
        }
    }
    
    
    ///Add accident form
    func addAccidentForm(image: UIImage,
                     id: String,
                     completion: @escaping (AddAccident?, String?) -> Void)  {
            
        let resizeImg = image.resizeImage(targetSize: CGSize(width: 1000, height: 1000))
        SessionNetwork.init().request(with: URLBuilder(from: ImageUploadAPI.addAccidentForm(image: resizeImg, id: id))) { result in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<AddAccident>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil, nil)
                    return
                }
                print(result.message as Any)
                completion(result.content, nil)
            case .failure(let error):
                print(error.description)
                completion(nil, error.description)
                break
            }
            
        }
    }
    
}
