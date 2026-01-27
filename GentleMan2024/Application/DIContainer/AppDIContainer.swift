//
//  AppDIContainer.swift
//  CodeBase
//
//  Created by MohamedSawy on 4/7/24.
//

import Foundation

final class AppDIContainer {
        
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        return DefaultDataTransferService()
    }()
    
    // MARK: - DIContainers of scenes
    func makeAuthSceneDIContainer() -> AuthSceneDIContainer {
        let dependencies = AuthSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService
        )
        return AuthSceneDIContainer(dependencies: dependencies)
    }
}
