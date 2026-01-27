//
//  LoginAPIEndpoints.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/18/24.
//

struct LoginAPIEndpoints {
    static func loginUser(with loginRequestDTO: LoginRequestDTO) -> Endpoint<LoginResponseDTO> {
        return Endpoint(
            path: Endpoints.checkMobileNumber,
            method: .post,
            bodyParametersEncodable: loginRequestDTO
        )
    }
}
