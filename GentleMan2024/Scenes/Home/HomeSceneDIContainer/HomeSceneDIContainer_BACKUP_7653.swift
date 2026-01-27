//
//  HomeSceneDIContainer.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 5/13/24.
//

import Foundation
import UIKit

final class HomeSceneDIContainer: HomeSceneFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
<<<<<<< HEAD
    func makeMainTabBarController(homeVC: HomeVC, branchesVC: UIViewController, appointmentVC: UIViewController, addVC: UIViewController) -> UITabBarController {
        return MainTabbar.setupTabbar(homeVC: homeVC, branchesVC: branchesVC, appointmentVC: appointmentVC, addVC: addVC)
=======
    func makeMainTabBarController() -> UITabBarController {
        MainTabbar.v1 = makeHomeViewController(actions: HomeViewModelActions())
        MainTabbar.v2 = makeExploreViewController(actions: ExploreViewModelActions())
        return MainTabbar.setupTabbar()
>>>>>>> feature/main/Explore-Branch
    }
    
    // ExploreVC
    func makeExploreViewController(actions: ExploreViewModelActions) -> ExploreVC {
        ExploreVC.create(with: makeExploreViewModel(actions: actions))
    }

    func makeExploreViewModel(actions: ExploreViewModelActions) -> ExploreViewModelProtocol {
        ExploreViewModel(ExploreUseCase: makeExploreUseCase(), actions: actions)
    }

    func makeExploreUseCase() -> ExploreUseCaseProtocol {
        DefaultExploreUseCase(ExploreRepository: makeExploreRepository())
    }

    func makeExploreRepository() -> ExploreRepositoryProtocol {
        ExploreRepository(ExploreService: dependencies.apiDataTransferService)
    }
    
    // Offers 
    func makeOfferViewController(actions: OfferViewModelActions) -> OfferVC {
        OfferVC.create(with: makeOfferViewModel(actions: actions))
    }
    
    func makeOfferViewModel(actions: OfferViewModelActions) -> OfferViewModelProtocol {
        OfferViewModel(OfferUseCase: makeOfferUseCase(), actions: actions)
    }
    
    func makeOfferUseCase() -> OfferUseCaseProtocol {
        DefaultOfferUseCase(OfferRepository: makeOfferRepository())
    }
    
    func makeOfferRepository() -> OfferRepositoryProtocol {
        OfferRepository(OfferService: dependencies.apiDataTransferService)
    }
    
    // ServiceDetails
    func makeServiceDetailsViewController(serviceId: String,actions: ServiceDetailsViewModelActions) -> ServiceDetailsVC {
        ServiceDetailsVC.create(with: makeServiceDetailsViewModel(serviceId: serviceId, actions: actions))
    }
    
    func makeServiceDetailsViewModel(serviceId: String,actions: ServiceDetailsViewModelActions) -> ServiceDetailsViewModel {
        DefaultServiceDetailsViewModel(serviceId: serviceId, serviceDetailsCase: makeServiceDetailsUseCase(), actions: actions)
    }
    
    func makeServiceDetailsUseCase() -> ServiceDetailsUseCase {
        DefaultServiceDetailsUseCase(serviceDetailsRepository: makeServiceDetailsRepository())
    }
    
    func makeServiceDetailsRepository() -> ServiceDetailsRepository {
        DefaultServiceDetailsRepository(serviceDetailsService: dependencies.apiDataTransferService)
    }

    // Home
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeVC {
        HomeVC.create(with: makeHomeViewModel(actions: actions))
    }
    
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        DefaultHomeViewModel(HomeUseCase: makeHomeUseCase(), actions: actions)
    }
    
    func makeHomeUseCase() -> HomeUseCase {
        DefaultHomeUseCase(homeRepository: makeHomeRepository())
    }
    
    func makeHomeRepository() -> HomeRepository {
        DefaultHomeRepository(homeService: dependencies.apiDataTransferService)
    }
    
    func makeHomeFlowCoordinator(navigationController: UINavigationController) -> HomeSceneFlowCoordinator {
        HomeSceneFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
