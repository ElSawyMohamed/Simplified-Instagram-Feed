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
    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        let dependencies = MainSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService
        )
        return MainSceneDIContainer(dependencies: dependencies)
    }
}
