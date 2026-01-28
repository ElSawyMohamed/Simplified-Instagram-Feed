//
//  VideoCacheService.swift
//  GentleMan2024
//
//  Created on 2024.
//

import Foundation
import AVFoundation
import CryptoKit

protocol VideoCacheService {
    func getCachedVideoURL(for urlString: String) -> URL?
    func cacheVideo(from url: URL, completion: @escaping (Result<URL, Error>) -> Void)
}

final class DefaultVideoCacheService: VideoCacheService {
    
    private let cacheDirectory: URL
    private let fileManager = FileManager.default
    
    init() {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesDirectory.appendingPathComponent("VideoCache", isDirectory: true)
        
        // Create cache directory if it doesn't exist
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    func getCachedVideoURL(for urlString: String) -> URL? {
        let fileName = urlString.md5 + ".mp4"
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            return fileURL
        }
        
        return nil
    }
    
    func cacheVideo(from url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let fileName = url.absoluteString.md5 + ".mp4"
        let destinationURL = cacheDirectory.appendingPathComponent(fileName)
        
        // Check if already cached
        if fileManager.fileExists(atPath: destinationURL.path) {
            completion(.success(destinationURL))
            return
        }
        
        // Download and cache
        URLSession.shared.downloadTask(with: url) { [weak self] tempURL, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let tempURL = tempURL else {
                completion(.failure(NSError(domain: "VideoCacheService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No temp URL"])))
                return
            }
            
            do {
                try self.fileManager.moveItem(at: tempURL, to: destinationURL)
                completion(.success(destinationURL))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - String MD5 Extension
import CryptoKit

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = Insecure.MD5.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

