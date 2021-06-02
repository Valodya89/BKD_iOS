//
//  ChatViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 01-06-21.
//

import UIKit
import MessageKit

struct Sender: SenderType {
    var senderId: String
    
    var displayName: String
    
    
}

struct Message: MessageType {
    
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    
}

class ChatViewController: MessagesViewController {
    
    let currentUser = Sender(senderId: "self", displayName: "IOS Academy")
    let otherUser = Sender(senderId: "other", displayName: "BKD")

    var messages = [MessageType]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
        addMessages()
    }
    private func configureDelegate(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    private func addMessages(){
        messages.append(Message(sender: currentUser,
                                messageId: "1",
                                sentDate: Date().addingTimeInterval(-86400),
                                kind: .text("Hello Word")))
        messages.append(Message(sender: otherUser,
                                messageId: "2",
                                sentDate: Date().addingTimeInterval(-76400),
                                kind: .text("How are you?")))
        messages.append(Message(sender: currentUser,
                                messageId: "3",
                                sentDate: Date().addingTimeInterval(-66400),
                                kind: .text("Im fine and you?")))
        messages.append(Message(sender: otherUser,
                                messageId: "4",
                                sentDate: Date().addingTimeInterval(-56400),
                                kind: .text("Im so so Im so so Im so so Im so so Im so so Im so so Im so so Im so so Im so so Im so so")))
        messages.append(Message(sender: currentUser,
                                messageId: "5",
                                sentDate: Date().addingTimeInterval(-46400),
                                kind: .text("Why?")))
        messages.append(Message(sender: otherUser,
                                messageId: "6",
                                sentDate: Date().addingTimeInterval(-36400),
                                kind: .text("This is last message")))
    }
    
}

extension ChatViewController: MessagesLayoutDelegate, MessagesDataSource, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
