//
//  DefaultLoginRepository.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/18/24.
//

import Foundation

final class DefaultLoginRepository {

    private let loginService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue

    init(
        loginService: DataTransferService,
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.loginService = loginService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultLoginRepository: LoginRepository {
    func login(communicationMethod: Int, countryCode: String, mobileNumber: String, completion: @escaping (Result<LoginModel, Error>) -> Void) {
        
        let requestDTO = LoginRequestDTO(communicationMethod: communicationMethod, countryCode: countryCode, mobileNumber: mobileNumber)
                
        let endpoint = LoginAPIEndpoints.loginUser(with: requestDTO)
        
        loginService.request(
            with: endpoint,
            on: backgroundQueue
        ) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
