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
        static let myAccountsDrivers = "MyAccountsDrivers"
        static let myAccount = "MyAccount"
        static let aboutUs = "AboutUs"
        static let faq = "FAQ"
        static let editMyDrivers = "EditMyDrivers"


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
        static let faq = "FAQViewController"
        static let editMyDrivers = "EditMyDriversViewController"
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
        
        //MARK: -- Menu
        static let privacyPolic = "Privacy Policy" //MOBILE_dashboard_policy
        static let termsOfUse = "Terms of Use" //MOBILE_dashboard_terms_use
        
        //MARK: -- Global
        static let max90Days = "Sorry, you can´t reserve a car for more than 90 days!"//MOBILE_global_cant_reserv_90days_alert
        static let selecteImg = "Selecte image from"//MOBILE_bot_select_image
        
        //MARK: -- Main
        static let euro = "€"
        static let inclVat = "(incl, VAT)" // MOBILE_searched_incl_vat
        static let continueTxt = "Continue"// MOBILE_global_continue
        static let pickUpDate = "Pick up date"//MOBILE_global_pick_up_date
        static let returnDate = "Return date"//MOBILE_global_return_date
        static let pickUpTime = "Pick up time"//MOBILE_global_pick_up_time
        static let returnTime = "Return time"//MOBILE_global_return_time
        static let pickUpLocation = "Pick up Location"//MOBILE_global_pick_up_location
        static let returnLocation = "Return Location"//MOBILE_global_return_location
        static let searchResult = "Search Results"//MOBILE_searched_results
        static let notCategory = "There are no available  %@ for the selected criteria. You can have a look at the models below."//MOBILE_searched_message_no_available
        static let messageMoreThanMonth = "All the BKD vehicles are taken to technical check up once a month. You should return the vehicle to the BKD office after a month, and have it checked or be offered a new vehicle of the same type."//MOBILE_home_tech_check_up_alert
        static let messageChangeTariff = "Are you sure you want to Reserve for %@ hour(s)? Since your selection was for Pick up %@ Return %@"//MOBILE_tarrifs_reserve_alert
        static let messageWorkingTime = "Time is selected outside of BKD working hours to make a reservation "//MOBILE_home_not_working_hour
        
        static let titleWorkingTime = "Additional service fee is     € %.2f"//MOBILE_home_fee_additional_service_alert
        static let lessThan30Minutes = "You cannot rent a car for less than 30 minutes"//MOBILE_global_less_30minute_alert
        static let messageCustomLocation  = "You choose a location, BKD vehicle is there. Depending on the location, service fee may vary."//MOBILE_home_custom_location_alert
        static let messageCustomLocation2  = "Please, select a location by clicking on the Maps and we will check the availability."//MOBILE_home_custom_location_alert_2
        static let titleCustomLocation = "Starting from € %.2f (incl. VAT)"//MOBILE_home_custom_location_starting_price_alert
        static let cancel = "Cancel"//MOBILE_global_cancel
        static let agree = "Agree"//MOBILE_global_agree
        static let change = "Yes, Change"//MOBILE_home_yes_change
        static let errorEmail = "Write your email address, so that we answer the message once it's reviewed"//MOBILE_offChat_required_email_message
        static let errorIncorrectEmail = "Incorrect E-mail address"//MOBILE_global_incorrect_email
        
        //MARK: -- Chat
        static let messagePlaceholder = "Type your message"//MOBILE_global_placeholder
        
        //MARK: -- More
        static let rentalConditions = "Rental conditions"//MOBILE_more_rental_conditions
        static let bkdAdvantages = "BKD Advantages"//MOBILE_more_cons
        static let select = "Select"//MOBILE_global_select
        
      
        
        
        //MARK: -- Detail
        static let h = "h"//MOBILE_details_hour
        static let d = "d"//MOBILE_global_day
        static let w = "w"//MOBILE_details_week
        static let m = "m"//MOBILE_details_month
        static let conditioning = "Conditioning"//MOBILE_details_conditioning
        static let gps = "GPS"//MOBILE_details_gps
        static let towBar = "Tow Bar"//MOBILE_global_tow_bar
        static let slideDoor = "Slide door"//MOBILE_details_slide_door
        static let hourly = "Hourly"//MOBILE_details_hourly
        static let daily = "Daily"//MOBILE_details_daily
        static let weekly = "Weekly"//MOBILE_details_weekly
        static let monthly = "Monthly"//MOBILE_details_monthly
        static let flexible = "Flexible"//MOBILE_details_flexible
        static let hours = "hours"//MOBILE_details_hours
        static let days = "days"//MOBILE_details_days
        static let weeks = "weeks"//MOBILE_details_weeks
        static let month = "month"//MOBILE_details_month
        static let additionalDriver = "Additional driver"//MOBILE_global_additional_driver
        static let accessories = "Accessories"//MOBILE_accessories_accessories
        
        static let diesel = "Diesel"//MOBILE_details_diesel
        static let petrol = "Petrol"//MOBILE_details_petrol
        static let keyPetrol = "PETROL"
        static let keyDiesel = "DIESEL"
        static let transmissionManual = "Manual"//MOBILE_global_manual
        static let transmissionAutomatic = "Automatic"//MOBILE_global_automatic
        static let errorRequest = "Failed request"//MOBILE_global_failed_request_err
        static let kwVat = "KW€/%.2f inch VAT"//MOBILE_details_kw_incl_vat
        static let fuelConsumption = "Fuel consumption"//MOBILE_details_fuel_consumption
        static let fuelNotUncluded = "Fuel consumption not included"//MOBILE_details_fuel_not_includ
        static let depositApplies = "Deposit applies"//MOBILE_details_deposit_applies
        static let deposit = "Deposit" // MOBILE_payment_deposit
        static let freeKm = "km free for each day"//MOBILE_details_km_free
//        static let editReserveAlert = "Are you sure you want to change your reservation?"

        //MARK: -- Accessories
       static let loginAccessories = "To add accessories, you need to sign in" //MOBILE_accessories_signin_alert
        static let signInToContinue = "To continue, you need to sign in"//MOBILE_accessories_continue_alert
        
        //MARK: -- Tail Lift
        static let kg = "kg"//MOBILE_global_kg
        static let cm = "cm"//MOBILE_global_cm
        static let tailLiftCapacity = "Tail lift lifting capacity"//MOBILE_details_capacity
        static let tailLiftLength = "Tail lift length"//MOBILE_details_length
        static let loadingFloorHeight = "Loading floor height"//MOBILE_details_floor_height
        
        //MARK: -- Register
        static let accountExist = "Account already exists"//MOBILE_account_exist_err
        static let failedRequest = "Request failed please try again"//MOBILE_bot_failed_request_err
        static let touchIdNotice = "Please autorize with touch id!"//MOBILE_bot_touch_id_alert
        static let touchIdError = "You can´t use this feature"//MOBILE_bot_touch_id_err
        static let touchIdFailed = "Failed to  Authenticate. Please try again."//MOBILE_bot_atentication_err

        static let emailAdd = "Email address"//MOBILE_global_password
        static let password = "Password"//MOBILE_global_password
        static let confirmPassword = "Confirm password"//MOBILE_register_registration

        static let oprnEmail = "Open Email"//MOBILE_mybkd_open_email
        static let signIn = "Sign in"//MOBILE_mybkd_sign_in
        static let checkEmail = "Did not receive the email? Check your spam filter, or try another email address"//MOBILE_mybkd_did_not_receive_email

        static let tryAnotherEmail = "try another email address"//MOBILE_mybkd_try_another_email
        static let fillFields = "Fill in all the fields"//MOBILE_mybkd_fill_fields
        static let agreeTerms = "I agree to BKD Terms & Conditions"//MOBILE_register_agreement
        static let termsConditions = "Terms & Conditions"//MOBILE_register_terms_conditions
        static let passwordErr = "Password must be at least 8 characters"//MOBILE_bot_password_err
        static let confirmPasswordErr = "Both passwords must match"//MOBILE_mybkd_both_must_match

       
        static let camera = "Camera"//MOBILE_bot_camera
        static let photoLibrary = "Photo library"//MOBILE_bot_photo_library
        static let Day = "Day"//MOBILE_global_Day
        static let day = "day"//MOBILE_home_day
        static let Month = "Month"//MOBILE_global_month
        static let year = "Year"//MOBILE_global_year
        static let open = "Open"//
        static let takePhoto = "Take a photo"//MOBILE_global_take_photo
        static let search = "Search"//MOBILE_global_search
        static let mCuadrad = "m²"//MOBILE_global_m²
        static let ok = "ok"//MOBILE_global_ok
        
        static let name = "First Name"//MOBILE_global_first_name
        static let surname = "Last Name"//MOBILE_global_last_name
        static let phoneNumber = "Phone number"//MOBILE_global_phone_number
        static let streetName = "Street name"//MOBILE_global_street_name
        static let houseNumber = "House number"//MOBILE_global_hous_number
        static let country = "Country"//MOBILE_global_country
        static let city = "City"//MOBILE_global_city
        static let mailboxNumber = "Mailbox number"//MOBILE_global_mail_box
        static let zipNumber = "Zip number"//MOBILE_global_zip_number
        static let dateOfBirth = "Date of birth"//MOBILE_global_date_birth
        static let drivingLicenseNumber = "Driving license number"//MOBILE_global_driv_license_num
        static let nationalRegisterNum = "National register number"//MOBILE_global_national_register_number
        static let otherCountryRegisterNum = "Other Country National Register Number"//MOBILE_bot_other_country
       static let expiryDate = "Expiry date"//MOBILE_global_expiry_date
       

        //MARK: -- Personal date types
        static let button = "button"
        static let txtFl = "txtFl"
        static let phone = "phone"
        static let mailbox = "mailbox"
        static let nationalRegister = "national register" 
        static let calendar = "calendar"
        static let expiry_date = "calendar_expire"
        static let expiryDateDrivingLicense = "calendar_expire_driving_license"
        static let issueDateDrivingLicense = "calendar_issue_driving_license"
        
        //MARK: -- Phone verification
        static let phoneVerificationInfo = "First step to make the reservation is to verify your phone number. We will send a verification code to %@%@ number, indicated during the Reservation."//MOBILE_verifysignIn_ instructions

    
        
        //MARK: -- Payment
        static let invalidCode = "Verification code is invalid"//MOBILE_verifysignIn_code_invalid
        static let payAlert = "You should pay 24 hours before the reservation. If not, the Pre-Reservation will be automatically cancelled. There %@ only %f free %@ of the Pre-Reservation in a month."//MOBILE_payment_24_hour_message
//        static let cancellations = "cancellations"
//        static let cancellation = "cancellation"

        static let  reciveSms = "You will receive the SMS in"//MOBILE_verifysignIn_sms
        static let gotIt = "Got it"//MOBILE_payment_got_it
        static let payNow = "Pay now"//MOBILE_payment_pay_now
        static let mobileBancking = "Mobile banking"//MOBILE_payment_mobile_banking
        static let bancontactCard = "Bancontact card"//MOBILE_payment_bancontact
        static let generatedCode = "Generated Code"//MOBILE_payment_generated_code
        static let payPrice = "Make %.2f  Payment via"//MOBILE_payment_means
        static let paidDepositInfo = "You have paid the Deposit in the amount of € %.2f  upon Pre-reservation. Rental price in the amount"//MOBILE_payment_amount_deposit
        static let payRentalInfo = "€ %.2f is still to be paid in order to fully complete the reservation."// MOBILE_payment_pay_rental_to_complete
        static let paymentPending = "Payment Pending"//MOBILE_global_payment_pending
        
        //MARK: -- My Reservation
        static let price = "Price"//MOBILE_reserve_price
        static let specialOffer = "Special offer"//MOBILE_searched_special_offer
        static let customLocation = "Custom location"//MOBILE_home_custom_location
        static let additionalService = "Additional service"//MOBILE_myReservation_additional_service
        static let totalPrice = "Total price"//MOBILE_global_total_price
        
        static let oldTotalPrice = "Old total price"//MOBILE_reservAdvanced_old_total_price
        static let newTotalPrice = "New total price"//MOBILE_reservAdvanced_new_total_price
//        static let cancelWithFreeReservations = "Are you sure you want to cancel your reservation? You have only 3 free reservations in a month. You will be fully refunded, as it’s your %st/%nd time in the current month."
        static let cancelLastFreeReservation = "Are you sure you want to cancel your reservation? You will be fully refunded, however this is your last free cancellation in the current month, so for the next reservation you will have to pay either Deposit or Rental price without a refund."//MOBILE_myReservation_last_free_reserv_alert
        static let cancelWithoutRefaund = "Are you sure you want to cancel your reservation? You will not be refunded, as your free cancellations have expired in the current month."//MOBILE_myReservation_cancel_reserv_alert
        static let back = "Back"//MOBILE_myReservation_back
        static let confirm = "Confirm"//MOBILE_global_confirm
        static let payLater = "Pay later"//MOBILE_global_pay_later
        static let makePayment = "Make Payment"//MOBILE_global_make_payment
        static let payDistanceMessage = "For %.2f km ride you should make € %.2f payment (1km = € %@)."//MOBILE_myReservation_pay_distance_price_message
        static let watinfForDistance = "Admin approval - waiting for distance price"//MOBILE_myReservation_waiting_for_distance
        static let watinfForAdmin = "Admin approval - waiting"//MOBILE_global_admin_approval

        
        
        //MARK: -- Start Ride
       static let confirmStartNow =  "By clicking “Start now” button you confirm that you got your keys and are to start the ride."//MOBILE_startRide_click_start_now_alert
        static let startNow = "Start Now"//MOBILE_startRide_start_Now
        static let vehicleOdometerPlaceholder = "Vehicle Odometer numbers"//MOBILE_stopRide_odometer_number
        static let damageName = "Damage name"//MOBILE_startRide_damage_name
        static let cancelDamage = "Are you sure you want to cancel the new damage adding process."//MOBILE_startRide_cancel_new_damage_alert
        static let yesCancel = "Yes, Cancel"//MOBILE_startRide_yes_cancel
        static let odometerNumber = "Vehicle Odometer numbers"//MOBILE_stopRide_odometer_number
        static let startRideAlert = "By clicking “Start now” button you confirm that you got your keys and are to start the ride."//MOBILE_startRide_click_start_now_alert
        static let activeStartRide = "You will get vehicle Registration numbers 15 minutes before the Reservation Pick up time, and will be able to start the ride."//MOBILE_startRide_get_register_number_alert
        
        //MARK: -- Stop ride
        static let stopRide = "Stop Ride"//MOBILE_stopRide_stop_ride
        static let confirmSwitchDriver = "Please, confirm that you want to switch to ´%@´ driver."//MOBILE_stopRide_change_driver_alert
        static let stopRideInfo = "If you want to stop your ride, you need to have the vehicle parked in the Return location and have the Odometer checked."//MOBILE_stopRide_step1_message
        static let stopRideInfoBold = "parked in the Return location and have the Odometer checked."//MOBILE_stopRide_step1_bold_message
        static let finishRide_alert = "By clicking ´Finish Ride´ button, you confirm that you have parked the vehicle in the Return location and returned the keys to a BKD officer. Within 24 hours we will check the vehicle and Odometer details, and notify you on the amount of the Pending payment."//MOBILE_stopRide_click_finish_ride_alert
        static let finishRide = "Finish ride"//MOBILR_stopRide_finish_ride
        static let payRental = "Pay Rental Price" //MOBILE_global_pay_rental_price
        static let payDeposit = "Pay Deposit Price" //MOBILE_pay_deposit
        static let payDistance = "Pay Distance Price"//MOBILE_global_pay_distance_price
        static let depositPaid = "Deposit paid"//MOBILE_global_deposit_paid
        static let reservedPaid = "Reserved & Paid"//MOBILE_global_reserv_paid
        static let distancePrice = "Distance price:"//MOBILE_stopRide_distance_price
        static let priceCalculation = "Waiting for Price calculation by BKD"//MOBILE_stopRide_witing_price_calculation
        static let pending = "Pending"//MOBILE_stopRide_pending
        static let finished = "Finished"//MOBILE_stopRide_finished
        static let rentalPrice = "Rental price:"//MOBILE_stopRide_rental_price
        static let paidPrice = "Paid  € %.2f" //MOBILE_stopRide_paid_price
        
        
        
        
        
        //MARK: -- Additional driver
        
        static let addDriverAlert = "Additional driver service is %.2f euro per driver. You need to wait for Admin approval to have an additional driver for your account. No payment will be needed unless the Admin approves the driver addition"//MOBILE_mydrivers_service_approval_alert
        static let addDriverService = "Additional driver service is %.2f euro per driver. Please, confirm that you want to turn on the service."//MOBILE_mydrivers_service_alert
        static let licenseNumber =  "Driving license number"//MOBILE_global_driv_license_num

        
        //MARK: -- Add accident details
        static let selectSide = "Select vehicle side"//MOBILE_onRide_select_vehicle_side
        static let selectDate = "Select date"//MOBILE_onRide_select_date
        static let selectTime = "Select time"//MOBILE_onRide_select_time
        static let accidentAddress = "Input accident address"//MOBILE_onRide_input_accident_address
        static let frontSide = "Front side"//MOBILE_onRide_front_side
        static let backSide = "Back side"//MOBILE_onRide_back_side
        static let rightSide = "Right side"//MOBILE_onRide_right_side
        static let leftSide = "Left side"//MOBILE_onRide_left_side
        static let confirmAccidentDetails = "Do you confirm the accident details and all the provided information assurance?"//MOBILE_onRide_accident_confirm_alert
        static let cancelAccident = "Are you sure you want to back? The accident and all information provided will be deleted."//MOBILE_onRide_accident_cancel_alert
        static let yes = "Yes"//MOBILE_onRide_yes
        
        //MARK: -- Edit reservation
        static let extendDateAlert = "The reservation date can only be extended, not reduced"//MOBILE_reservAdvanced_reduce_reserv_alert
        static let needsAdminApproval = "You need to wait for Admin approval to have the reservation location edited."//MOBILE_reservAdvanced_location_edit_alert
        
        //MARK: -- Compare
        static let vehicle2 = "Vehicle 2"//MOBILE_compare_vehicle_2

        
        //MARK: -- Verify
        static let selectMailApp = "Select Mail App"//MOBILE_verifysignIn_select_mail
        static let  googleMail = "Googleg Mail"
        static let  yahooMail = "Yahoo Mail"
    
        //MARK: -- Registration Bot
        static let firstName = "First name"//MOBILE_global_first_name
        static let lastName = "Last name"//MOBILE_global_last_name
        static let start = "Start"//MOBILE_bot_start
        static let bkdAgree = "BKD Agreement"//MOBILE_global_agreement
        static let bkd_robot_hello = "Hello. I’m the BKD robot. I help new users register fast and fun."//MOBILE_bot_hello_message
        static let driving_lic_obligation = "Please, have with you your ID and Driving license. You must be at least 23 years old, have a valid Driving license for at least 2 years."//MOBILE_bot_pre_requisites
        static let first_name_message = "Let’s start with some personal details. Firstly, your First name."//MOBILE_bot_firstname
        static let name_instructions = "P.S. You should use your real names on BKD."//MOBILE_bot_name_instructions
        static let last_name_message = "Now, mention your Last name."//MOBILE_bot_lastname
        static let phone_num_message = "Insert your Phone number, please."//MOBILE_bot_phone_number
        static let date_birth_message = "Date of birth, maybe there are some promotions on your specific day."//MOBILE_bot_birth
        static let address_message = "Now let’s add your Residential address details by mentioning:"//MOBILE_bot_residence_address
        static let street_name = "Step 1 - Street name."//MOBILE_bot_street_name
        static let house_num = "Step 2 - House number."//MOBILE_bot_house
        static let mailbox_num = "Step 3 - Mailbox number, if you’re living in an apartment building."//MOBILE_bot_mailbox
        static let country_message = "Step 4 - Country."//MOBILE_bot_country
        static let zip_num = "Step 5 - Zip number."//MOBILE_bot_zip
        static let city_message = "Step 6 - City."//MOBILE_bot_city
        static let add_register_success = "Your Address is registered successfully."//MOBILE_bot_email_success
        static let national_register_message = "Please, insert your National register number."//MOBILE_bot_national_id
        static let attach_doc_message = "Last Registration Step is to attach Documents."//MOBILE_bot_last_step
        static let attach_doc_obligation = "Documents should be captured fully, as well as the information on them must be easily readable."//MOBILE_bot_documents_instructions
        static let id_front_message = "First, take the front side photo of your Identity card (Photo holder side)."//MOBILE_bot_photo_of_id_front
        static let id_back_message = "Now, take the back side photo of your Identity card."//MOBILE_bot_photo_of_id_back
        static let exp_date_message = "Now, let’s add the Expiry date."//MOBILE_bot_expiry_date
        static let driving_lic_num_message = "Now, let’s add the Driving license number."//MOBILE_bot_add_driving_lic
        static let lic_front_message = "Please, take the front side photo of your valid Driving license (Photo holder side)."//MOBILE_bot_photo_of_license_front
        static let lic_back_message = "Now, take the back side photo of your valid Driving license."//MOBILE_bot_photo_of_license_back
        static let lic_issue_date_message = "Now let’s add the Issue date of the Driving license."//MOBILE_bot_issue_date
        static let lic_exp_date_message = "Now let’s add the Expiry date of Driving license."//MOBILE_bot_expiry_date_of_license
        static let selfie_message = "Last one left. Please, take a selfie photo with your valid Driving license, like this one."//MOBILE_bot_selfie
        static let agree_message = "Please, examine carefully the online version of the licensed BKD Agreement. By clicking “Agree”, you agree to our Terms & Conditions."//MOBILE_bot_agreement
        static let confirm_message = "By clicking “Confirm”, you confirm that the information provided above is true and correct."//MOBILE_bot_confirm
        static let IF_text = "front side photo of your Identity card"//MOBILE_bot_photo_of_id_front_bold
        static let IB_text = "back side photo of your Identity card"//MOBILE_bot_photo_of_id_back_bold
        static let DLF_text = "front side photo of your valid Driving license"//MOBILE_bot_photo_of_license_front_bold
        static let DLB_text = "back side photo of your valid Driving license"//MOBILE_bot_photo_of_license_back_bold
        static let license_issue_text = "Issue date of the Driving license"//MOBILE_bot_issue_date_bold
        static let selfi_driving_lic = "selfie photo with your valid Driving license"//MOBILE_bot_selfie_bold
        static let fron_addDriving_id_bold = "front side photo of your additional driver’s Identity card"//MOBILE_bot_driver_id_front_side_photo_bold
        static let back_addDrivers_Id = "Now, take the back side photo of your additional driver’s Identity card."//MOBILE_bot_driver_id_back_side_photo
        static let back_addDriving_Id_bold = "back side photo of your additional driver’s Identity card"//MOBILE_bot_driver_id_back_side_photo_bold
        static let fron_addDrivers_lic = "Please, take the front side photo of your additional driver’s valid Driving license (Photo holder side)."//MOBILE_bot_driver_lic_front_side_photo
        static let fron_addDriving_lic_bold = "front side photo of your additional driver’s valid Driving license"//MOBILE_bot_driver_lic_front_side_photo_bold
        static let back_addDrivers_lic = "Now, take the back side photo of your additional driver’s valid Driving license."//MOBILE_bot_driver_lic_back_side_photo
        static let back_addDriving_lic_bold = "back side photo of your additional driver’s valid Driving license"//MOBILE_bot_driver_lic_back_side_photo_bold
        static let front_addDrivers_id  = "First, take the front side photo of your additional driver’s Identity card (Photo holder side)."//MOBILE_bot_driver_id_front_side_photo
        
        ///Driver registration bot
        static let register_driver_message = "To register new drivers for your account, please, have them with you, along with their ID and Driving license. Additional drivers must be at least 23 years old, have a valid Driving license for at least 2 years"//MOBILE_bot_driver_register_message
        static let driver_first_name = "Let’s start with some personal details. Firstly, your additional driver’s First name."//MOBILE_bot_driver_first_name
        static let driver_name_obligation = "P.S. You should use real names on BKD."//MOBILE_bot_driver_name_obligation
        static let driver_last_name = "Now, mention your additional driver’s Last name."//MOBILE_bot_driver_last_name
        static let driver_phone_number = "Insert your additional driver’s Phone number, please."//MOBILE_bot_driver_phone_number
        static let driver_birth = "Date of birth, maybe there are some promotions on your additional driver’s specific day."//MOBILE_bot_driver_birth
        static let driver_address = "Now let’s add your additional driver’s address details by mentioning:"//MOBILE_bot_driver_address
        static let driver_address_success = "Your additional driver’s Address is registered successfully."//MOBILE_bot_driver_address_success
        static let driver_national_register_num = "Please, insert your additional driver’s National register number."//MOBILE_bot_driver_national_register_num
        static let driver_selfie_message = "Last one left. Please, ask your additional driver take a selfie photo with your valid Driving license, like this one."//MOBILE_bot_driver_selfie_with_license
        
        ///registration successfully
        static let account_success_message = "Your BKD account is completed successfully. Within 24 hours You will receive an email confirming the Verification of the account, and will be able to make reservations."//MOBILE_bot_completed
        static let enjoy_message = "Enjoy the best rental experience with us"//MOBILE_bot_wish
        static let driver_success_message = "Your BKD account for Additional driver is completed successfully. Within 24 hours You will receive an email confirming the Verification of the account, and will be able to add the driver to your reservations."//MOBILE_bot_driver_completed
        
        
        //MARK: -- My Account
        static let newEmail = "New email address"//MOBILE_myaccount_new_email
        static let currPassword = "Current password"//MOBILE_myaccount_curr_password
        static let myDrivers = "My Drivers"//MOBILE_mydrivers_my_drivers
        static let myPersonalInfo = "My personal information"//MOBILE_myaccount_my_personal_info
        
        //MARK: -- My personal information
        static let confitmEdit = "You need to wait for Admin approval to have your Personal Information edited. Are you sure you want to continue?"//MOBILE_mybkd_wait_approval_to_edit

        static let identityCard = "Identity card"//MOBILE_mybkd_id_card
        static let frontSideIdCard = "Front side of Identity card"//MOBILE_mybkd_front_id_card
        static let backSideIdCard = "Back side of Identity card"//MOBILE_mybkd_back_id_card
        static let expiryDateIdCard = "Expiry date of Identity card"//MOBILE_mybkd_exp_date_id_card
        static let  drivingLicense = "Driving license"//MOBILE_mybkd_driving_lic
        static let frontDrivingLic = "Front side of Driving license"//MOBILE_mybkd_front_driving_lic
        static let backDrivingLic = "Back side of Driving license"//MOBILE_mybkd_back_driving_lic
        static let issueDrivingLic = "Issue date of Driving license"//MOBILE_mybkd_issue_date_driving_lic
        static let expiryDrivingLic = "Expiry date of Driving license"//MOBILE_mybkd_exp_date_driving_lic
        static let selfieDrivingLic = "Selfie with Driving license"//MOBILE_mybkd_selfie_driving_lic
        
        //MARK: -- Notification
        static let deleteNotif = "Are you sure You want to delete this notification?"//MOBILE_notifications_delete_alert
        static let delete = "Delete"//MOBILE_notifications_delete

        //MARK: -- Error Messages
        static let errChangePassword = "Failed to change password, please try again"//MOBILE_err_change_password
        static let errAccountVerify = "Failed to verify account"//MOBILE_err_account_verify
        static let errEmailVerifyNoUser = "Failed to send verification email, there is no such user" //MOBILE_err_send_email_no_user
        static let errEmailVerify = "Failed to send verification email"//MOBILE_err_send_email
        static let errUserOrPass = "Incorrect username or password!"//MOBILE_global_incorrect_password
        static let errToken = "Failed to get token"//MOBILE_err_get_token
        static let errLocation = "Can't detect location"//MOBILE_err_detect_location
        static let errAddress = "Can't detect address"//MOBILE_err_detect_address
        static let errPersonalData = "Failed to add personal data!"//MOBILE_err_add_personal_data
        static let errImageUpload = "Failed to load image!"//MOBILE_err_load_image
        static let errIDExpirationDate = "Failed to add ID expiration date!"//MOBILE_err_add_id_expiration_date
        static let errDrivLicenseDate = "Failed to add issue and expired driver license dates."//MOBILE_err_add_issue_expired_lic_dates
        static let errAcceptAgreement = "Failed to accept agreement."//MOBILE_err_accept_agreement
        static let errReservation = "Failed to reservation."//MOBILE_err_reservation
        static let errRegistrationBot = "Please, complete user registration"//MOBILE_err_complete_user_register_alert
        static let somethingWrong = "Something went wrong."//MOBILE_err_something_wrong
        
        
        

        //MARK: -- Request texts
        static let type = "type"//MOBILE_global_type
        static let exterior = "exterior"//MOBILE_global_exterior
        static let transmission = "transmission"//MOBILE_global_transmission
        static let automatic = "AUTOMATIC"
        static let manual = "MANUAL"
        static let resetPassword = "PASSWORD_RESET"
        static let verification = "VERIFICATION"
        static let changeEmail = "CHANGE_EMAIL"
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
        static let parking = "PARKING"
        static let draft = "DRAFT"
        static let closed = "CLOSED"


        
    }
    
    struct Notifications {
        static let LanguageUpdate = NSNotification.Name(rawValue: "BKD.Notification.Language")
        static let signUpEmailVerify =  NSNotification.Name(rawValue: "BKD.Notification.EmailVerify")
        static let resetPassEmailVerify =  NSNotification.Name(rawValue: "BKD.Notification.ResetPassEmailVerify")
        static let changeEmailVerify =  NSNotification.Name(rawValue: "BKD.Notification.ChangeEmailVerify")
        static let dismissMenu =  NSNotification.Name(rawValue: "BKD.Notification.DismissMenu")
    }
}



//let countryList = ["Dutch", "French", "English"] //MOBILE_dashboard_dutch,  MOBILE_dashboard_french, MOBILE_dashboard_english
let sidesList = [Constant.Texts.frontSide,
                 Constant.Texts.backSide,
                 Constant.Texts.rightSide,
                 Constant.Texts.leftSide
                ]

//let paymentSupportedCountriesCode: Set<String>? = ["AM", "FR", "NL", "GB"]
let emailAppNames = [ "Googleg Mail", "Yahoo Mail", "Message"]
let bancontactList = [UIImage(named: "ing"),
                      UIImage(named: "bnp"),
                      UIImage(named: "kbc")]
let equipmentForSearch = [ "0": "towbar",
                  "1": "Duble cabin" /*it needs to check*/,
                  "2": "tailgate",
                  "3": "GPSNavigator",
                  "4": "airConditioning" ]
let contactUsList = ["Call BKD", "Chat"]//MOBILE_dashboard_call_bkd, MOBILE_dashboard_chat

let documentStateArr = ["IF",
                        "IB",
                        "DLF",
                        "DLB",
                        "DLS"]
 



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
let height257 = UIScreen.main.bounds.height * 0.318
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
let color_submenu = UIColor(named: "submenu")
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
let color_driving_license = UIColor(named: "driving_license")
let color_select_notif = UIColor(named: "notification_select")

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
let img_disable_edit = UIImage(named: "disable_edit")
let img_edit = UIImage(named: "edit_transparent")
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


