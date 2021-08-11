//
//  PaymentViewModel.swift
//  BKD
//
//  Created by Albert Mnatsakanyan on 10.08.21.
//

import Foundation

final class PaymentViewModel {
    
    private let network = SessionNetwork()
    
    
    func getAttachedCardURL(completion: @escaping (Result<String, BkdError>) -> Void) {
        
        network.request(with: URLBuilder(from: PaymentAPI.attachCard)) { (result) in
            switch result {
            case .success(let data):
                guard let attachedCardResponse = BkdConverter<BaseResponseModel<AttachedCardResponse>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(.failure(BkdError(error: .serverError)))
                    return
                }
                guard let attachedCardURL = attachedCardResponse.content?.checkoutUrl else {
                    completion(.failure(BkdError(error: .serverError)))
                    return
                }
                completion(.success(attachedCardURL))
            case .failure(let error):
                print(error.description)
                completion(.failure(BkdError(error: .responseError(error.description))))
                break
            }
        }
    }
}
