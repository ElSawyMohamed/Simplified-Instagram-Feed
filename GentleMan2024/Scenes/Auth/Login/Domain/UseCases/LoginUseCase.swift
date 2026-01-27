//
//  LoginUseCase.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/18/24.
//

import Foundation

protocol LoginUseCase {
    func execute(
        requestValue: LoginUseCaseRequestValue,
        completion: @escaping (Result<LoginModel, Error>) -> Void
    )
}

final class DefaultLoginUseCase: LoginUseCase {
    
    private let loginRepository: LoginRepository
    
    init(
        loginRepository: LoginRepository
    ) {
        self.loginRepository = loginRepository
    }
    
    func execute(requestValue: LoginUseCaseRequestValue,
                 completion: @escaping (Result<LoginModel,
                                        Error>) -> Void){
        
        return loginRepository.login(communicationMethod: requestValue.communicationMethod, countryCode: requestValue.countryCode, mobileNumber: requestValue.mobileNumber,
                                     completion: { result in
            if case .success = result {
                print("success")
            }
            completion(result)
        })
    }
}

struct LoginUseCaseRequestValue {
    let communicationMethod: Int
    let countryCode: String
    let mobileNumber: String
}
