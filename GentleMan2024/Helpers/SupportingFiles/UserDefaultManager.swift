//
//  UserDefaultManager.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/28/24.
//

import Foundation

struct UserDefaultsManager {
    
    private init() {}
    
    private let firstTime = "firstTime"
    private let firstTimeTerms = "firstTimeTerms"
    private let isLoggedIn = "isLoggedIn"
    private let token = "token"
    private let lang = "lang"
    private let asAGuest = "asAGuest"
    private let userName = "userName"
    private let phoneNumber = "phoneNumber"
    private let email = "email"
    private let firebaseToken = "firebaseToken"
    private let banarImageURL = "banarImageURL"
    private let popupImageURL = "popupImageURL"
    private let userConfig = "userConfig"
    private let savedOfferDetails = "savedOfferDetails"
    private let savedOfferServices = "savedOfferServices"
    
    private let nationID = "nationID"
    
    private let userDefaults = UserDefaults.standard
    
    static var shared = UserDefaultsManager()
    
    var isFirstTime: Bool? {
        get {
            return userDefaults.bool(forKey: firstTime)
        } set {
            userDefaults.set(newValue, forKey: firstTime)
        }
    }
    
    var isFirstTimeOpenPopUp: Bool? {
        get {
            return userDefaults.bool(forKey: firstTimeTerms)
        } set {
            userDefaults.set(newValue, forKey: firstTimeTerms)
        }
    }
    
    var appLang: String? {
        get {
            return userDefaults.string(forKey: lang)
        } set {
            userDefaults.set(newValue, forKey: lang)
        }
    }
    
    var asAGuestFlag: Bool? {
        get {
            return userDefaults.bool(forKey: asAGuest)
        } set {
            userDefaults.set(newValue, forKey: asAGuest)
        }
    }
   
    var userToken: String?{
        get{
            return userDefaults.string(forKey: token)
        } set {
            userDefaults.set(newValue, forKey: token)
        }
    }
    
    var fullName: String? {
        get {
            return userDefaults.string(forKey: userName)
        } set {
            userDefaults.set(newValue, forKey: userName)
        }
    }
    
    var userEmail: String? {
        get {
            return userDefaults.string(forKey: email)
        } set {
            userDefaults.set(newValue, forKey: email)
        }
    }
    
    var userPhoneNumber: String? {
        get {
            return userDefaults.string(forKey: phoneNumber)
        } set {
            userDefaults.set(newValue, forKey: phoneNumber)
        }
    }
    
    var fcmToken: String? {
        get {
            return userDefaults.string(forKey: firebaseToken)
        } set {
            userDefaults.set(newValue, forKey: firebaseToken)
        }
    }
    
    var banarImage: String? {
        get {
            return userDefaults.string(forKey: banarImageURL)
        } set {
            userDefaults.set(newValue, forKey: banarImageURL)
        }
    }
    
    var popupImage: String? {
        get {
            return userDefaults.string(forKey: popupImageURL)
        } set {
            userDefaults.set(newValue, forKey: popupImageURL)
        }
    }
    
    func removeUserSession() {
        userDefaults.removeObject(forKey: token)
        userDefaults.synchronize()
    }
}
