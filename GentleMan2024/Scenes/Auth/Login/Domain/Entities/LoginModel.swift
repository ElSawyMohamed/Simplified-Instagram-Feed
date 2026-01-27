//
//  LoginModel.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/18/24.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let state: Int?
    let message: String?
    let data: LoginData?
}

// MARK: - LoginData
struct LoginData: Codable {
    let otp: String?
}
