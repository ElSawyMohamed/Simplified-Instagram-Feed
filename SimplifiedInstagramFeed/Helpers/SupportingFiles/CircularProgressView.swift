//
//  ArrowButton.swift
//
//  Created by MohamedSawy on 6/23/24.
//

import UIKit

class CircularProgressView: UIView {
    
    private let progressLayer = CAShapeLayer()
    private let progressCircleLayer = CAShapeLayer()
    private let lineWidth: CGFloat = 10.0 // Adjust as needed
    
    private var progressPath: UIBezierPath {
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2
        return UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                            radius: radius,
                            startAngle: -CGFloat.pi / 2,
                            endAngle: 1.5 * CGFloat.pi,
                            clockwise: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear // Set background color to clear
        
        // Set up the circular progress layer
        setupProgressLayer()
    }
    
    private func setupProgressLayer() {
        // Background circle layer
        progressCircleLayer.path = progressPath.cgPath
        progressCircleLayer.strokeColor = UIColor.clear.cgColor
        progressCircleLayer.lineWidth = lineWidth
        progressCircleLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(progressCircleLayer)
        
        // Progress layer
        progressLayer.path = progressPath.cgPath
        progressLayer.strokeColor = AppColors.progressColor.cgColor
        progressLayer.lineWidth = 2
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }
    
    func showProgress(_ progress: Float) {
        progressLayer.strokeEnd = CGFloat(progress)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update the path for the progress layers when the layout changes
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2
        progressCircleLayer.path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                                radius: radius,
                                                startAngle: -CGFloat.pi / 2,
                                                endAngle: 1.5 * CGFloat.pi,
                                                clockwise: true).cgPath
        progressLayer.path = progressPath.cgPath
    }
}
