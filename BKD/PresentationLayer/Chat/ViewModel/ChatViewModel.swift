//
//  ChatViewModel.swift
//  BKD
//
//  Created by Albert Mnatsakanyan on 26.08.21.
//

import UIKit

final class ChatViewModel {
    
    private let network = SessionNetwork()
    private let socket = SocketService.shared
    private let keychain = KeychainManager()
    private let validator = Validator()
    private var chatID = ""
    private var messages: [Message] = []

    
    private func socketConnected(completion: ((Result<Void, Error>) -> Void)?) {
        let isSocketConnected = socket.socketManager.connectionStatus == .fullyConnected || socket.socketManager.connectionStatus == .socketConnected
        if isSocketConnected {
            completion?(.success(()))
            return
        }
        
        socket.connect(completion: completion)
    }
    
    private func listenNewMessages(completion: @escaping ((Result<[Message], Error>) -> Void)) {
        socketConnected { result in
            switch result {
            case .success:
                self.socket.listenToChat(id: self.chatID) { [weak self] message in
                    guard let self = self else { return }
                    print("message = \(message)")
                    self.messages.append(Message(messageResponse: message))
                    completion(.success(self.messages))
                }
            case .failure(let error):
                completion(.failure(BkdError(error: .responseError(error.localizedDescription))))
            }
        }
    }
    
    func getMessages(completion: @escaping ((Result<[Message], Error>) -> Void)) {
        var name = ""
        var type = ""
        var identifier = ""
        if keychain.isUserLoggedIn() {
            name = "Ruben"
            type = "USER"
            identifier = keychain.getAccessToken() ?? ""
        } else {
            name = "Ruben"
            type = "DEVICE"
            identifier = UIDevice.current.identifierForVendor?.uuidString ?? ""
        }
        
        network.request(with: URLBuilder(from: AuthAPI.getChatID(name: name, type: type, identifier: identifier))) { [self] (result) in
            switch result {
            case .success(let data):
                guard let chatInfoResponse = BkdConverter<BaseResponseModel<ChatInfo>>.parseJson(data: data as Any)?.content else { return }
                self.chatID = chatInfoResponse.id
                self.listenNewMessages(completion: completion)
                print("chatID = \(self.chatID)")
                guard let lastMessages = chatInfoResponse.messages?.reversed() else {
                    completion(.success(self.messages))
                    return }
                self.messages = lastMessages.compactMap { Message(messageResponse: $0) }
                completion(.success(self.messages))
            case .failure(let error):
                print(error.description)
                completion(.failure(BkdError(error: .responseError(error.description))))
            }
        }
    }
    
    func sendMessage(message: String, completion: @escaping ((Result<[Message], Error>) -> Void)) {
        var userIdentifier = ""
        if keychain.isUserLoggedIn() {
            userIdentifier = keychain.getAccessToken() ?? ""
        } else {
            userIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? ""
        }
        network.request(with: URLBuilder(from: AuthAPI.sendMessage(chatID: chatID, message: message, userIdentifier: userIdentifier))) { (result) in
            switch result {
            case .success(let data):
                guard let messageResponse = BkdConverter<BaseResponseModel<MessageResponse>>.parseJson(data: data as Any) else { return }
                guard let message = messageResponse.content else { return }
                self.messages.append(Message(messageResponse: message))
                print("Sent message: \(message)")
                completion(.success(self.messages))
            case .failure(let error):
                print(error.description)
                completion(.failure(BkdError(error: .responseError(error.description))))
            }
        }
    }
    
    func numberOfSections() -> Int {
        return messages.count
    }
    
    func messageForItem(for indexPath: IndexPath) -> Message {
        return messages[indexPath.section]
    }
    
    // MARK: - OFFLINE
    func isValidEmail(email: String, didResult: @escaping (Bool) -> ()) {
        didResult( validator.isValidEmail(email))
    }
}
