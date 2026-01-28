//
//  BaseURL.swift
//
//  Created by MohamedSawy on 4/22/24.
//

import Foundation

enum BaseURL {
    case development
    
    var url: URL {
        switch self {
        case .development:
            return URL(string: "https://api.pexels.com/")!
        }
    }
}

class Endpoints {
    static let showFeed = "videos/popular"
}
