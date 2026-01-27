//
//  AppFlowCoordinator.swift
//  CodeBase
//
//  Created by MohamedSawy on 4/5/24.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func startAuth() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let authSceneDIContainer = appDIContainer.makeAuthSceneDIContainer()
        let flow = authSceneDIContainer.makeAuthFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
