//
//  BaseURL.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/22/24.
//

import Foundation

enum BaseURL {
    case development
    case staging
    case production
    case preRelease
    case proDumb
    case glameraPro
    case newProduction
    case newProDumb
    
    var url: URL {
        switch self {
        case .development:
            return URL(string: "https://api-dev.glamera.com/api/v5/b2c/c/")!
        case .staging:
            return URL(string: "https://api-stage.glamera.com/api/v5/b2c/c/")!
        case .production:
            return URL(string: "https://api.glamera.com/api/v5/b2c/c/")!
        case .preRelease:
            return URL(string: "https://api-pre.glamera.com/api/v5/b2c/c/")!
        case .proDumb:
            return URL(string: "https://api-production-dump.glamera.com/api/v5/b2c/c/")!
        case .glameraPro:
            return URL(string: "https://glamerapro.glamera.com/api/v5/b2c/rl/")!
        case .newProduction:
            return URL(string: "https://api-newproduction.glamera.com/api/v5/b2c/c/")!
        case .newProDumb:
            return URL(string: "api-newprodump.glamera.com/api/v5/b2c/c/")!
        }
    }
}

class Endpoints {
    static let login = "auth/login"
    static let register = "auth/register"
    static let checkMobileNumber = "auth/check"
    static let resendOTP = "auth/resend-otp"
    static let deleteAccount = "auth/delete"
    static let logout = "auth/logout"
    
    static let getHomePage = "home"
    static let getService = "home/service/"
    static let searchSerivces = "home/search/services"
    static let getOffers = "home/offers"
    static let getBranchDetail = "branch/detail/"
    static let getBranchReviews = "branch/reviews/"
    static let getEmployeeTiming = "employee/list/timing/"
    static let addBranchReviews = "branch/reviews"
    
    
    static let getSpecialistTimeSlots = "employee/list/timing/"
    static let getDayTimeSlots = "employee/list/day/"
    
    static let getAddDeleteCart = "cart/"
    
    static let getAddUpdateAddress = "addresses"
    static let selectAddress = "addresses/select/"
    
    static let applyPromocode = "promocodes/apply"
    static let removePromocode = "promocodes/remove"
    
    static let getLoyaltyPoints = "loyalty"
    static let applyLoyaltyPoint = "loyalty/apply"
    static let removeLoyaltyPoint = "loyalty/remove"
    static let getBrnachesList = "branch/list"
    
   
    static let getProfile = "client/info"
    static let updateProfile = "client/update"
    
    static let getOrders = "orders"
    static let cancelOrder = "orders/cancel-appointment"
    static let cancelAppointmentItem = "orders/cancel-appointment-item"
    static let rescheduleAppointmentItem = "orders/reschedule-appointment-item"
    static let getCanelReasons = "orders/cancel-reasons"
   
    static let getAboutApp = "resources/aboutUs"
    
    static let paymentCheckout = "payment/checkout"
    static let paymentOnileCheckout = "payment/ConfirmPayment"
    
    static let getWallet = "wallet"
    static let addWallet = "wallet/apply"
    
    static let rateData = "branch/reviews/getRating/"
    static let skipRating = "branch/reviews/skip/"
    static let reOrder = "cart/reorder/"
    
    static let getBoosting = "home/boosting"
    
    static let getConfig = "home/configs"
    static let getPackages = "packages"
    static let getPackageDetails = "packages/detail"
    
    static let getMyPackages = "packages/GetClientPackages"
    static let getMyPackageDetails = "packages/GetClientPackagesWithDetails/"
    
    // Package TimeSlots
    static let groupAttendList = "group/attend-list"
    
    static let getOffersNames = "home/GetAllB2BOffersNames"
    static let getOffersDetails = "home/GetOfferDetails/"
}
