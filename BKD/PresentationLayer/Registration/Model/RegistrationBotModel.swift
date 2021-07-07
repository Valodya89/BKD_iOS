//
//  RegistrationBotModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit

struct RegistrationBotModel {
    public var msgToFill: String?
    public var examplePhoto: UIImage?
    public var msgToFillBold: String?
    public var viewDescription: String?
    public var userRegisterInfo: UserRegisterInfo?
}

struct UserRegisterInfo {
    public var photo: UIImage?
    public var string: String?
    public var date: Date?
    public var placeholder: String?
    public var isFilled: Bool = false

}
