//
//  Settings.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-07-21.
//

import UIKit

struct  Settings: Codable {
    let id: String
    let registrationAgreementUrl: String
    let reservationAgreementUrl: String
    let workStart: String
    let workEnd: String
    let customLocationMinimalValue: Double
    let metadata: Metadata
}


struct  Metadata: Codable {
    let defaultLanguage: String
    let NonWorkingHoursValue: String
    let AdditionalDriverValue: String
    let AdditionalDriverAgreementUrl: String
    let FAQUrl: String
    let AboutUsUrl: String
    let CallBKDPhone: String
    let ContactInsurancePhone: String
    let ContactBKDForAccidentPhone: String
    let ContactUsPhone: String
    let PrivacyPolicyUrl: String
    let TermsOfUseUrl: String
    let termsAndConditions: String
}


struct  FlexibleTimes: Codable {
    let id: String
    let type: String
    let start: String?
    let end: String?
    let active: Bool
}




            
