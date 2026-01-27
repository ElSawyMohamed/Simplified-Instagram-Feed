//
//  AuthFlowCoordinatorDependencies.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/21/24.
//

import UIKit

protocol AuthFlowCoordinatorDependencies  {
    func makeLoginViewController(actions: LoginViewModelActions
    ) -> LoginVC
}

final class AuthFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: AuthFlowCoordinatorDependencies

    private weak var loginVC: LoginVC?
    
    private weak var mainTabBar: UITabBarController?

    init(navigationController: UINavigationController,
         dependencies: AuthFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = LoginViewModelActions()
        let vc = dependencies.makeLoginViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        loginVC = vc
    }
    
    private func backFromVerifyCodeOption() {
        navigationController?.popViewController(animated: true)
    }
}
