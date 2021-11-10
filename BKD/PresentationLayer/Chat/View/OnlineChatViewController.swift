//
//  OnlineChatViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 01-06-21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

final class OnlineChatViewController: MessagesViewController, StoryboardInitializable {
    
    //MARK: Outlets
    
    @IBOutlet weak var mDismissBtn: UIBarButtonItem!
    @IBOutlet weak var mOnline: UIBarButtonItem!
    
    
    //MARK: Variables
    
    private let viewModel = ChatViewModel()
    private let currentUser = Sender(senderId: "self", displayName: "IOS Academy")
    
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - IBActions
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Functions
    
    private func setupView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        configureMessagesViewController()
        configureDelegate()
        getMessages()
    }
    
    private func configureDelegate(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    private func configureMessagesViewController() {
        messageInputBar.inputTextView.font = font_search_cell
        messageInputBar.inputTextView.placeholderTextColor = color_chat_placeholder
        messageInputBar.inputTextView.placeholderLabel.font = font_chat_placeholder
        messageInputBar.inputTextView.placeholder = Constant.Texts.messagePlaceholder
        messageInputBar.sendButton.title = ""
        messageInputBar.backgroundView.backgroundColor = color_background
        messageInputBar.inputTextView.textColor = color_navigationBar
        messageInputBar.sendButton.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        messageInputBar.sendButton.isUserInteractionEnabled = false
        
        messagesCollectionView.backgroundColor = color_background
        messagesCollectionView.showsVerticalScrollIndicator = false
        
        //        messagesCollectionView.contentInset.bottom = 20
        
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
    
    /// Get messages
    private func getMessages() {
        viewModel.getMessages { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.messagesCollectionView.reloadData()
            case .failure(let error):
                self.showErrorAlertMessage(error.localizedDescription)
            }
        }
    }
    
    /// Send message
    private func sendMessage(_ message: String) {
        viewModel.sendMessage(message: message) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.messagesCollectionView.reloadData()
            case .failure(let error):
                self.showErrorAlertMessage(error.localizedDescription)
            }
        }
    }
}

extension OnlineChatViewController: MessagesLayoutDelegate, MessagesDataSource, MessagesDisplayDelegate {
    
    //MARK: MessagesDataSource
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewModel.messageForItem(for: indexPath)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let sentDate = message.sentDate
        let sentDateString = MessageKitDateFormatter.shared.string(from: sentDate)
        let timeLabelFont: UIFont = font_search_cell!
        let timeLabelColor: UIColor = color_filter_fields!
        return NSAttributedString(string: sentDateString, attributes: [NSAttributedString.Key.font: timeLabelFont, NSAttributedString.Key.foregroundColor: timeLabelColor])
    }
    
    
    //MARK: MessagesDisplayDelegate
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let closure = { [self] (view: MessageContainerView) in
            if self.isFromCurrentSender(message: message) {
                view.backgroundColor = .clear
//                view.roundCornersWithBorder(corners: [.topLeft, .bottomLeft, .topRight], radius: 10, borderColor: color_navigationBar!, borderWidth: 1)
                view.layer.cornerRadius = 10
                view.setBorder(color: color_navigationBar!, width: 1)
            } else {
//                view.roundCorners(corners: [.topLeft, .bottomRight, .topRight], radius: 10)
                view.layer.cornerRadius = 10
                view.layer.borderColor = color_menu?.cgColor
                view.backgroundColor = color_menu!
            }
        }
        if indexPath.section == viewModel.numberOfSections() - 1 {
            messagesCollectionView.scrollToItem(at: indexPath, at: MessagesCollectionView.ScrollPosition.bottom, animated: true)
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
    
    func cellTopLabelHeight(for message: MessageKit.MessageType, at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> CGFloat {
        return 40
    }
}

//MARK: - MessageInputBarDelegate

extension OnlineChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        self.messageInputBar.sendButton.isUserInteractionEnabled = text != ""
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        sendMessage(text)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.messagesCollectionView.scrollToLastItem()
            // will send message by request
        }
    }
}
