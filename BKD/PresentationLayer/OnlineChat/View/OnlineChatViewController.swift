//
//  OnlineChatViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 01-06-21.
//

import UIKit
import MessageKit
import InputBarAccessoryView



protocol OnlineChatViewControllerDelegate: AnyObject {
    
}

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

class OnlineChatViewController: MessagesViewController, StoryboardInitializable, MessageCellDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mDismissBtn: UIBarButtonItem!
    @IBOutlet weak var mOnline: UIBarButtonItem!
    @IBOutlet weak var mChatTbV: UITableView!
    //MARK: Variables
    weak var delegate: OnlineChatViewControllerDelegate?
    let currentUser = Sender(senderId: "self", displayName: "IOS Academy")
    let otherUser = Sender(senderId: "other", displayName: "BKD")
    var messages = [MessageType]()
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    func setupView() {
        configureDelegate()
        configureMessagesViewController()
        addMessages()
    }
    
    private func configureDelegate(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self

       // messagesCollectionView.messageCellDelegate = self
        
    }
    
    private func configureMessagesViewController(){
        messagesCollectionView.backgroundColor = color_background
        self.messageInputBar.backgroundView.backgroundColor = color_background
        self.messageInputBar.inputTextView.font = font_search_cell
        self.messageInputBar.inputTextView.textColor = color_navigationBar
        self.messageInputBar.inputTextView.placeholderTextColor = color_chat_placeholder
        self.messageInputBar.inputTextView.placeholderLabel.font = font_chat_placeholder
        self.messageInputBar.inputTextView.placeholder = "Type your message"
        self.messageInputBar.sendButton.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        self.messageInputBar.sendButton.title = ""
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
    
    //MARK: - Action
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OnlineChatViewController: MessagesLayoutDelegate, MessagesDataSource, MessagesDisplayDelegate {
    
    //MARK: MessagesDataSource
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    //MARK: MessagesLayoutDelegate
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (self.view.bounds.height * 0.0334)/2
    }
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        print("messageBottomLabelHeight called - section: \(indexPath.section)")
        return (self.view.bounds.height * 0.0334)/2

    }
//    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
//        return CGSize(width: self.view.bounds.width, height: 50)
//    }
    //MARK: MessagesDisplayDelegate
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        
        let closure = { [self] (view: MessageContainerView) in
            if self.isFromCurrentSender(message: message) {
//                view.layer.borderWidth = 1
//                view.layer.borderColor = color_navigationBar!.cgColor
                view.roundCornersWithBorder(corners: [.topLeft, .bottomRight, .topRight],
                                            radius: 10,
                                            borderColor: color_navigationBar!,
                                            borderWidth: 1.0)

            } else {
                view.roundCorners(corners: [.topLeft, .bottomLeft, .topRight], radius: 10)
                view.layer.borderColor = color_menu?.cgColor
            }
            
        }
        return .custom(closure)
    }
  
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return color_navigationBar!

    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
            return isFromCurrentSender(message: message) ? color_background! : color_menu!
        }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
   
    func messageTimestampLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            let messageDate = message.sentDate
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let dateString = formatter.string(from: messageDate)
            return
                NSAttributedString(string: dateString, attributes: [.font: UIFont.systemFont(ofSize: 12)])
        }
    
//    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//
//        let formatter = DateFormatter()
//        formatter.locale = NSLocale(localeIdentifier: "en") as Locale
//        formatter.dateFormat = "d MMM, YYYY"
//        let dateString = formatter.string(from: message.sentDate)//message.createdDate//formatter.string(from: message.sentDate)
//        let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.alignment = NSTextAlignment.center
//
//        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2), NSAttributedString.Key.paragraphStyle:paragraphStyle])
//    }
//    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let name = message.sentDate
//    return NSAttributedString(
//      string: name,
//      attributes: [
//        .font: UIFont.preferredFont(forTextStyle: .caption1),
//        .foregroundColor: UIColor(white: 0.3, alpha: 1)
//      ]
//    )
//     }
    
}




////MARK: MessageInputBarDelegate
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

        }
        // will send message by request
    }
   
}
