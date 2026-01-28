//
//  VideoFeedCell.swift
//
//  Created on 2024.
//

import UIKit
import AVFoundation
import Kingfisher

class VideoFeedCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Play/Pause Buttons
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶️", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 32)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⏸", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 32)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var videoPost: VideoPost?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopVideo()
        thumbnailImageView.image = nil
        NotificationCenter.default.removeObserver(self)
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = playerView.bounds
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(playerView)
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(durationLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(pauseButton)
        
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            durationLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            durationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            durationLabel.heightAnchor.constraint(equalToConstant: 28),
            
            userNameLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: durationLabel.leadingAnchor, constant: -8),
            userNameLabel.heightAnchor.constraint(equalToConstant: 28),
            
            playButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            
            pauseButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pauseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pauseButton.widthAnchor.constraint(equalToConstant: 50),
            pauseButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        pauseButton.isHidden = true
        
        playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(didTapPause), for: .touchUpInside)
    }
    
    // MARK: - Configuration
    func configure(with videoPost: VideoPost) {
        self.videoPost = videoPost
        
        // Load thumbnail
        if let thumbnailURL = URL(string: videoPost.thumbnailURL) {
            thumbnailImageView.kf.setImage(with: thumbnailURL)
        }
        
        // Duration
        let durationText = formatDuration(videoPost.duration)
        durationLabel.text = "  \(durationText)  "
        
        // User name
        userNameLabel.text = "  @\(videoPost.userName)  "
    }
    
    // MARK: - Video Playback
    func playVideo() {
        guard let videoPost = videoPost,
              let videoURL = URL(string: videoPost.videoURL) else { return }
        
        if player == nil {
            player = AVPlayer(url: videoURL)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerItemDidReachEnd),
                name: .AVPlayerItemDidPlayToEndTime,
                object: player?.currentItem
            )
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = playerView.bounds
            playerLayer?.videoGravity = .resizeAspectFill
            if let layer = playerLayer {
                playerView.layer.addSublayer(layer)
            }
        }
        
        playerLayer?.frame = playerView.bounds
        player?.play()
        thumbnailImageView.isHidden = true
        
        // Buttons
        playButton.isHidden = true
        pauseButton.isHidden = false
    }
    
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let item = notification.object as? AVPlayerItem {
            item.seek(to: .zero) { [weak self] _ in
                self?.player?.play()
            }
        }
    }
    
    func pauseVideo() {
        player?.pause()
        thumbnailImageView.isHidden = false
        
        playButton.isHidden = false
        pauseButton.isHidden = true
    }
    
    func stopVideo() {
        player?.pause()
        player?.seek(to: .zero)
        thumbnailImageView.isHidden = false
        
        playButton.isHidden = false
        pauseButton.isHidden = true
    }
    
    // MARK: - Button Actions
    @objc private func didTapPlay() { playVideo() }
    @objc private func didTapPause() { pauseVideo() }
    
    // MARK: - Helpers
    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
