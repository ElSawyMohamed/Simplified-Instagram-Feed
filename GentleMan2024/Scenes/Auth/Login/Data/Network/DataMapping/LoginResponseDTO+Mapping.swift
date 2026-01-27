//
//  LoginResponseDTO+Mapping.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/18/24.
//

import Foundation

// MARK: - LoginResponseDTO
struct LoginResponseDTO: Decodable {
    let state: Int?
    let message: String?
    let data: UserDTO?
}

extension LoginResponseDTO {
    struct UserDTO: Decodable {
        let otp: String?
    }
}

extension LoginResponseDTO {
    func toDomain() -> LoginModel {
        return .init(state: state, message: message, data: data?.toDomain())
    }
}

extension LoginResponseDTO.UserDTO {
    func toDomain() -> LoginData {
        return .init(otp: otp)
    }
}
