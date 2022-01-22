//
//  CompareViewModel.swift
//  CompareViewModel
//
//  Created by Karine Karapetyan on 07-10-21.
//

import UIKit

class CompareViewModel: NSObject {
    
    //get car type name
    func getCarTypeName(carModel: CarsModel) -> String {
        let carType = ApplicationSettings.shared.carTypes?.filter{
              $0.id == carModel.type
      }
        return carType?.first?.name ?? ""
    }
    
    //get car type id
    func getCurrentCarType(typeName: String) -> String {
        let carType = ApplicationSettings.shared.carTypes?.filter{
              $0.name == typeName
      }
        return carType?.first?.id ?? ""
    }
    
    
    //get car model
    func getCurrentCarModel(carsList: [CarsModel]?, carId: String?) -> CarsModel? {
        guard let carList = carsList else {return nil}
        let carModel = carList.filter{
              $0.id == carId ?? ""
      }
        return carModel.first
    }
    
    //Get car details list
    func getCarInfoList(carModel: CarsModel) -> [DetailsModel] {
        
        var detailsList: [DetailsModel] = []
        let carDetails =  MainViewModel().getDetail(carModel: carModel)
        
        detailsList.append(DetailsModel(image: img_card!, title: carModel.driverLicenseType))
        detailsList.append(DetailsModel(image: img_cube!, title:  String(carModel.volume) + Constant.Texts.mCuadrad))
        
        detailsList.append(DetailsModel(image: img_kg!, title:  String(carModel.loadCapacity) + Constant.Texts.kg))
        if let exterior = carModel.exterior {
            detailsList.append(DetailsModel(image: img_carM!, title:  exterior.getExterior()))
        }
        detailsList.append(contentsOf: carDetails)
        return detailsList
    }

}
