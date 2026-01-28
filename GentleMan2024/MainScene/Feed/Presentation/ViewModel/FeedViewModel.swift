//
//  FeedViewModel.swift
//  GentleMan2024
//
//  Created on 2024.
//

import Foundation

protocol FeedViewModelInput {
    func viewDidLoad()
    func refresh()
    func loadMore()
    func searchVideos(query: String)
    func fetchNextPage(completion: (() -> Void)?)
}

protocol FeedViewModelOutput {
    var videos: BindableObservable<[VideoPost]> { get }
    var loading: BindableObservable<Loading> { get }
    var error: BindableObservable<String> { get }
}

protocol FeedViewModel: FeedViewModelInput, FeedViewModelOutput {}

final class DefaultFeedViewModel: FeedViewModel {
    
    // MARK: - Output
    let videos: BindableObservable<[VideoPost]> = BindableObservable([])
    let loading: BindableObservable<Loading> = BindableObservable(.Start)
    let error: BindableObservable<String> = BindableObservable("")
    
    // MARK: - Private
    private let fetchVideosUseCase: FetchVideosUseCase
    
    private var currentPage = 1
    private var hasMorePages = true
    private var isRefreshing = false
    private var searchQuery: String = ""
    private var allVideos: [VideoPost] = [] // Store all videos for search filtering
    
    init(fetchVideosUseCase: FetchVideosUseCase) {
        self.fetchVideosUseCase = fetchVideosUseCase
    }
    
    // MARK: - Input Methods
    func viewDidLoad() {
        fetchVideos(refresh: false)
    }
    
    func refresh() {
        fetchVideos(refresh: true)
    }
    
    func loadMore() {
        guard hasMorePages, !isRefreshing else { return }
        fetchVideos(refresh: false)
    }
    
    func searchVideos(query: String) {
        searchQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if searchQuery.isEmpty {
            // Show all videos if search is empty
            videos.value = allVideos
        } else {
            // Filter videos by username (case-insensitive)
            let filtered = allVideos.filter { video in
                video.userName.localizedCaseInsensitiveContains(searchQuery)
            }
            videos.value = filtered
        }
    }
    
    func fetchNextPage(completion: (() -> Void)?) {
        guard hasMorePages, !isRefreshing else {
            completion?()
            return
        }
        
        fetchVideos(refresh: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion?()
        }
    }
    
    // MARK: - Private Methods
    private func fetchVideos(refresh: Bool) {
        if refresh {
            currentPage = 1
            hasMorePages = true
            isRefreshing = true
        }
        
        guard hasMorePages else { return }
        
        loading.value = .Start
        
        let requestValue = FetchVideosUseCaseRequestValue(page: currentPage, perPage: 5)
        fetchVideosUseCase.execute(requestValue: requestValue) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loading.value = .Stop
                self.isRefreshing = false
                switch result {
                case .success(let feedResult):
                    let newVideos = feedResult.videos
                    if refresh {
                        self.allVideos = newVideos
                    } else {
                        self.allVideos.append(contentsOf: newVideos)
                    }
                    self.videos.value = self.allVideos
                    self.hasMorePages = feedResult.hasMorePages
                    if self.hasMorePages { self.currentPage += 1 }
                case .failure(let fetchError):
                    self.error.value = fetchError.localizedDescription
                }
            }
        }
    }
}
