//
//  LoginRequestDTO+Mapping.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/18/24.
//

import Foundation

// MARK: - LoginRequestDTO
struct LoginRequestDTO: Encodable {
    let communicationMethod: Int?
    let countryCode: String?
    let mobileNumber: String?
}
