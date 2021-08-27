//
//  Message.swift
//  BKD
//
//  Created by Albert Mnatsakanyan on 26.08.21.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    init(messageResponse: MessageResponse) {
        var senderId = ""
        if messageResponse.destination == "USER" {
            senderId = "other"
        } else if messageResponse.destination == "ADMIN" {
            senderId = "self"
        }
        self.sender = Sender(senderId: senderId, displayName: "")
        self.messageId = messageResponse.id
        self.sentDate = Date(timeIntervalSince1970: messageResponse.sentAt / 1000)
        self.kind = .text(messageResponse.message)
    }
}

struct MessageResponse: Decodable {
    let id: String
    let message: String
    let from: String?
    let to: String?
    let chatId: String
    let sentAt: Double
    let destination: String
}
