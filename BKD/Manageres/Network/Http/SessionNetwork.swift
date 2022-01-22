//
//  SessionNetwork.swift
//  MimoBike
//
//  Created by Albert on 15.05.21.
//

import UIKit

struct PreactivateStatusModel: Decodable {
    let status: PreactivateStatus
    let message: String
}
 
enum PreactivateStatus: Int, Decodable {
    case messageBlocked = 3
    case success = 0
}

enum NetworkSessionErrors: Error {
    case invalidRequest(request: URLRequest?)
    case resultsError(error: Error)
    case sessionExpired
    case invalidStatusCode(code: Int)
    case unknown(message: String)
    
    var description: String {
        switch self {
        case .invalidRequest(let request):
            return "Ivalid request: \(String(describing: request))"
        case .resultsError(let error):
            return "Results error :\(error.localizedDescription)"
        case .sessionExpired:
            return "Session expired"
        case .invalidStatusCode(code: let code):
            return "Invalid status code: \(code)"
        case .unknown(message: let error):
            return ""
        }
    }
}

final class SessionNetwork: SessionProtocol {
    
    private var dispatchWorkItem: DispatchWorkItem? = nil
    private var needAccessTokenUpdate: Bool = false
    private var keychainManager = KeychainManager()
        
    func request(with builderProtocol: URLBuilderProtocol, _ completion: @escaping (Result<Data,NetworkSessionErrors>) -> (), _ queue: DispatchQueue = .global()) {
        
        if keychainManager.isTokenExpired() && needAccessTokenUpdate {
            dispatchWorkItem?.cancel()
            needAccessTokenUpdate = false
            let refreshToken = keychainManager.getRefreshToken() ?? ""
            let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
            request(with: URLBuilder(from: AuthAPI.getAuthRefreshToken(refreshToken: refreshToken))) { result in
                switch result {
                case .success(let data):
                    guard let tokenResponse = BkdConverter<TokenResponse>.parseJson(data: data as Any) else { return }
                    self.keychainManager.parse(from: tokenResponse)
                case .failure(let error):
                    completion(.failure(error))
                print(error)
                }
                builderProtocol.rebuild()
                queue.async(execute: self.dispatchWorkItem!)
                self.needAccessTokenUpdate = true
                return
            }
        }

        dispatchWorkItem = DispatchWorkItem {
            guard let request = builderProtocol.getRequst() else {
                completion(.failure(.resultsError(error: NetworkError.validatorError("Invalide request"))))
                return
            }
            let session = URLSession(configuration: .default)
                session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard error == nil else {
                        completion(.failure(.invalidRequest(request: request)))
                        return
                    }
                    guard let data = data else {
                        completion(.failure(.invalidRequest(request: request)))
                        return
                    }
                    
                     guard let response = response as? HTTPURLResponse else {
                        completion(.failure(.invalidRequest(request: request)))
                        return
                    }
                    
                    guard (200 ..< 299) ~= response.statusCode else {
                        if response.statusCode == 401 {
                           // SessionExpiredAlert.showAlert()
                            completion(.failure(.invalidStatusCode(code: response.statusCode)))
                            return
                        }
                        completion(.failure(.invalidStatusCode(code: response.statusCode)))
                        return
                    }
                    completion(.success(data))
                }
            }.resume()
        }
        queue.async(execute: self.dispatchWorkItem!)
    }
}
