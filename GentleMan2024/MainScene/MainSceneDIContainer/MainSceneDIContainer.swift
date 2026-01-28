//
//  MainSceneDIContainer.swift
//

import Foundation
import UIKit

final class MainSceneDIContainer: MainFlowCoordinatorDependencies {
    
    private let appDIContainer = AppDIContainer()

    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Video Feed
    func makeFeedViewController() -> FeedViewController {
        FeedViewController.create(with: makeFeedViewModel())
    }
    
    func makeFeedViewModel() -> FeedViewModel {
        DefaultFeedViewModel(fetchVideosUseCase: makeFetchVideosUseCase())
    }
    
    func makeFetchVideosUseCase() -> FetchVideosUseCase {
        DefaultFetchVideosUseCase(videoRepository: makeVideoRepository())
    }
    
    func makeVideoRepository() -> VideoRepository {
        DefaultVideoRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    // MARK: - Flow Coordinators
    func makeMainFlowCoordinator(navigationController: UINavigationController) -> MainFlowCoordinator {
        MainFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
