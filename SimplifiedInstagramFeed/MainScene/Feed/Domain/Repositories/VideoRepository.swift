//
//  VideoRepository.swift
//
//  Created on 2024.
//

import Foundation

protocol VideoRepository {
    func fetchVideos(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<VideoFeedResult, Error>) -> Void
    )
}

struct VideoFeedResult {
    let videos: [VideoPost]
    let page: Int
    let perPage: Int
    let totalResults: Int
    let hasMorePages: Bool
}

