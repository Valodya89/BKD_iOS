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
         

    }
    struct NibNames {
        
        static let SearchCustomLocation = "SearchCustomLocation"
        static let AddressName = "AddressName"
        static let SearchResult = "SearchResult"
        static let SearchHeaderView = "SearchHeaderView"
        static let Carousel = "Carousel"
    }
    
    struct Identifiers {
        static let main = "MainViewController"
        static let aboutUs = "AboutUsViewController"
        static let seeMap = "SeeMapViewController"
        static let customLocation = "CustomLocationViewController"
        static let onlineChat = "OnlineChatViewController"
        static let offlineChat = "OfflineViewController"
        static let AvalableCategories = "AvalableCategoriesViewController"
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
        static let messageWorkingTime = "Time is selected outside of BKD working hours to make a reservation (07:30 - 18:30)."
        static let titleWorkingTime = "Additional service fee is     € 59,99"
        static let messageCustomLocation  = "You choose a location, BKD vehicle is there. Depending on the location, service fee may vary."
        static let messageCustomLocation2  = "Please, select a location by clicking on the Maps and we will check the availability."
        static let titleCustomLocation = "Starting from € XX.00 (incl. VAT)"
        static let cancel = "Cancel"
        static let agree = "Agree"
        static let startWorkingHour = "07:30"
        static let endWorkingHour = "18:30"
        static let errorEmail = "Write your email address, so that we answer the message once it's reviewed"
        static let errorIncorrectEmail = "Incorrect E-mail address"
        static let messagePlaceholder = "Type your message"

    }
}

let top_searchResult: CGFloat = 12.0
let top_avalableCategoryTbv: CGFloat = 30.0
let cornerRadius_equipment: CGFloat = 15.0
let zoom: Float = 12.0

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


//Fonts
let font_selected_filter = UIFont(name: "SFProDisplay-Regular", size: 18)
let font_unselected_filter = UIFont(name: "SFProDisplay-Regular", size: 16)
let font_alert_cancel = UIFont(name: "SFProDisplay-Regular", size: 17)
let font_category_name = UIFont(name: "SFProDisplay-Regular", size: 12)
let font_alert_agree = UIFont(name: "SFProDisplay-Semibold", size: 17)
let font_search_cell = UIFont(name: "SFProDisplay-Light", size: 16)
let font_chat_placeholder = UIFont(name: "SFProDisplay-Light", size: 12)

let font_alert_title = UIFont(name: "SFProDisplay-Semibold", size: 13)
// Images
let img_bkd = UIImage(named:"bkd")?.withRenderingMode(.alwaysOriginal)
let img_back = UIImage(named: "back")
let img_menu = UIImage(named: "menu")
let img_chat = UIImage(named: "chat")
let img_unselected_filter = UIImage(named: "show_car_param")
let img_map_marker = UIImage(named: "marker")
let img_check_box = UIImage(named: "check")
let img_uncheck_box = UIImage(named: "uncheck_box")

