//
//  OnlineChatViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 01-06-21.
//

import UIKit
import MessageKit
import InputBarAccessoryView



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

class OnlineChatViewController: MessagesViewController, MessageCellDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mDismissBtn: UIBarButtonItem!
    @IBOutlet weak var mOnline: UIBarButtonItem!
    
    //MARK: Variables
    let currentUser = Sender(senderId: "self", displayName: "IOS Academy")
    let otherUser = Sender(senderId: "other", displayName: "BKD")
    var messages = [MessageType]()
    
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    
    func setupView() {
        configureMessagesViewController()
        configureDelegate()
        addMessages()
    }
    
    private func configureDelegate(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    private func configureMessagesViewController() {
        
        self.messageInputBar.inputTextView.font = font_search_cell
        self.messageInputBar.inputTextView.placeholderTextColor = color_chat_placeholder
        self.messageInputBar.inputTextView.placeholderLabel.font = font_chat_placeholder
        self.messageInputBar.inputTextView.placeholder = Constant.Texts.messagePlaceholder
        self.messageInputBar.sendButton.title = ""
        self.messageInputBar.backgroundView.backgroundColor = color_background
        self.messageInputBar.inputTextView.textColor = color_navigationBar
        self.messageInputBar.sendButton.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        self.messageInputBar.sendButton.isUserInteractionEnabled = false
        
        messagesCollectionView.backgroundColor = color_background
        messagesCollectionView.showsVerticalScrollIndicator = false
        deletAvatarPadding()
        
    }
    private func deletAvatarPadding(){
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
            layout.attributedTextMessageSizeCalculator.incomingAvatarSize = .zero
            layout.attributedTextMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.attributedTextMessageSizeCalculator.avatarLeadingTrailingPadding = .zero
        }
    }
    
    private func addMessages(){
        messages.append(Message(sender: currentUser,
                                messageId: "1",
                                sentDate: Date().addingTimeInterval(-186400),
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
    
    
    //MARK: - Action
    //MARK:-------------------------------
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OnlineChatViewController: MessagesLayoutDelegate, MessagesDataSource, MessagesDisplayDelegate {
    
//MARK: MessagesDataSource
//MARK: -----------------------------
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let sentDate = message.sentDate
        let sentDateString = MessageKitDateFormatter.shared.string(from: sentDate)
        let timeLabelFont: UIFont = font_search_cell!
        let timeLabelColor: UIColor = .white
        return NSAttributedString(string: sentDateString, attributes: [NSAttributedString.Key.font: timeLabelFont, NSAttributedString.Key.foregroundColor: timeLabelColor])
     }
    
    
//MARK: MessagesDisplayDelegate
//MARK: -----------------------------
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        
        let closure = { [self] (view: MessageContainerView) in
            if self.isFromCurrentSender(message: message) {
                view.style = .bubbleTailOutline(color_navigationBar!, .bottomRight, .pointedEdge)
                view.backgroundColor = .clear

            } else {
                view.roundCorners(corners: [.topLeft, .bottomLeft, .topRight], radius: 10)
                view.layer.borderColor = color_menu?.cgColor
                view.backgroundColor = color_menu!
            }
            
        }
        return .custom(closure)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return color_navigationBar!
        
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    
//MARK: MessagesLayoutDelegate
//MARK:-------------------------------
    func cellTopLabelHeight(for message: MessageKit.MessageType, at indexPath: IndexPath, in messagesCollectionView:
                                MessageKit.MessagesCollectionView) -> CGFloat {
        return 40
    }
    
}




//MARK: MessageInputBarDelegate
//MARK:-------------------------------
extension OnlineChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        messages.append(Message(sender: currentUser,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text(text)))
        // save(message)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.messagesCollectionView.scrollToLastItem()
            // will send message by request
            
        }
    }
}
