//
//  UIViewController+Extension.swift
//  Glamera Business
//
//  Created by Sterling on 10/02/2021.
//

import UIKit
import ViewAnimator

extension UIViewController {
    
    public static var storyboardIdentifier: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
    
    func animateViews(viewsArray: [UIView], animate: AnimationType, delay: Double, duration: TimeInterval) {
        for view in viewsArray {
            view.animate(animations: [animate], delay: delay, duration: duration)
        }
    }
}

enum PresentationStyle {
    case present
    case push
    case changeRoot
}

protocol Route {
    var distenationViewController: UIViewController { get }
    var presentationStyle: PresentationStyle { get }
}

extension UIViewController {
    func navigateTo(route: Route) {
        switch route.presentationStyle {
        case .present:
            self.present(route.distenationViewController, animated: true, completion: nil)
        case .push:
            self.navigationController?.pushViewController(route.distenationViewController, animated: true)
        case .changeRoot:
            self.view.window?.rootViewController = route.distenationViewController
        }
    }
    
    func popToViewController(viewController: UIViewController.Type){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: viewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    class func loadFromNib<T: UIViewController>() -> T {
        return T(nibName: String(describing: self), bundle: nil)
    }
    
}
