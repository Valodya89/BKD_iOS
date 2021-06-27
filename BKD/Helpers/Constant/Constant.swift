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
        
        static let messageWorkingTime = "Time is selected outside of BKD working hours to make a reservation (07:30 - 18:30)."
        static let titleWorkingTime = "Additional service fee is     € 59,99"
        static let messageCustomLocation  = "You choose a location, BKD vehicle is there. Depending on the location, service fee may vary."
        static let messageCustomLocation2  = "Please, select a location by clicking on the Maps and we will check the availability."
        static let titleCustomLocation = "Starting from € XX.00 (incl. VAT)"
        static let cancel = "Cancel"
        static let agree = "Agree"
        static let change = "Yes, Change"
        static let startWorkingHour = "07:30"
        static let endWorkingHour = "18:30"
        static let errorEmail = "Write your email address, so that we answer the message once it's reviewed"
        static let errorIncorrectEmail = "Incorrect E-mail address"
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



    }
}

let tariffOptionsArr =  [["2h", "3h", "4h", "5h", "6h", "10h"],
                         ["1d", "2d", "3d", "4d", "5d", "6d"],
                         ["1w", "2w", "3w"],
                         ["1m"], []]
let top_searchResult: CGFloat = 12.0
let top_avalableCategoryTbv: CGFloat = 30.0
let cornerRadius_equipment: CGFloat = 15.0
let zoom: Float = 12.0
let detail_cell_height: CGFloat = 28
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



//Colors
let color_main = UIColor(named: "main")
let color_background = UIColor(named: "background")
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

// Images
let img_bkd = UIImage(named:"bkd")?.withRenderingMode(.alwaysOriginal)
let img_back = UIImage(named: "back")
let img_menu = UIImage(named: "menu")
let img_chat = UIImage(named: "chat")
let img_unselected_filter = UIImage(named: "show_car_param")
let img_map_marker = UIImage(named: "marker")
let img_check_box = UIImage(named: "check")
let img_uncheck_box = UIImage(named: "uncheck_box")
let img_add = #imageLiteral(resourceName: "add")

