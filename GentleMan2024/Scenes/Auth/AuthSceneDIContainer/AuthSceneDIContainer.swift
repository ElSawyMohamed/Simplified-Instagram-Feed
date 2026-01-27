//
//  AuthSceneDIContainer.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/21/24.
//

import Foundation
import UIKit

final class AuthSceneDIContainer: AuthFlowCoordinatorDependencies {
    
    private let appDIContainer = AppDIContainer()

    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginVC {
        LoginVC.create(with: makeLoginViewModel(actions: actions))
    }
    
    func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        DefaultLoginViewModel(loginUseCase: makeLoginUseCase(), actions: actions)
    }
    
    func makeLoginUseCase() -> LoginUseCase {
        DefaultLoginUseCase(loginRepository: makeLoginRepository())
    }
    
    func makeLoginRepository() -> LoginRepository {
        DefaultLoginRepository(loginService: dependencies.apiDataTransferService)
    }
    
    // MARK: - Flow Coordinators
    func makeAuthFlowCoordinator(navigationController: UINavigationController) -> AuthFlowCoordinator {
        AuthFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
