//
//  VideoPost.swift
//  GentleMan2024
//
//  Created on 2024.
//

import Foundation

// MARK: - Domain Entity (No dependencies on other layers)
struct VideoPost {
    let id: Int
    let duration: Int
    let userName: String
    let videoURL: String
    let thumbnailURL: String
}


