//
//  Constant.swift
//  BKD
//
//  Created by Karine Karapetyan on 13-05-21.
//
 import UIKit

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
    }
    
    struct FontNames {
        static let sfproDodplay_regular = "SFProDisplay-Regular"
        static let sfproDodplay_light = "SFProDisplay-Light"
        static let songMyung_regular = "SongMyung-Regular"
    }
    
    struct Texts {
        static let pickUpDate = "Pick up date"
        static let returnDate = "Return date"
        static let pickUpTime = "Pick up time"
        static let returnTime = "Return time"
        static let pickUpLocation = "Pick up Location"
        static let returnLocation = "Return Location"
        static let searchResult = "Search Results"
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
        
        
        //Register
        static let accountExist = "Account already exists"
        static let failedRequest = "Request failed please try again"
        static let  reciveEmail = "You will receive the email in"
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
        static let m = "m"
        
        static let name = "First Name"
        static let surname = "Last Name"
        static let streetName = "Street Name"
        static let houseNumber = "House number"
        static let country = "Country"
        static let city = "City"
        static let mailboxNumber = "Mailbox number"
        static let zipNumber = "Zip number"
        
        
        //Payment
        static let invalidCode = "Verification code is invalid"
        static let payAlert = "You should pay 24 hours before the reservation. If not, the Pre-Reservation will be automatically cancelled. There are only 3 free cancellations of the Pre-Reservation in a month."
        static let  reciveSms = "You will receive the SMS in"
        static let gotIt = "Got it"
        static let payNow = "Pay now"
        static let mobileBancking = "Mobile banking"
        static let bancontactCard = "Bancontact card"
        

    }
}

let tariffOptionsArr =  [["2h", "3h", "4h", "5h", "6h", "10h"],
                         ["1d", "2d", "3d", "4d", "5d", "6d"],
                         ["1w", "2w", "3w"],
                         ["1m"], []]

let countryList = ["Dutch", "French", "English"]
let cityList = ["City1", "City2", "City3", "City4", "City5", "City6", "City7"]
let paymentSupportedCountriesCode: Set<String>? = ["AM", "FR", "NL", "GB"]
let bancontactList = [UIImage(named: "ing"),
                      UIImage(named: "bnp"),
                      UIImage(named: "kbc")]






let top_searchResult: CGFloat = 12.0
let top_avalableCategoryTbv: CGFloat = 30.0
let cornerRadius_equipment: CGFloat = 15.0
let zoom: Float = 12.0
let detail_cell_height: CGFloat = 28
let mydriver_cell_height: CGFloat = 66
let tailLift_cell_height: CGFloat = 40

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
let img_add_unselece = UIImage(named: "add")
let img_add_selecte = UIImage(named: "added")
let img_invisible = UIImage(named: "invisible")
let img_visible = UIImage(named: "visible")
let img_dropDown_light = UIImage(named: "dropDown_blue")

 //Payment
let img_bancontact = UIImage(named: "bancontact")
let img_applePay = UIImage(named: "apple_pay")
let img_gPay = UIImage(named: "g_pay")
let img_payPal = UIImage(named: "paypal")


