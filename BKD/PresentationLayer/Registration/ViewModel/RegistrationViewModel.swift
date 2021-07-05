//
//  RegistrationViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 04-07-21.
//

import UIKit

class RegistrationViewModel: NSObject {
    let validator = Validator()

    
    ///Checking is all fields are filled
    func areFieldsFilled(email: String?,
                      password: String?,
                  confirmpassword: String?,
                        didResult: @escaping (Bool) -> ()) {
        didResult(validator.areFieldsFilled(email: email, password: password, confirmpassword: confirmpassword))
            
    }
}
