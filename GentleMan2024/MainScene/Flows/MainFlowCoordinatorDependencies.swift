//
//  MainFlowCoordinatorDependencies.swift
//

import UIKit

protocol MainFlowCoordinatorDependencies  {
    func makeFeedViewController() -> FeedViewController
}

final class MainFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MainFlowCoordinatorDependencies
    
    private weak var mainTabBar: UITabBarController?

    init(navigationController: UINavigationController,
         dependencies: MainFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        // Navigate to feed for demo
        let feedVC = dependencies.makeFeedViewController()
        navigationController?.pushViewController(feedVC, animated: true)
    }
}
