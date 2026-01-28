//
//  Constants.swift
//
//  Created by MohamedSawy on 4/16/24.
//

import UIKit

struct AppConstants {
    static let ScreenWidth = UIScreen.main.bounds.width
    static let ScreenHeight = UIScreen.main.bounds.height
    static let defult = UserDefaults.standard
}

struct AppColors {
    static let primaryColor = #colorLiteral(red: 0.862745098, green: 0.3490196078, blue: 0.7254901961, alpha: 1)
    static let secondaryColor = #colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1)
    static let greenColor = #colorLiteral(red: 0.1529411765, green: 0.6823529412, blue: 0.3764705882, alpha: 1)
    static let borderColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
    static let selectionColor = #colorLiteral(red: 0.8666666667, green: 0.631372549, blue: 0.368627451, alpha: 1)
    static let progressColor = #colorLiteral(red: 0.5450980392, green: 0.3607843137, blue: 0.9647058824, alpha: 1)
    static let buttonBackgroundColor = #colorLiteral(red: 0.9764705882, green: 0.8352941176, blue: 0.9490196078, alpha: 1)
    static let dimmedText = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
    static let dimmedBackground = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
}

struct GoogleMapsConstants {
    static let apiKey = "AIzaSyAAKr8WJ4SLotokO5sNWA_mk_mKopa1Dd0"
}

struct HeadersConstants {
    static let contentType = "application/json"
    static let apiKey = "1jsXKmnPgAefMbT0LbWacjkOh0GoTaOjQ57Jd6aMHpxZySksOJTqXu44"
}
