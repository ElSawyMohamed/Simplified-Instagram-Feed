//
//  FeedViewController.swift
//
//  Created by MohamedSawy on 1/28/26.
//

import UIKit
import RxSwift
import RxCocoa

class FeedViewController: BaseViewController {

    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    private var viewModel: FeedViewModel!
    
    private let videoFeedCellIdentifier = "VideoFeedCell"
    private var currentlyPlayingIndexPath: IndexPath?
    private var isScrolling = false
    private var isLoadingMore = false
    private var refreshControl: UIRefreshControl!

    static func create(
        with viewModel: FeedViewModel
    ) -> FeedViewController {
        let view: FeedViewController = FeedViewController.loadFromNib()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupRefreshControl()
        registerCells()
        viewModel.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView() {
        feedCollectionView.isPagingEnabled = true
        feedCollectionView.showsVerticalScrollIndicator = false
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        feedCollectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshFeed() {
        pauseCurrentlyPlayingVideo()
        viewModel.refresh()
    }

    private func bindViewModel() {
        viewModel.loading.observe { [weak self] in self?.updateLoading($0) }
        
        viewModel.videos.observe { [weak self] _ in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }
        
        
        viewModel.videos.bind(to: feedCollectionView,
                              cellIdentifier: videoFeedCellIdentifier,
                              delegate: self) { (index, video, cell: VideoFeedCell) in
            cell.configure(with: video)

            if self.currentlyPlayingIndexPath == nil, index == 0 {
                DispatchQueue.main.async {
                    cell.playVideo()
                    self.currentlyPlayingIndexPath = IndexPath(item: 0, section: 0)
                }
            }
        }
        
        viewModel.error.observe { [weak self] errorMessage in
            guard let self = self, !errorMessage.isEmpty else { return }
            self.showError(errorMessage)
        }
    }
    
    private func registerCells() {
        feedCollectionView.register(VideoFeedCell.self, forCellWithReuseIdentifier: videoFeedCellIdentifier)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

// MARK: - UICollectionViewDelegate
extension FeedViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
        pauseCurrentlyPlayingVideo()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
        autoPlayVisibleVideo()
        checkForPagination()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrolling = false
        autoPlayVisibleVideo()
        checkForPagination()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrolling = false
            autoPlayVisibleVideo()
            checkForPagination()
        }
    }
    
    // Optional: Pause videos that go off-screen while scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Pause videos that are no longer visible
        guard let currentIndexPath = currentlyPlayingIndexPath else { return }
        if !feedCollectionView.indexPathsForVisibleItems.contains(currentIndexPath),
           let cell = feedCollectionView.cellForItem(at: currentIndexPath) as? VideoFeedCell {
            cell.pauseVideo()
            currentlyPlayingIndexPath = nil
        }
        checkForPagination()
    }
    
    // MARK: - Helper Methods
    private func autoPlayVisibleVideo() {
        guard !isScrolling else { return }
        
        // Find the most visible cell
        guard let mostVisibleIndexPath = getMostVisibleIndexPath() else { return }
        
        // Pause previous
        if let currentIndexPath = currentlyPlayingIndexPath,
           currentIndexPath != mostVisibleIndexPath,
           let currentCell = feedCollectionView.cellForItem(at: currentIndexPath) as? VideoFeedCell {
            currentCell.pauseVideo()
        }
        
        // Play new
        if let cell = feedCollectionView.cellForItem(at: mostVisibleIndexPath) as? VideoFeedCell {
            cell.playVideo()
            currentlyPlayingIndexPath = mostVisibleIndexPath
        }
    }
    
    private func pauseCurrentlyPlayingVideo() {
        if let indexPath = currentlyPlayingIndexPath,
           let cell = feedCollectionView.cellForItem(at: indexPath) as? VideoFeedCell {
            cell.pauseVideo()
        }
        currentlyPlayingIndexPath = nil
    }
    
    private func checkForPagination() {
        let videos = viewModel.videos.value
        guard !videos.isEmpty, !isLoadingMore else { return }
        
        let visibleIndexPaths = feedCollectionView.indexPathsForVisibleItems
        guard let lastVisibleIndexPath = visibleIndexPaths.max(by: { $0.item < $1.item }) else { return }
        
        // Load more when user is within last 3 items
        let threshold = max(0, videos.count - 3)
        if lastVisibleIndexPath.item >= threshold {
            isLoadingMore = true
            viewModel.fetchNextPage { [weak self] in
                self?.isLoadingMore = false
            }
        }
    }
}

extension FeedViewController {
    // MARK: - Video Playback Management
    private func playVideoForMostVisibleCell() {
        guard !isScrolling, let mostVisibleIndexPath = getMostVisibleIndexPath() else { return }
        
        // Pause currently playing video if different
        if let currentIndexPath = currentlyPlayingIndexPath, currentIndexPath != mostVisibleIndexPath {
            if let cell = feedCollectionView.cellForItem(at: currentIndexPath) as? VideoFeedCell {
                cell.pauseVideo()
            }
        }
        
        // Play new video
        if let cell = feedCollectionView.cellForItem(at: mostVisibleIndexPath) as? VideoFeedCell {
            cell.playVideo()
            currentlyPlayingIndexPath = mostVisibleIndexPath
        }
    }
    
    private func getMostVisibleIndexPath() -> IndexPath? {
        let visibleIndexPaths = feedCollectionView.indexPathsForVisibleItems
        guard !visibleIndexPaths.isEmpty else { return nil }
        
        var mostVisibleIndexPath: IndexPath?
        var maxVisibleArea: CGFloat = 0
        
        for indexPath in visibleIndexPaths {
            if feedCollectionView.cellForItem(at: indexPath) != nil,
               let attributes = feedCollectionView.layoutAttributesForItem(at: indexPath) {
                let cellFrame = attributes.frame
                let visibleFrame = feedCollectionView.bounds.intersection(cellFrame)
                let visibleArea = visibleFrame.width * visibleFrame.height
                
                if visibleArea > maxVisibleArea {
                    maxVisibleArea = visibleArea
                    mostVisibleIndexPath = indexPath
                }
            }
        }
        
        return mostVisibleIndexPath
    }
    
    // MARK: - Helpers
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
