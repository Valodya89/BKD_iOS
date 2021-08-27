//
//  SocketService.swift
//  BKD
//
//  Created by Albert Mnatsakanyan on 26.08.21.
//

import SwiftStomp

final class SocketService: SocketServiceProtocol {
    
    let socketManager: SwiftStomp
//    let socket: SocketIOClient
    
    var completions: [String: ((Data) -> ())?] = [:]
    var connected: ((Result<Void, Error>) -> ())?
    
    var connectionType: StompConnectType?
    
    static var shared: SocketService = SocketService()
    
    lazy var connect: () = {
        self.socketManager.connect()
    }()
    
    
    private init() {
        self.socketManager = SwiftStomp(host: URL(string: "ws://167.86.112.213:8843/ws")!)
        self.socketManager.autoReconnect = true
        self.socketManager.delegate = self
    }
    
    func connect(completion: ((Result<Void, Error>) -> ())?) {
        self.connected = completion
        
        _ = self.connect
    }
    
    func listenToChat(id: String, result: @escaping (MessageResponse) -> ()) {
        completions["messages"] = { (data) in
            print("Data: \(data)")
            do {
                let message = try JSONDecoder().decode(MessageResponse.self, from: data)
                result(message)
            } catch {

            }
        }

        subscribe(name: id)
    }
    
//    func listenToBookNowSuccess(phoneNumber: String, result: @escaping (Result<TripActionModel, Error>) -> ()) {
//        let isSubribeCalled = completions[phoneNumber] == nil
//
//        completions[phoneNumber] = { (data) in
//            do {
//                let tripPhoneModel = try JSONDecoder().decode(TripActionModel.self, from: data)
//
//                result(.success(tripPhoneModel))
//            } catch {
//                result(.failure(error))
//            }
//        }
//
//        if isSubribeCalled {
//            subscribe(name: phoneNumber)
//        }
//    }
    
//    func listenTripUpdate(phoneNumber: String, result: @escaping (Result<TripActionModel, Error>) -> ()) {
//        let isSubribeCalled = completions[phoneNumber] == nil
//
//        completions[phoneNumber] = { (data) in
//            do {
//                let tripPhoneModel = try JSONDecoder().decode(TripActionModel.self, from: data)
//
//                print("Trip model in listenTripUpdate(): \(tripPhoneModel)")
//                result(.success(tripPhoneModel))
//            } catch {
//                result(.failure(error))
//            }
//        }
//
//        subscribe(name: phoneNumber)
//
//    }
    
//    func listenToScanSuccess(phoneNumber: String, result: @escaping (Result<TripActionModel, Error>) -> ()) {
//        let isSubribeCalled = completions[phoneNumber] == nil
//        print("Socket receive" )
//        completions[phoneNumber] = { (data) in
//            do {
//                let tripPhoneModel = try JSONDecoder().decode(TripActionModel.self, from: data)
//                result(.success(tripPhoneModel))
//                print("Trip model in listenToScanSuccess(): \(tripPhoneModel)")
//                print("Socket data: \(data)")
//            } catch {
//                result(.failure(error))
//            }
//        }
//
//        subscribe(name: phoneNumber)
//    }
    
    func subscribe(name: String) {
        print("Did subCscripe to event named: \(name)")
        self.socketManager.subscribe(to: name)
    }
    
    func setupInitialSubscribers() {
//        guard let phoneNumber = StorageManager().fetch(key: .phoneNumber, type: String.self) else { return }
//        self.socketManager.subscribe(to: phoneNumber)
    }
}

extension SocketService: SwiftStompDelegate {
    
    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String : String]) {
        print("Did receive message \(String(describing: message))")
        guard let message = message as? String else { return }
        let data = Data(message.utf8)
        guard let completion = completions["messages"] else { return }
        print("Did send message to completion \(destination)")
        completion?(data)
    }
    
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        connectionType = connectType

        switch connectType {
        case .toStomp:
            print("did connect to socket type: Stomp")
            self.setupInitialSubscribers()
            self.connected?(.success(()))
        case .toSocketEndpoint:
            print("did connect to socket type: EndPoint")
        }
    }
    
    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        self.connected?(.failure(NetworkError.responseError("Error")))
        print("Did disconnect from socket type \(disconnectType)")
    }
    
    func onSocketEvent(eventName: String, description: String) {
        print("Did receive event \(eventName)")
    }
    
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        print("On receipt from stop \(swiftStomp)")
    }
    
    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        print("On error stop \(swiftStomp)")
    }
}
