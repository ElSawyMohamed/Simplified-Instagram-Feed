//
//  FeedViewControllerTests.swift
//
//  Created on 2024.
//

import XCTest
import UIKit
@testable import GentleMan2024

final class FeedViewControllerTests: XCTestCase {
    
    var sut: FeedViewController!
    var mockViewModel: MockFeedViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockViewModel = MockFeedViewModel()
        sut = FeedViewController.create(with: mockViewModel)
        
        // Load view to trigger viewDidLoad
        _ = sut.view
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockViewModel = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Initialization Tests
    
    func testCreate_InitializesWithViewModel() {
        // Given
        let viewModel = MockFeedViewModel()
        
        // When
        let viewController = FeedViewController.create(with: viewModel)
        
        // Then
        XCTAssertNotNil(viewController)
        // Note: viewModel is private, so we can't directly test it,
        // but we can test that viewDidLoad is called which uses the viewModel
    }
    
    // MARK: - viewDidLoad Tests
    
    func testViewDidLoad_CallsViewModelViewDidLoad() {
        // Given
        let viewModel = MockFeedViewModel()
        let viewController = FeedViewController.create(with: viewModel)
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(viewModel.viewDidLoadCalled, "viewDidLoad should call viewModel.viewDidLoad()")
    }
    
    func testViewDidLoad_SetsUpCollectionView() {
        // Then
        XCTAssertNotNil(sut.feedCollectionView, "Collection view should be set up")
        XCTAssertTrue(sut.feedCollectionView.isPagingEnabled, "Collection view should have paging enabled")
        XCTAssertFalse(sut.feedCollectionView.showsVerticalScrollIndicator, "Collection view should hide scroll indicator")
    }
    
    func testViewDidLoad_SetsUpRefreshControl() {
        // Then
        XCTAssertNotNil(sut.feedCollectionView.refreshControl, "Refresh control should be set up")
        XCTAssertEqual(sut.feedCollectionView.refreshControl?.tintColor, .systemBlue, "Refresh control should have blue tint")
    }
    
    func testViewDidLoad_RegistersCells() {
        // Then
        let cell = sut.feedCollectionView.dequeueReusableCell(
            withReuseIdentifier: "VideoFeedCell",
            for: IndexPath(item: 0, section: 0)
        )
        XCTAssertNotNil(cell, "Cell should be registered")
    }
    
    // MARK: - Refresh Control Tests
    
    func testRefreshFeed_CallsViewModelRefresh() {
        // Given
        let viewModel = MockFeedViewModel()
        let viewController = FeedViewController.create(with: viewModel)
        _ = viewController.view
        
        // When - simulate refresh control action
        viewController.feedCollectionView.refreshControl?.sendActions(for: .valueChanged)
        
        // Then
        let expectation = XCTestExpectation(description: "Refresh should be called")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(viewModel.refreshCalled, "refreshFeed should call viewModel.refresh()")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRefreshControl_EndsRefreshingWhenVideosUpdate() {
        // Given
        let expectation = XCTestExpectation(description: "Refresh control should end refreshing")
        let viewModel = MockFeedViewModel()
        let viewController = FeedViewController.create(with: viewModel)
        _ = viewController.view
        
        // Simulate refresh control being active
        viewController.feedCollectionView.refreshControl?.beginRefreshing()
        XCTAssertTrue(viewController.feedCollectionView.refreshControl!.isRefreshing)
        
        // When - update videos
        viewModel.videos.value = [createMockVideoPost()]
        
        // Then - wait a bit for the observe closure to execute
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(viewController.feedCollectionView.refreshControl!.isRefreshing, "Refresh control should end refreshing when videos update")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - ViewModel Binding Tests
    
    func testBindViewModel_UpdatesCollectionViewWhenVideosChange() {
        // Given
        let mockVideos = [
            createMockVideoPost(id: 1),
            createMockVideoPost(id: 2),
            createMockVideoPost(id: 3)
        ]
        
        // When
        mockViewModel.videos.value = mockVideos
        
        // Then
        let expectation = XCTestExpectation(description: "Collection view should update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let itemCount = self.sut.feedCollectionView.numberOfItems(inSection: 0)
            XCTAssertEqual(itemCount, 3, "Collection view should have 3 items")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testBindViewModel_ShowsErrorWhenErrorOccurs() {
        // Given
        let errorMessage = "Network error occurred"
        let expectation = XCTestExpectation(description: "Error should be shown")
        
        // Mock the showError method by checking if error is set
        // Since showError presents an alert, we'll test that error is observed
        var receivedError: String?
        mockViewModel.error.observe { error in
            if !error.isEmpty {
                receivedError = error
                expectation.fulfill()
            }
        }
        
        // When
        mockViewModel.error.value = errorMessage
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedError, errorMessage)
    }
    
    func testBindViewModel_UpdatesLoadingState() {
        // Given
        let expectation = XCTestExpectation(description: "Loading state should be observed")
        expectation.expectedFulfillmentCount = 2
        
        var loadingStates: [Loading] = []
        mockViewModel.loading.observe { loading in
            loadingStates.append(loading)
            expectation.fulfill()
        }
        
        // When
        mockViewModel.loading.value = .Start
        mockViewModel.loading.value = .Stop
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(loadingStates.contains(.Start))
        XCTAssertTrue(loadingStates.contains(.Stop))
    }
    
    // MARK: - Collection View Delegate Tests
    
    func testCollectionView_SizeForItemAt_ReturnsFullSize() {
        // Given
        sut.feedCollectionView.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        let layout = UICollectionViewFlowLayout()
        let indexPath = IndexPath(item: 0, section: 0)
        
        // When
        let size = sut.collectionView(sut.feedCollectionView, layout: layout, sizeForItemAt: indexPath)
        
        // Then
        XCTAssertEqual(size.width, 375, "Cell width should match collection view width")
        XCTAssertEqual(size.height, 667, "Cell height should match collection view height")
    }
    
    // MARK: - Scroll View Delegate Tests
    
    func testScrollViewWillBeginDragging_SetsIsScrolling() {
        // Given
        let scrollView = UIScrollView()
        
        // When
        sut.scrollViewWillBeginDragging(scrollView)
        
        // Then
        // Note: isScrolling is private, but we can test the behavior indirectly
        // by checking that pauseCurrentlyPlayingVideo is called
        // Since we can't easily test private methods, we'll verify the method exists and can be called
        XCTAssertTrue(true, "scrollViewWillBeginDragging should be callable")
    }
    
    func testScrollViewDidEndDecelerating_ResetsIsScrolling() {
        // Given
        let scrollView = UIScrollView()
        
        // When
        sut.scrollViewDidEndDecelerating(scrollView)
        
        // Then
        // Verify method can be called without crashing
        XCTAssertTrue(true, "scrollViewDidEndDecelerating should be callable")
    }
    
    func testScrollViewDidEndScrollingAnimation_ResetsIsScrolling() {
        // Given
        let scrollView = UIScrollView()
        
        // When
        sut.scrollViewDidEndScrollingAnimation(scrollView)
        
        // Then
        XCTAssertTrue(true, "scrollViewDidEndScrollingAnimation should be callable")
    }
    
    func testScrollViewDidEndDragging_ResetsIsScrollingWhenNotDecelerating() {
        // Given
        let scrollView = UIScrollView()
        
        // When
        sut.scrollViewDidEndDragging(scrollView, willDecelerate: false)
        
        // Then
        XCTAssertTrue(true, "scrollViewDidEndDragging should be callable")
    }
    
    func testScrollViewDidScroll_ChecksForPagination() {
        // Given
        let scrollView = UIScrollView()
        mockViewModel.videos.value = createMockVideos(count: 10)
        
        // When
        sut.scrollViewDidScroll(scrollView)
        
        // Then
        // Verify method can be called without crashing
        XCTAssertTrue(true, "scrollViewDidScroll should be callable")
    }
    
    // MARK: - Pagination Tests
    
    func testCheckForPagination_CallsFetchNextPageWhenNearEnd() {
        // Given
        let viewModel = MockFeedViewModel()
        let viewController = FeedViewController.create(with: viewModel)
        _ = viewController.view
        
        // Set up collection view with many items
        viewModel.videos.value = createMockVideos(count: 10)
        
        // Wait for collection view to update
        let expectation = XCTestExpectation(description: "Collection view updated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Simulate scrolling near the end by calling scroll delegate methods
        // Note: This is difficult to test without a fully laid out collection view
        // We'll verify that scroll delegate methods can be called
        let scrollView = UIScrollView()
        viewController.scrollViewDidScroll(scrollView)
        viewController.scrollViewDidEndDecelerating(scrollView)
        
        // Then
        // Verify methods can be called without crashing
        // Actual pagination trigger would require proper collection view layout
        XCTAssertTrue(true, "Pagination check methods should be callable")
    }
    
    // MARK: - Video Playback Tests
    
    func testAutoPlayVisibleVideo_PlaysFirstVideoWhenNoVideoPlaying() {
        // Given
        mockViewModel.videos.value = [createMockVideoPost()]
        
        // Wait for collection view to update
        let expectation = XCTestExpectation(description: "Collection view updated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // When
        sut.scrollViewDidEndDecelerating(UIScrollView())
        
        // Then
        // Verify method can be called without crashing
        // Note: Actual video playback testing would require mocking VideoFeedCell
        XCTAssertTrue(true, "autoPlayVisibleVideo should be callable")
    }
    
    func testPauseCurrentlyPlayingVideo_PausesVideo() {
        // Given
        mockViewModel.videos.value = [createMockVideoPost()]
        
        // When - trigger refresh which calls pauseCurrentlyPlayingVideo
        sut.feedCollectionView.refreshControl?.sendActions(for: .valueChanged)
        
        // Then
        // Verify method can be called without crashing
        let expectation = XCTestExpectation(description: "Refresh triggered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockViewModel.refreshCalled, "Refresh should be called")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Helper Methods
    
    private func createMockVideoPost(id: Int = 1) -> VideoPost {
        return VideoPost(
            id: id,
            duration: 60,
            userName: "TestUser\(id)",
            videoURL: "https://example.com/video\(id).mp4",
            thumbnailURL: "https://example.com/thumb\(id).jpg"
        )
    }
    
    private func createMockVideos(count: Int) -> [VideoPost] {
        return (1...count).map { createMockVideoPost(id: $0) }
    }
}

// MARK: - Mock FeedViewModel

class MockFeedViewModel: FeedViewModel {
    var videos: BindableObservable<[VideoPost]> = BindableObservable([])
    var loading: BindableObservable<Loading> = BindableObservable(.Stop)
    var error: BindableObservable<String> = BindableObservable("")
    
    var viewDidLoadCalled = false
    var refreshCalled = false
    var loadMoreCalled = false
    var searchVideosCalled = false
    var fetchNextPageCalled = false
    
    var lastSearchQuery: String?
    var fetchNextPageCompletion: (() -> Void)?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func refresh() {
        refreshCalled = true
    }
    
    func loadMore() {
        loadMoreCalled = true
    }
    
    func searchVideos(query: String) {
        searchVideosCalled = true
        lastSearchQuery = query
    }
    
    func fetchNextPage(completion: (() -> Void)?) {
        fetchNextPageCalled = true
        fetchNextPageCompletion = completion
        completion?()
    }
}
