//
//  ChatInfo.swift
//  BKD
//
//  Created by Albert Mnatsakanyan on 26.08.21.
//

import Foundation

struct ChatInfo: Decodable {
    let id: String
    let messages: [MessageResponse]?
}
