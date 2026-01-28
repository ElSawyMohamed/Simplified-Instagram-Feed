//
//  UIResponder+Extension.swift
//  Glamera Business
//
//  Created by Sterling on 11/02/2021.
//

import UIKit

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
