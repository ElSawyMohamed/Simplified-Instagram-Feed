//
//  FeedViewModelTests.swift
//  GentleMan2024Tests
//
//  Created on 2024.
//

import XCTest
@testable import GentleMan2024

final class FeedViewModelTests: XCTestCase {
    
    var sut: DefaultFeedViewModel!
    var mockFetchVideosUseCase: MockFetchVideosUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockFetchVideosUseCase = MockFetchVideosUseCase()
        sut = DefaultFeedViewModel(fetchVideosUseCase: mockFetchVideosUseCase)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockFetchVideosUseCase = nil
        try super.tearDownWithError()
    }
    
    // MARK: - viewDidLoad Tests
    
    func testViewDidLoad_FetchesVideos() {
        // Given
        let expectation = XCTestExpectation(description: "Videos should be fetched")
        let mockVideos = createMockVideos(count: 3)
        let mockResult = VideoFeedResult(
            videos: mockVideos,
            page: 1,
            perPage: 5,
            totalResults: 10,
            hasMorePages: true
        )
        mockFetchVideosUseCase.result = .success(mockResult)
        
        var videosReceived: [VideoPost] = []
        sut.videos.observe { videos in
            if !videos.isEmpty {
                videosReceived = videos
                expectation.fulfill()
            }
        }
        
        // When
        sut.viewDidLoad()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(videosReceived.count, 3)
        XCTAssertEqual(mockFetchVideosUseCase.executeCallCount, 1)
        XCTAssertEqual(mockFetchVideosUseCase.lastRequestValue?.page, 1)
        XCTAssertEqual(mockFetchVideosUseCase.lastRequestValue?.perPage, 5)
    }
    
    func testViewDidLoad_SetsLoadingState() {
        // Given
        let expectation = XCTestExpectation(description: "Loading state should change")
        expectation.expectedFulfillmentCount = 2 // Start and Stop
        var loadingStates: [Loading] = []
        
        sut.loading.observe { loading in
            loadingStates.append(loading)
            expectation.fulfill()
        }
        
        let mockVideos = createMockVideos(count: 2)
        let mockResult = VideoFeedResult(
            videos: mockVideos,
            page: 1,
            perPage: 5,
            totalResults: 10,
            hasMorePages: true
        )
        mockFetchVideosUseCase.result = .success(mockResult)
        
        // When
        sut.viewDidLoad()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(loadingStates.contains(.Start))
        XCTAssertTrue(loadingStates.contains(.Stop))
    }
    
    // MARK: - refresh Tests
    
    func testRefresh_ResetsToFirstPage() {
        // Given
        let expectation = XCTestExpectation(description: "Refresh should reset to page 1")
        let mockVideos = createMockVideos(count: 5)
        let mockResult = VideoFeedResult(
            videos: mockVideos,
            page: 1,
            perPage: 5,
            totalResults: 10,
            hasMorePages: true
        )
        mockFetchVideosUseCase.result = .success(mockResult)
        
        sut.videos.observe { videos in
            if videos.count == 5 {
                expectation.fulfill()
            }
        }
        
        // When
        sut.refresh()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(mockFetchVideosUseCase.lastRequestValue?.page, 1)
    }
    
    func testRefresh_ReplacesExistingVideos() {
        // Given
        let initialVideos = createMockVideos(count: 3)
        let initialResult = VideoFeedResult(
            videos: initialVideos,
            page: 1,
            perPage: 5,
            totalResults: 10,
            hasMorePages: true
        )
        mockFetchVideosUseCase.result = .success(initialResult)
        
        let initialExpectation = XCTestExpectation(description: "Initial videos loaded")
        sut.videos.observe { videos in
            if videos.count == 3 {
                initialExpectation.fulfill()
            }
        }
        sut.viewDidLoad()
        wait(for: [initialExpectation], timeout: 2.0)
        
        // When - refresh with different videos
        let refreshVideos = createMockVideos(count: 2, startId: 10)
        let refreshResult = VideoFeedResult(
            videos: refreshVideos,
            page: 1,
            perPage: 5,
            totalResults: 10,
            hasMorePages: true
        )
        mockFetchVideosUseCase.result = .success(refreshResult)
        
        let refreshExpectation = XCTestExpectation(description: "Refresh should replace videos")
        sut.videos.observe { videos in
            if videos.count == 2 && videos.first?.id == 10 {
                refreshExpectation.fulfill()
            }
        }
        sut.refresh()
        
        // Then
        wait(for: [refreshExpectation], timeout: 2.0)
        XCTAssertEqual(sut.videos.value.count, 2)
    }
    
    // MARK: - loadMore Tests
    
    func testLoadMore_DoesNotLoadWhenNoMorePages() {
        // Given
        let mockVideos = createMockVideos(count: 3)
        let mockResult = VideoFeedResult(
            videos: mockVideos,
            page: 1,
            perPage: 5,
            totalResults: 3,
            hasMorePages: false
        )
        mockFetchVideosUseCase.result = .success(mockResult)
        
        let initialExpectation = XCTestExpectation(description: "Initial load")
        sut.videos.observe { videos in
            if videos.count == 3 {
                initialExpectation.fulfill()
            }
        }
        sut.viewDidLoad()
        wait(for: [initialExpectation], timeout: 2.0)
        
        let initialCallCount = mockFetchVideosUseCase.executeCallCount
        
        // When
        sut.loadMore()
        
        // Then
        XCTAssertEqual(mockFetchVideosUseCase.executeCallCount, initialCallCount, "Should not fetch more when hasMorePages is false")
    }
    
    func testLoadMore_AppendsVideosWhenMorePagesAvailable() {
        // Given
        let initialVideos = createMockVideos(count: 3)
        let initialResult = VideoFeedResult(
            videos: initialVideos,
            page: 1,
            perPage: 5,
            totalResults: 10,
            hasMorePages: true
        )
        mockFetchVideosUseCase.result = .success(initialResult)
        
        let initialExpectation = XCTestExpectation(description: "Initial load")
        sut.videos.observe { videos in
            if videos.count == 3 {
                initialExpectation.fulfill()
            }
        }
        sut.viewDidLoad()
        wait(for: [initialExpectation], timeout: 2.0)
        
        // When - load more
        let moreVideos = createMockVideos(count: 2, startId: 10)
        let moreResult = VideoFeedResult(
            videos: moreVideos,
            page: 2,
            perPage: 5,
            totalResults: 10,
            hasMorePages: true
        )
        mockFetchVideosUseCase.result = .success(moreResult)
        
        let loadMoreExpectation = XCTestExpectation(description: "Load more should append videos")
        sut.videos.observe { videos in
            if videos.count == 5 {
                loadMoreExpectation.fulfill()
            }
        }
        sut.loadMore()
        
        // Then
        wait(for: [loadMoreExpectation], timeout: 2.0)
        XCTAssertEqual(sut.videos.value.count, 5)
        XCTAssertEqual(mockFetchVideosUseCase.lastRequestValue?.page, 2)
    }
    
    func testLoadMore_DoesNotLoadWhenRefreshing() {
        // Given
        let mockVideos = createMockVideos(count: 3)
        let mockResult = VideoFeedResult(
            videos: mockVideos,
            page: 1,
            perPage: 5,
            totalResults: 10,
            hasMorePages: true
        )
        mockFetchVideosUseCase.result = .success(mockResult)
        
        // Start refresh (which sets isRefreshing to true)
        sut.refresh()
        
        let initialCallCount = mockFetchVideosUseCase.executeCallCount
        
        // When
        sut.loadMore()
        
        // Then
        XCTAssertEqual(mockFetchVideosUseCase.executeCallCount, initialCallCount, "Should not load more while refreshing")
    }
    
    // MARK: - searchVideos Tests
    
    func testSearchVideos_ShowsAllVideosWhenQueryIsEmpty() {
        // Given
        let allVideos = [
            createVideoPost(id: 1, userName: "John"),
            createVideoPost(id: 2, userName: "Jane"),
            createVideoPost(id: 3, userName: "Bob")
        ]
        let mockResult = VideoFeedResult(
            videos: allVideos,
            page: 1,
            perPage: 5,
            totalResults: 3,
            hasMorePages: false
        )
        mockFetchVideosUseCase.result = .success(mockResult)
        
        let initialExpectation = XCTestExpectation(description: "Initial load")
        sut.videos.observe { videos in
            if videos.count == 3 {
                initialExpectation.fulfill()
            }
        }
        sut.viewDidLoad()
        wait(for: [initialExpectation], timeout: 2.0)
        
        // When
        sut.searchVideos(query: "")
        
        // Then
        XCTAssertEqual(sut.videos.value.count, 3)
    }
    
    func testSearchVideos_FiltersVideosByUsername() {
        // Given
        let allVideos = [
            createVideoPost(id: 1, userName: "John"),
            createVideoPost(id: 2, userName: "Jane"),
            createVideoPost(id: 3, userName: "Johnny")
        ]
        let mockResult = VideoFeedResult(
            videos: allVideos,
            page: 1,
            perPage: 5,
            totalResults: 3,
            hasMorePages: false
        )
        mockFetchVideosUseCase.result = .success(mockResult)
        
        let initialExpectation = XCTestExpectation(description: "Initial load")
        sut.videos.observe { videos in
            if videos.count == 3 {
                initialExpectation.fulfill()
            }
        }
        sut.viewDidLoad()
        wait(for: [initialExpectation], timeout: 2.0)
        
        // When
        sut.searchVideos(query: "John")
        
        // Then
        XCTAssertEqual(sut.videos.value.count, 2)
        XCTAssertTrue(sut.videos.value.allSatisfy { $0.userName.contains("John") })
    }
    
    func testSearchVideos_IsCaseInsensitive() {
        // Given
        let allVideos = [
            createVideoPost(id: 1, userName: "John"),
            createVideoPost(id: 2, userName: "jane"),
            createVideoPost(id: 3, userName: "JOHN")
        ]
        let mockResult = VideoFeedResult(
            videos: allVideos,
            page: 1,
            perPage: 5,
            totalResults: 3,
            hasMorePages: false
        )
        mockFetchVideosUseCase.result = .success(mockResult)
        
        let initialExpectation = XCTestExpectation(description: "Initial load")
        sut.videos.observe { videos in
            if videos.count == 3 {
                initialExpectation.fulfill()
            }
        }
        sut.viewDidLoad()
        wait(for: [initialExpectation], timeout: 2.0)
        
        // When
        sut.searchVideos(query: "john")
        
        // Then
        XCTAssertEqual(sut.videos.value.count, 2)
        XCTAssertTrue(sut.videos.value.allSatisfy { $0.userName.localizedCaseInsensitiveContains("john") })
    }
    
    func testSearchVideos_TrimsWhitespace() {
        // Given
        let allVideos = [
            createVideoPost(id: 1, userName: "John"),
            createVideoPost(id: 2, userName: "Jane")
        ]
        let mockResult = VideoFeedResult(
            videos: allVideos,
            page: 1,
            perPage: 5,
            totalResults: 2,
            hasMorePages: false
        )
        mockFetchVideosUseCase.result = .success(mockResult)
        
        let initialExpectation = XCTestExpectation(description: "Initial load")
        sut.videos.observe { videos in
            if videos.count == 2 {
                initialExpectation.fulfill()
            }
        }
        sut.viewDidLoad()
        wait(for: [initialExpectation], timeout: 2.0)
        
        // When
        sut.searchVideos(query: "  John  ")
        
        // Then
        XCTAssertEqual(sut.videos.value.count, 1)
        XCTAssertEqual(sut.videos.value.first?.userName, "John")
    }
    
    // MARK: - fetchNextPage Tests
    
    func testFetchNextPage_CallsCompletionWhenNoMorePages() {
        // Given
        let mockVideos = createMockVideos(count: 3)
        let mockResult = VideoFeedResult(
            videos: mockVideos,
            page: 1,
            perPage: 5,
            totalResults: 3,
            hasMorePages: false
        )
        mockFetchVideosUseCase.result = .success(mockResult)
        
        let initialExpectation = XCTestExpectation(description: "Initial load")
        sut.videos.observe { videos in
            if videos.count == 3 {
                initialExpectation.fulfill()
            }
        }
        sut.viewDidLoad()
        wait(for: [initialExpectation], timeout: 2.0)
        
        // When
        let completionExpectation = XCTestExpectation(description: "Completion should be called")
        sut.fetchNextPage {
            completionExpectation.fulfill()
        }
        
        // Then
        wait(for: [completionExpectation], timeout: 2.0)
    }
    
    func testFetchNextPage_FetchesNextPageWhenAvailable() {
        // Given
        let initialVideos = createMockVideos(count: 3)
        let initialResult = VideoFeedResult(
            videos: initialVideos,
            page: 1,
            perPage: 5,
            totalResults: 10,
            hasMorePages: true
        )
        mockFetchVideosUseCase.result = .success(initialResult)
        
        let initialExpectation = XCTestExpectation(description: "Initial load")
        sut.videos.observe { videos in
            if videos.count == 3 {
                initialExpectation.fulfill()
            }
        }
        sut.viewDidLoad()
        wait(for: [initialExpectation], timeout: 2.0)
        
        // When
        let moreVideos = createMockVideos(count: 2, startId: 10)
        let moreResult = VideoFeedResult(
            videos: moreVideos,
            page: 2,
            perPage: 5,
            totalResults: 10,
            hasMorePages: true
        )
        mockFetchVideosUseCase.result = .success(moreResult)
        
        let completionExpectation = XCTestExpectation(description: "Completion should be called")
        sut.fetchNextPage {
            completionExpectation.fulfill()
        }
        
        // Then
        wait(for: [completionExpectation], timeout: 3.0)
        XCTAssertEqual(mockFetchVideosUseCase.lastRequestValue?.page, 2)
    }
    
    // MARK: - Error Handling Tests
    
    func testFetchVideos_HandlesError() {
        // Given
        let error = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockFetchVideosUseCase.result = .failure(error)
        
        let errorExpectation = XCTestExpectation(description: "Error should be set")
        sut.error.observe { errorMessage in
            if !errorMessage.isEmpty {
                errorExpectation.fulfill()
            }
        }
        
        // When
        sut.viewDidLoad()
        
        // Then
        wait(for: [errorExpectation], timeout: 2.0)
        XCTAssertEqual(sut.error.value, "Network error")
    }
    
    func testFetchVideos_StopsLoadingOnError() {
        // Given
        let error = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockFetchVideosUseCase.result = .failure(error)
        
        let loadingExpectation = XCTestExpectation(description: "Loading should stop")
        loadingExpectation.expectedFulfillmentCount = 2
        var loadingStates: [Loading] = []
        
        sut.loading.observe { loading in
            loadingStates.append(loading)
            loadingExpectation.fulfill()
        }
        
        // When
        sut.viewDidLoad()
        
        // Then
        wait(for: [loadingExpectation], timeout: 2.0)
        XCTAssertEqual(loadingStates.last, .Stop)
    }
    
    // MARK: - Pagination Tests
    
    func testPagination_IncrementsPageAfterSuccessfulFetch() {
        // Given
        let firstPageVideos = createMockVideos(count: 3)
        let firstPageResult = VideoFeedResult(
            videos: firstPageVideos,
            page: 1,
            perPage: 5,
            totalResults: 10,
            hasMorePages: true
        )
        mockFetchVideosUseCase.result = .success(firstPageResult)
        
        let initialExpectation = XCTestExpectation(description: "First page loaded")
        sut.videos.observe { videos in
            if videos.count == 3 {
                initialExpectation.fulfill()
            }
        }
        sut.viewDidLoad()
        wait(for: [initialExpectation], timeout: 2.0)
        
        // When - load more
        let secondPageVideos = createMockVideos(count: 2, startId: 10)
        let secondPageResult = VideoFeedResult(
            videos: secondPageVideos,
            page: 2,
            perPage: 5,
            totalResults: 10,
            hasMorePages: true
        )
        mockFetchVideosUseCase.result = .success(secondPageResult)
        
        let secondPageExpectation = XCTestExpectation(description: "Second page loaded")
        sut.videos.observe { videos in
            if videos.count == 5 {
                secondPageExpectation.fulfill()
            }
        }
        sut.loadMore()
        
        // Then
        wait(for: [secondPageExpectation], timeout: 2.0)
        XCTAssertEqual(mockFetchVideosUseCase.lastRequestValue?.page, 2)
    }
    
    func testPagination_DoesNotIncrementWhenNoMorePages() {
        // Given
        let mockVideos = createMockVideos(count: 3)
        let mockResult = VideoFeedResult(
            videos: mockVideos,
            page: 1,
            perPage: 5,
            totalResults: 3,
            hasMorePages: false
        )
        mockFetchVideosUseCase.result = .success(mockResult)
        
        let initialExpectation = XCTestExpectation(description: "Initial load")
        sut.videos.observe { videos in
            if videos.count == 3 {
                initialExpectation.fulfill()
            }
        }
        sut.viewDidLoad()
        wait(for: [initialExpectation], timeout: 2.0)
        
        // When - try to load more
        sut.loadMore()
        
        // Then - should not make another call
        let callCountAfterLoadMore = mockFetchVideosUseCase.executeCallCount
        XCTAssertEqual(callCountAfterLoadMore, 1, "Should not fetch more when hasMorePages is false")
    }
    
    // MARK: - Helper Methods
    
    private func createMockVideos(count: Int, startId: Int = 1) -> [VideoPost] {
        return (0..<count).map { index in
            createVideoPost(
                id: startId + index,
                userName: "User\(startId + index)"
            )
        }
    }
    
    private func createVideoPost(id: Int, userName: String) -> VideoPost {
        return VideoPost(
            id: id,
            duration: 60,
            userName: userName,
            videoURL: "https://example.com/video\(id).mp4",
            thumbnailURL: "https://example.com/thumb\(id).jpg"
        )
    }
}

// MARK: - Mock FetchVideosUseCase

class MockFetchVideosUseCase: FetchVideosUseCase {
    var result: Result<VideoFeedResult, Error>?
    var executeCallCount = 0
    var lastRequestValue: FetchVideosUseCaseRequestValue?
    
    func execute(
        requestValue: FetchVideosUseCaseRequestValue,
        completion: @escaping (Result<VideoFeedResult, Error>) -> Void
    ) {
        executeCallCount += 1
        lastRequestValue = requestValue
        
        // Simulate async behavior
        DispatchQueue.main.async { [weak self] in
            if let result = self?.result {
                completion(result)
            }
        }
    }
}

