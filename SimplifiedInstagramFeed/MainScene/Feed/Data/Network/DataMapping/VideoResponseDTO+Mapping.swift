//
//  VideoResponseDTO+Mapping.swift
//
//  Created on 2024.
//

import Foundation

// MARK: - VideoResponseDTO (Data Transfer Object)
struct VideoResponseDTO: Decodable {
    let page: Int
    let perPage: Int
    let totalResults: Int
    let videos: [VideoPostDTO]
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
        case videos
    }
}

struct VideoPostDTO: Decodable {
    let id: Int
    let duration: Int
    let image: String
    let user: UserDTO
    let videoFiles: [VideoFileDTO]
    
    enum CodingKeys: String, CodingKey {
        case id
        case duration
        case image
        case user
        case videoFiles = "video_files"
    }
}

struct UserDTO: Decodable {
    let name: String
}

struct VideoFileDTO: Decodable {
    let id: Int
    let quality: String
    let fileType: String
    let width: Int
    let height: Int
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case quality
        case fileType = "file_type"
        case width
        case height
        case link
    }
}

// MARK: - Mapping Extensions
extension VideoResponseDTO {
    func toDomain() -> VideoFeedResult {
        let domainVideos = videos.map { $0.toDomain() }
        let totalPages = Int(ceil(Double(totalResults) / Double(perPage)))
        let hasMorePages = page < totalPages
        
        return VideoFeedResult(
            videos: domainVideos,
            page: page,
            perPage: perPage,
            totalResults: totalResults,
            hasMorePages: hasMorePages
        )
    }
}

extension VideoPostDTO {
    func toDomain() -> VideoPost {
        // Find highest resolution video
        let sortedVideos = videoFiles.sorted { $0.width * $0.height > $1.width * $1.height }
        let highestResVideo = sortedVideos.first ?? videoFiles.first!
        
        return VideoPost(
            id: id,
            duration: duration,
            userName: user.name,
            videoURL: highestResVideo.link,
            thumbnailURL: image
        )
    }
}

