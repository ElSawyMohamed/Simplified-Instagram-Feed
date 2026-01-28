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

    func startMain() {
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer()
        let flow = mainSceneDIContainer.makeMainFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
