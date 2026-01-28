//
//  DefaultVideoRepository.swift
//  GentleMan2024
//
//  Created on 2024.
//

import Foundation

final class DefaultVideoRepository {
    
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultVideoRepository: VideoRepository {
    func fetchVideos(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<VideoFeedResult, Error>) -> Void
    ) {
        let endpoint = VideoAPIEndpoints.fetchPopularVideos(page: page, perPage: perPage)
        
        dataTransferService.request(with: endpoint) { response in
            switch response {
            case .success(let model):
                completion(.success(model.toDomain()))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}


