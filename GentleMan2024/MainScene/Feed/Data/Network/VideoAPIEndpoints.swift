//
//  VideoAPIEndpoints.swift
//  GentleMan2024
//
//  Created on 2024.
//

import Foundation

struct VideoAPIEndpoints {
    static func fetchPopularVideos(page: Int, perPage: Int) -> Endpoint<VideoResponseDTO> {
        return Endpoint(
            path: Endpoints.showFeed,
            method: .get,
            queryParameters: [
                "page": "\(page)",
                "per_page": "\(perPage)"
            ]
        )
    }
}


