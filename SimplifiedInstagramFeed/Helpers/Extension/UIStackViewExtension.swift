//
//  UIStackViewExtension.swift
//
//  Created by Hamada Ragab on 14/05/2024.
//

import Foundation
import UIKit

extension UIStackView {
    var stackViewHeight: CGFloat {
        var totalHeight: CGFloat = 0
        for view in arrangedSubviews {
            totalHeight += view.frame.height
        }
        let spacing = spacing * CGFloat(max(0, arrangedSubviews.count - 1))
        totalHeight += spacing
        return totalHeight
    }
}
