//
//  CustomPopAnimator.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 7/9/24.
//

import UIKit

class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, belowSubview: fromView)
        
        let screenWidth = containerView.frame.width
        toView.frame = containerView.frame
        fromView.frame = containerView.frame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.transform = CGAffineTransform(translationX: screenWidth, y: 0)
        }) { finished in
            fromView.transform = .identity
            transitionContext.completeTransition(finished)
        }
    }
}
