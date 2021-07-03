//
//  SignInViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 02-07-21.
//

import UIKit

class SignInViewModel: UIView {
    let validator = Validator()

    
    ///Checking is all fields are filled
    func areFieldsFilled(firtStr: String?, secondStr: String?,
                                     didResult: @escaping (Bool) -> ()) {
        didResult(validator.areFieldsFilled(firstStr: firtStr, secondStr: secondStr))
    }

}
