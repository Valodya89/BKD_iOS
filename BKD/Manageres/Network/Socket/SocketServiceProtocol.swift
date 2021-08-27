//
//  SocketServiceProtocol.swift
//  BKD
//
//  Created by Albert Mnatsakanyan on 26.08.21.
//

import Foundation

protocol SocketServiceProtocol {
    func listenToChat(id: String, result: @escaping (MessageResponse) -> ())
//    func listenToBookNowSuccess(phoneNumber: String, result: @escaping (Result<TripActionModel, Error>) -> ())
}
