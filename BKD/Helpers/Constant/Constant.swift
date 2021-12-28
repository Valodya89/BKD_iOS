//
//  Constant.swift
//  BKD
//
//  Created by Karine Karapetyan on 13-05-21.
//
 import UIKit
import SwiftUI

struct Constant {
    
    struct Storyboards {
        static let main = "Main"
        static let seeMap = "SeeMap"
        static let customLocation = "CustomLocation"
        static let searchCustomLocation = "SearchCustomLocation"
        static let chat = "Chat"
        static let avalableCategories = "AvalableCategories"
        static let details = "Details"
        static let more = "More"
        static let accessories = "Accessories"
        static let myDrivers = "MyDrivers"
        static let reserve = "Reserve"
        static let carousel = "Carousel"
        static let signIn = "SignIn"
        static let registration = "Registration"
        static let registrationBot = "RegistrationBot"
        static let searchPhoneCode = "SearchPhoneCode"
        static let verificationCode = "VerificationCode"
        static let changePhoneNumber = "ChangePhoneNumber"
        static let phoneVerification = "PhoneVerification"
        static let reservationCompleted = "ReservationCompleted"
        static let payment = "Payment"
        static let officeTerminal = "OfficeTerminal"
        static let cash = "Cash"
        static let kaartlazer = "Kaartlazer"
        static let payLater = "PayLater"
        static let myReservetionAdvanced = "MyReservetionAdvanced"
        static let vehicleCheck = "VehicleCheck"
        static let newDamage = "NewDamage"
        static let odometerCheck = "OdometerCheck"
        static let addDamage = "AddDamage"
        static let editReservation = "EditReservation"
        static let editReservetionAdvanced = "EditReservetionAdvanced"
        static let addAccidentDetails = "AddAccidentDetails"
        static let compare = "Compare"
        static let odometerCheckStopRide = "OdometerCheckStopRide"
        static let stopRide = "StopRide"
        static let myPersonalInfo = "MyPersonalInformation"

    }
    struct NibNames {
        
        static let SearchCustomLocation = "SearchCustomLocation"
        static let AddressName = "AddressName"
        static let SearchResult = "SearchResult"
        static let SearchHeaderView = "SearchHeaderView"
        static let Carousel = "Carousel"
        static let tariffCarousel = "TariffCarouselCell"
    }
    
    struct Identifiers {
        static let main = "MainViewController"
        static let aboutUs = "AboutUsViewController"
        static let seeMap = "SeeMapViewController"
        static let customLocation = "CustomLocationViewController"
        static let onlineChat = "OnlineChatViewController"
        static let offlineChat = "OfflineViewController"
        static let AvalableCategories = "AvalableCategoriesViewController"
        static let details = "DetailsViewController"
        static let tariffSlide = "TariffSlideViewController"
        static let more = "MoreViewController"
        static let accessories = "AccessoriesUIViewController"
        static let myDrivers = "MyDriversViewController"
        static let reserve = "ReserveViewController"
        static let carousel = "CarouselViewController"
        static let signIn = "SignInViewController"
        static let newPassword = "NewPasswordViewController"
        static let emailAddress = "EmailAddressViewController"
        static let checkEmail = "CheckEmailViewController"
        static let registartion = "RegistrationViewController"
        static let termsConditions = "TermsConditionsViewController"
        static let faceAndTouchId = "FaceAndTouchIdViewController"
        static let SearchPhoneCode = "SearchPhoneCodeViewController"
        static let bkdAgreement = "BkdAgreementViewController"
        static let verificationCode = "VerificationCodeViewController"
        static let changePhoneNumber = "ChangePhoneNumberViewController"
        static let phoneVerification = "PhoneVerificationViewController"
        static let reservationCompleted = "ReservationCompletedViewController"
        static let selectPayment = "SelectPaymentViewController"
        static let paymentWeb = "PaymentWebViewController"
        static let cash = "CashViewController"
        static let officeTerminal = "OfficeTerminalViewController"
        static let kaartlazer = "KaartlazerViewController"
        static let payLater = "PayLaterViewController"
        static let myReservetionAdvanced = "MyReservetionAdvancedViewController"
        static let myReservetion = "MyReservetionViewController"
        static let vehicleCheck = "VehicleCheckViewController"
        static let newDamage = "NewDamageViewController"
        static let odometerCheck = "OdometerCheckViewController"
        static let odometerCheckStopRide = "OdometerCheckStopRideUIViewController"
        static let stopRide = "StopRideViewController"
        static let myPersonalInfo = "MyPersonalInformationViewController"
    }
    
    struct DeepLinks {
        static let messageApp = "message://app"
        static let googleMailApp = "googlegmail://app"
        static let yahooMailApp = "yahooMail://app"
    }
    
    struct FontNames {
        static let sfproDodplay_regular = "SFProDisplay-Regular"
        static let sfproDodplay_light = "SFProDisplay-Light"
        static let songMyung_regular = "SongMyung-Regular"
    }
    
    struct Texts {
        //Main
        static let euro = "€"
        static let inclVat = "(incl, VAT)"
        static let continueTxt = "Continue"
        static let pickUpDate = "Pick up date"
        static let returnDate = "Return date"
        static let pickUpTime = "Pick up time"
        static let returnTime = "Return time"
        static let pickUpLocation = "Pick up Location"
        static let returnLocation = "Return Location"
        static let searchResult = "Search Results"
        static let notCategory = "There are no available  %@ for the selected criteria. You can have a look at the models below."
        static let messageMoreThanMonth = "All the BKD vehicles are taken to technical check up once a month. You should return the vehicle to the BKD office after a month, and have it checked or be offered a new vehicle of the same type."
        static let messageChangeTariff = "Are you sure you want to Reserve for "
        static let messageChangeTariffSeconst = "Since your selection was for"
        static let titleChangeTariff = "Pick up date/time  Return date/time"
        
        static let messageWorkingTime = "Time is selected outside of BKD working hours to make a reservation "
        static let titleWorkingTime = "Additional service fee is     € %.2f"
        static let lessThan30Minutes = "You cannot rent a car for less than 30 minutes"
        static let messageCustomLocation  = "You choose a location, BKD vehicle is there. Depending on the location, service fee may vary."
        static let messageCustomLocation2  = "Please, select a location by clicking on the Maps and we will check the availability."
        static let titleCustomLocation = "Starting from € %.2f (incl. VAT)"
        static let cancel = "Cancel"
        static let agree = "Agree"
        static let change = "Yes, Change"
        static let startWorkingHour = "07:30"
        static let endWorkingHour = "18:30"
        static let errorEmail = "Write your email address, so that we answer the message once it's reviewed"
        static let errorIncorrectEmail = "Incorrect E-mail address"
        static let errorIncorrectPassword = "Incorrect password"
        static let messagePlaceholder = "Type your message"
        static let rentalConditions = "Rental conditions"
        static let bkdAdvantages = "BKD Advantages"
        static let select = "Select"
        static let max90Days = "Sorry, you can´t reserve a car for more than 90 days!"
      
        
        
        //Detail
        static let h = "h"
        static let d = "d"
        static let w = "w"
        static let m = "m"
        static let conditioning = "Conditioning"
        static let gps = "GPS"
        static let towBar = "Tow Bar"
        static let slideDoor = "Slide door"
        static let hourly = "Hourly"
        static let daily = "Daily"
        static let weekly = "Weekly"
        static let monthly = "Monthly"
        static let flexible = "Flexible"
        static let hours = "hours"
        static let days = "days"
        static let weeks = "weeks"
        static let month = "month"
        static let additionalDriver = "Additional driver"
        static let accessories = "Accessories"
        static let diesel = "Diesel"
        static let petrol = "Petrol"
        static let keyPetrol = "PETROL"
        static let keyDiesel = "DIESEL"
        static let transmissionManual = "Manual"
        static let transmissionAutomatic = "Automatic"
        static let errorRequest = "Failed request"
        static let kwVat = "KW€/%.2f inch VAT"
        static let fuelConsumption = "Fuel consumption"
        static let fuelNotUncluded = "Fuel consumption not included"
        static let depositApplies = "Deposit applies"
        static let freeKm = "km free for each day"
//        static let editReserveAlert = "Are you sure you want to change your reservation?"

        //Accessories
       static let loginAccessories = "To add accessories, you need to sign in" //???
        static let signInToContinue = "To continue, you need to sign in"
        
        //Tail Lift
        static let kg = "kg"
        static let cm = "cm"
        static let tailLiftCapacity = "Tail lift lifting capacity"
        static let tailLiftLength = "Tail lift length"
        static let loadingFloorHeight = "Loading floor height"
        
        //Register
        static let accountExist = "Account already exists"
        static let failedRequest = "Request failed please try again"
        static let reciveEmail = "You will receive the email in"
        static let touchIdNotice = "Please autorize with touch id!"
        static let touchIdError = "You can´t use this feature"
        static let touchIdFailed = "Failed to  Authenticate. Please try again."

        static let emailAdd = "Email address"
        static let password = "Password"
        static let confirmPassword = "Confirm password"

        static let oprnEmail = "Open Email"
        static let signIn = "Sign in"
        static let checkEmail = "Did not receive the email? Check your spam filter, or try another email address"
        static let tryAnotherEmail = "try another email address"
        static let fillFields = "Fill in all the fields"
        static let agreeTerms = "I agree to BKD Terms & Conditions"
        static let termsConditions = "Terms & Conditions"
        static let passwordErr = "Password must be at least 8 characters"
        static let confirmPasswordErr = "Both passwords must match"
        static let selecteImg = "Selecte image from"
        static let camera = "Camera"
        static let photoLibrary = "Photo library"
        static let Day = "Day"
        static let day = "day"
        static let Month = "Month"
        static let year = "Year"
        static let open = "Open"
        static let takePhoto = "Take a photo"
        static let search = "Search"
        static let mCuadrad = "m²"
        static let ok = "ok"
        
        static let name = "First Name"
        static let surname = "Last Name"
        static let streetName = "Street Name"
        static let houseNumber = "House number"
        static let country = "Country"
        static let city = "City"
        static let mailboxNumber = "Mailbox number"
        static let zipNumber = "Zip number"
        static let dateOfBirth = "Date of birth"
        static let drivingLicenseNumber = "Driving license number"

        //Personal date types
        static let button = "button"
        static let txtFl = "txtFl"
        static let phone = "phone"
        static let mailbox = "mailbox"
        static let nationalRegister = "national register" 
        static let calendar = "calendar"
        static let expiryDate = "calendar_expire"
        static let expiryDateDrivingLicense = "calendar_expire_driving_license"
        static let issueDateDrivingLicense = "calendar_issue_driving_license"
        
        //Phone verification
        static let phoneVerificationInfo = "First step to make the reservation is to verify your phone number. We will send a verification code to %@%@ number, indicated during the Reservation."
    
        
        //Payment
        static let invalidCode = "Verification code is invalid"
        static let payAlert = "You should pay 24 hours before the reservation. If not, the Pre-Reservation will be automatically cancelled. There %@ only %f free %@ of the Pre-Reservation in a month."
        static let cancellations = "cancellations"
        static let cancellation = "cancellation"

        static let  reciveSms = "You will receive the SMS in"
        static let gotIt = "Got it"
        static let payNow = "Pay now"
        static let mobileBancking = "Mobile banking"
        static let bancontactCard = "Bancontact card"
        static let generatedCode = "Generated Code"
        static let makePayment = "Make %.2f  Payment via"
        
        //My Reservation
        static let price = "Price"
        static let specialOffer = "Special offer"
        static let customLocation = "Custom location"
        static let additionalService = "Additional service"
        static let totalPrice = "Total price"
        
        static let oldTotalPrice = "Old total price"
        static let newTotalPrice = "New total price"
        static let cancelWithFreeReservations = "Are you sure you want to cancel your reservation? You have only 3 free reservations in a month. You will be fully refunded, as it’s your %st/%nd time in the current month."
        static let cancelLastFreeReservation = "Are you sure you want to cancel your reservation? You will be fully refunded, however this is your last free cancellation in the current month, so for the next reservation you will have to pay either Deposit or Rental price without a refund."
        static let cancelWithoutRefaund = "Are you sure you want to cancel your reservation? You will not be refunded, as your free cancellations have expired in the current month."
        static let back = "Back"
        static let confirm = "Confirm"
        static let payLater = "Pay later"
        
        
        
        //Start Ride
       static let confirmStartNow =  "By clicking “Start now” button you confirm that you got your keys and are to start the ride."
        static let startNow = "Start Now"
        static let vehicleOdometerPlaceholder = "Vehicle Odometer numbers"
        static let damageName = "Damage name"
        static let cancelDamage = "Are you sure you want to cancel the new damage adding process."
        static let yesCancel = "Yes, Cancel"
        static let odometerNumber = "Vehicle Odometer numbers"
        static let startRideAlert = "By clicking “Start now” button you confirm that you got your keys and are to start the ride."
        static let activeStartRide = "You will get vehicle Registration numbers 15 minutes before the Reservation Pick up time, and will be able to start the ride."
        
        //Stop ride
        static let stopRide = "Stop Ride"
        static let confirmSwitchDriver = "Please, confirm that you want to switch to ´%@´ driver."
        static let stopRideInfo = "If you want to stop your ride, you need to have the vehicle parked in the Return location and have the Odometer checked."
        static let stopRideInfoBold = "parked in the Return location and have the Odometer checked."
        static let finishRide_alert = "By clicking ´Finish Ride´ button, you confirm that you have parked the vehicle in the Return location and returned the keys to a BKD officer. Within 24 hours we will check the vehicle and Odometer details, and notify you on the amount of the Pending payment."
        static let finishRide = "Finish ride"
        
        //Additional driver
        static let addDriverAlert = "Additional driver servide is %.2f euro per driver. You need to wait for Admin approval to have an additional drier for your account. No payment will be needed unless the Admin approves the driver addition."
        static let addDriverService = "Additional driver service is %.2f euro per driver. Please, confirm that you want to turn on the service."
        static let licenseNumber =  "Driving license number"

        
        //Add accident details
        static let selectSide = "Select vehicle side"
        static let selectDate = "Select date"
        static let selectTime = "Select time"
        static let accidentAddress = "Input accident address"
        static let frontSide = "Front side"
        static let backSide = "Back side"
        static let rightSide = "Right side"
        static let leftSide = "Left side"
        static let confirmAccidentDetails = "Do you confirm the accident details and all the provided information assurance?"
        static let yes = "Yes"
        
        //Compare
        static let vehicle2 = "Vehicle 2"

        
        //Verify
        static let selectMailApp = "Select Mail App"
        static let  googleMail = "Googleg Mail"
        static let  yahooMail = "Yahoo Mail"
    
        //Registration Bot
        static let start = "Start"
        static let IF_text = "front side photo of your Identity card"
        static let IB_text = "back side photo of your Identity card"
        static let DLF_text = "front side photo of your valid Driving license"
        static let DLB_text = "back side photo of your valid Driving license"
        static let license_issue_text = "Issue date of the Driving license"
        
        //Error Messages
        static let errChangePassword = "Failed to change password, please try again"
        static let errAccountVerify = "Failed to verify account"
        static let errEmailVerifyNoUser = "Failed to send verification email, there is no such user"
        static let errEmailVerify = "Failed to send verification email"
        static let errUserOrPass = "Incorrect username or password!"
        static let errToken = "Failed to get token"
        static let errLocation = "Can't detect location"
        static let errAddress = "Can't detect address"
        static let errPersonalData = "Failed to add personal data!"
        static let errImageUpload = "Failed to load image!"
        static let errIDExpirationDate = "Failed to add ID expiration date!"
        static let errDrivLicenseDate = "Failed to add issue and expired driver license dates."
        static let errAcceptAgreement = "Failed to accept agreement."
        static let errReservation = "Failed to reservation."
        static let errRegistrationBot = "Please, complete user registration"

        
        //Request texts
        static let type = "type"
        static let exterior = "exterior"
        static let transmission = "transmission"
        static let automatic = "AUTOMATIC"
        static let manual = "MANUAL"
        static let resetPassword = "PASSWORD_RESET"
        static let verification = "VERIFICATION"
        static let creat_main_driver = "MAIN"
        static let creat_additional_driver = "ADDITIONAl"
        static let state_created = "CREATED"
        static let state_pers_data = "PERSONAL_DATA"
        static let state_IF = "IDENTITY_FRONT"
        static let state_IB = "IDENTITY_BACK"
        static let state_IEX = "IDENTITY_EXPIRATION"
        static let state_DLF = "DRIVING_LICENSE_FRONT"
        static let state_DLB = "DRIVING_LICENSE_BACK"
        static let state_DL_date = "DRIVING_LICENSE_DATES"
        static let state_DLS = "DRIVING_LICENSE_SELFIE"
        static let state_agree = "AGREEMENT_ACCEPTED"
        static let state_accepted = "ACCEPTED"

    }
    
    struct Keys {
        
        //Tariff
        static let hourly = "HOURLY"
        static let daily = "DAILY"
        static let weekly = "WEEKLY"
        static let monthly = "MONTHLY"
        static let flexible = "FLEXIBLE"
        static let start = "START"
        static let start_interval = "START_INTERVAL"
        static let end = "END"
        static let end_interval = "END_INTERVAL"
        static let take_photo = "takePhoto"
        static let open_doc = "openDoc"
        static let custom = "CUSTOM"

        
    }
    
    struct Notifications {
        static let LanguageUpdate = NSNotification.Name(rawValue: "BKD.Notification.Language")
        static let signUpEmailVerify =  NSNotification.Name(rawValue: "BKD.Notification.EmailVerify")
        static let resetPassEmailVerify =  NSNotification.Name(rawValue: "BKD.Notification.ResetPassEmailVerify")
    }
}



let countryList = ["Dutch", "French", "English"]
let sidesList = [Constant.Texts.frontSide,
                 Constant.Texts.backSide,
                 Constant.Texts.rightSide,
                 Constant.Texts.leftSide
                ]
let cityList = ["City1", "City2", "City3", "City4", "City5", "City6", "City7"]
let paymentSupportedCountriesCode: Set<String>? = ["AM", "FR", "NL", "GB"]
let emailAppNames = [ "Googleg Mail", "Yahoo Mail", "Message"]
let bancontactList = [UIImage(named: "ing"),
                      UIImage(named: "bnp"),
                      UIImage(named: "kbc")]
let equipmentForSearch = [ "0": "towbar",
                  "1": "Duble cabin" /*it needs to check*/,
                  "2": "tailgate",
                  "3": "GPSNavigator",
                  "4": "airConditioning" ]

let documentStateArr = ["IF",
                        "IB",
                        "DLF",
                        "DLB",
                        "DLS"]
let testParking = Parking(id: "73483478",
                          name: "Testing address",
                          longitude: 44.495332,
                          latitude: 40.194582)



let top_searchResult: CGFloat = 12.0
let top_avalableCategoryTbv: CGFloat = 30.0
let cornerRadius_equipment: CGFloat = 15.0
let zoom: Float = 18.0
let monthDays: Double = 30
let detail_cell_height: CGFloat = 28
let mydriver_cell_height: CGFloat = 66
let tailLift_cell_height: CGFloat = 40
let locationList_height: CGFloat = 172.0
let locationList_cell_height: CGFloat = 57.3
let height75 =  75
let height48 = 48

let main_subwidth = UIScreen.main.bounds.width * 0.158416
let reservation_no_carNumber_height = UIScreen.main.bounds.height * 0.306931
let reservation_with_carNumber_height = UIScreen.main.bounds.height * 0.391089
let height42 = UIScreen.main.bounds.height * 0.0519
let height50 = UIScreen.main.bounds.height * 0.061
let height307 = UIScreen.main.bounds.height * 0.379
let height200 = UIScreen.main.bounds.height * 0.247
let height245 = UIScreen.main.bounds.height * 0.303
let height240 = UIScreen.main.bounds.height * 0.297
let height285 = UIScreen.main.bounds.height * 0.352
let height345 = UIScreen.main.bounds.height * 0.426
let height405 = UIScreen.main.bounds.height * 0.501
let height550 = UIScreen.main.bounds.height * 0.680

let height115 = UIScreen.main.bounds.height * 0.142
let height274 = UIScreen.main.bounds.height * 0.339
let height130 = UIScreen.main.bounds.height * 0.160
let height273 = UIScreen.main.bounds.height * 0.337
let height68 = UIScreen.main.bounds.height * 0.084
let height170 = UIScreen.main.bounds.height * 0.21
let height1055 = UIScreen.main.bounds.height * 1.305


// 0.158416
//h* 16 /37

// 16/212 * height(curr height)
//UserDefaults Keys
let key_pickUpDate = "pickUpDate"
let key_returnDate = "returnDate"
let key_pickUpTime = "pickUpTime"
let key_returnTime = "returnTime"
let key_pickUpLocation = "pickUpLocation"
let key_returnLocation = "returnLocation"
let key_category = "category"
let key_email = "E-mail"
let key_isLogin = "isLogin"

//Request keis
let key_fieldName = "fieldName"
let key_fieldValue = "fieldValue"
let key_searchOperation = "searchOperation"
let key_length = "length"
let key_width = "width"
let key_height = "height"



//Colors
let color_main = UIColor(named: "main")
let color_background = UIColor(named: "background")
let color_subbackground = UIColor(named: "subview_background")
let color_search_placeholder = UIColor(named: "date_lb")
let color_entered_date = UIColor(named: "entered_date")
let color_choose_date = UIColor(named: "choose_date")
let color_navigationBar = UIColor(named: "navigationBar")
let color_error = UIColor(named: "offert_red")
let color_car_param = UIColor(named: "car_param")
let color_btn_pressed = UIColor(named: "see_map")
let color_btn_alert = UIColor(named: "alert_btn")
let color_btn_border = UIColor(named: "alert_btn_border")
let color_exterior_tint = UIColor(named: "exterior_img")
let color_menu = UIColor(named: "menu")
let color_carousel = UIColor(named: "carousel")
let color_carousel_img_tint = UIColor(named: "category_img_tint")

let color_filter_fields = UIColor(named: "filter_fields")
let color_selected_filter_fields = UIColor(named: "selected_filter_field")
let color_alert_bckg = UIColor(named: "alert_bckg")
let color_alert_txt = UIColor(named: "alert_txt")
let color_gradient_start = UIColor(named: "gradient_start")
let color_gradient_end = UIColor(named: "gradient_end")
let color_map_circle = UIColor(named: "map_circle")
let color_chat_placeholder = UIColor(named:"chat_placeholder")
let color_Offline_bckg = UIColor(named: "gradient_blur_end")
let color_email = UIColor(named: "email")
let color_shadow = UIColor(named: "shadow")
let color_weekly = UIColor(named: "weekly_title")
let color_more = UIColor(named: "more")
let color_segment_separator = UIColor(named: "segment_separator")
let color_hourly = UIColor(named: "tariff_hourly")
let color_days = UIColor(named: "tariff_days")
let color_weeks = UIColor(named: "tariff_weekly")
let color_monthly = UIColor(named: "tariff_montly")
let color_flexible = UIColor(named: "tariff_flexible")
let color_search_passive = UIColor(named: "search_passive")
let color_reserve_start = UIColor(named: "reserve_gradient_start")
let color_reserve_end = UIColor(named: "reserve_gradient_end")
let color_reserve_inactive_start = UIColor(named: "reserve_gradient_inactive_start")
let color_reserve_inactive_end = UIColor(named: "reserve_gradient_inactive_end")
let color_gradient_register_start = UIColor(named: "register_gradient_start")
let color_gradient_register_end = UIColor(named: "register_gradient_end")
let color_dark_register = UIColor(named:"navigation_bar")
let color_selected_start = UIColor (named: "selected_start")

//Fonts
let font_selected_filter = UIFont(name: "SFProDisplay-Regular", size: 18)
let font_unselected_filter = UIFont(name: "SFProDisplay-Regular", size: 16)
let font_alert_cancel = UIFont(name: "SFProDisplay-Regular", size: 17)
let font_category_name = UIFont(name: "SFProDisplay-Regular", size: 12)
let font_alert_agree = UIFont(name: "SFProDisplay-Semibold", size: 17)
let font_search_cell = UIFont(name: "SFProDisplay-Light", size: 16)
let font_chat_placeholder = UIFont(name: "SFProDisplay-Light", size: 12)
let font_alert_title = UIFont(name: "SFProDisplay-Semibold", size: 13)
let font_details_title = UIFont(name: "SFProDisplay-Regular", size: 13)
let font_more_header = UIFont(name: "SFProDisplay-Semibold", size: 14)
let font_search_title = UIFont(name: "SFProDisplay-Light", size: 18)
let font_placeholder = UIFont(name: "SFProDisplay-Light", size: 10)
let font_bot_placeholder = UIFont(name: "SFProDisplay-Light", size: 13)

let font_register_placeholder = UIFont(name: "SFProDisplay-Light", size: 15)

// Images
let img_bkd = UIImage(named:"bkd")?.withRenderingMode(.alwaysOriginal)
let img_back = UIImage(named: "back")
let img_menu = UIImage(named: "menu")
let img_chat = UIImage(named: "chat")
let img_unselected_filter = UIImage(named: "show_car_param")
let img_map_marker = UIImage(named: "marker")
let img_check_box = UIImage(named: "check")
let img_uncheck_box = UIImage(named: "uncheck_box")
let img_err_uncheck_box = UIImage(named: "err_uncheck_box")
let img_add_unselece = UIImage(named: "add")
let img_add_selecte = UIImage(named: "added")
let img_invisible = UIImage(named: "invisible")
let img_visible = UIImage(named: "visible")
let img_dropDown_light = UIImage(named: "dropDown_blue")
let img_card = UIImage(named: "14")
let img_cube = UIImage(named: "15")
let img_kg = UIImage(named: "16")
let img_carM = UIImage(named: "17")


 //Payment
let img_bancontact = UIImage(named: "bancontact")
let img_applePay = UIImage(named: "apple_pay")
let img_gPay = UIImage(named: "g_pay")
let img_payPal = UIImage(named: "paypal")

//Start Ride
let img_camera = UIImage(named: "camera")
let img_select_RadioBtn = UIImage(named: "select_radiobutton")
let img_unselect_RadioBtn = UIImage(named: "unselect_radiobutton")


