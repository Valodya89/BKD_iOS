//
//  LocalizationModel.swift
//  MimoBike
//
//  Created by Sedrak Igityan on 6/3/21.
//

import Foundation

final class LocalizationModel {
    
    private var strings: [String: String] = [:]
    private(set) static var shared: LocalizationModel?
    
    @discardableResult
    init(data: Data) throws {
        guard let contents = try JSONDecoder().decode(BaseResponseModel<[String: String]>.self, from: data).content else { return }
         
        self.strings = contents
        LocalizationModel.shared =  self
    }
    
    func getText(for key: String) -> String {
        return strings[key] ?? key
    }
    
    func getKey(from value: String) -> String {
        return (strings as NSDictionary?)?.allKeys(for: value).first as? String ?? value
    }
}

struct LocalizableContent: Decodable {
    
    let key: String
    let language: String
    let value: String
}
