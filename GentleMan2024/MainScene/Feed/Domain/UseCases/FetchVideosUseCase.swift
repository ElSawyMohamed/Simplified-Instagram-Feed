//
//  FetchVideosUseCase.swift
//  GentleMan2024
//
//  Created on 2024.
//

import Foundation

protocol FetchVideosUseCase {
    func execute(
        requestValue: FetchVideosUseCaseRequestValue,
        completion: @escaping (Result<VideoFeedResult, Error>) -> Void
    )
}

final class DefaultFetchVideosUseCase: FetchVideosUseCase {
    
    private let videoRepository: VideoRepository
    
    init(videoRepository: VideoRepository) {
        self.videoRepository = videoRepository
    }
    
    func execute(
        requestValue: FetchVideosUseCaseRequestValue,
        completion: @escaping (Result<VideoFeedResult, Error>) -> Void
    ) {
        videoRepository.fetchVideos(
            page: requestValue.page,
            perPage: requestValue.perPage,
            completion: completion
        )
    }
}

struct FetchVideosUseCaseRequestValue {
    let page: Int
    let perPage: Int
    
    init(page: Int = 1, perPage: Int = 10) {
        self.page = page
        self.perPage = perPage
    }
}


