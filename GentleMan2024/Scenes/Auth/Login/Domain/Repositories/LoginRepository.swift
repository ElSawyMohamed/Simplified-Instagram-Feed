//
//  LoginRepository.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/18/24.
//

import Foundation

protocol LoginRepository {
    func login(
        communicationMethod: Int,
        countryCode: String,
        mobileNumber: String,
        completion: @escaping (Result<LoginModel, Error>) -> Void
    )
}
