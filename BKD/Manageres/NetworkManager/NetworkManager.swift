//
//  NetworkManager.swift
//  BKD
//
//  Created by Karine Karapetyan on 31-05-21.
//

import UIKit




class NetworkManager: NSObject {
   
    
    static func searchGooglePlase(place: String,
                                  completion: @escaping (_ value: Any?,_ status: Bool) -> Void){
        
        var url_search_place = "https://maps.googleapis.com/maps/api/place/textsearch/json?queary=\(place)&key=\(googleApiKey)"
        
        url_search_place = url_search_place.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var urlRequest = URLRequest(url: URL(string: url_search_place)!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                let jsonDic = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(jsonDic as? Any)
                completion(jsonDic, true)
            } else {
                print("searchGooglePlase error = \(error?.localizedDescription ?? " ")")
                completion(error, false)
            }
        }
        task.resume()
    }

}
