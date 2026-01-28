//
//  UINavigationController+Extension.swift
//  Glamera Business
//
//  Created by Abdulhamid on 7/4/23.
//  Copyright © 2023 Smart Zone. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    public func pushViewControllers(_ inViewControllers: [UIViewController], animated: Bool) {
        var stack = self.viewControllers
        stack.append(contentsOf: inViewControllers)
        self.setViewControllers(stack, animated: animated)
    }
    
    func popToViewController(ofKind kind: AnyClass, animated: Bool) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: kind) }) {
            popToViewController(viewController, animated: animated)
        }
    }
}
