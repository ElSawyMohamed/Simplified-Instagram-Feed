//
//  CGSize+ScaledSize.swift
//  CodeBase
//
//  Created by MohamedSawy on 4/7/24.
//

import Foundation
import UIKit

extension CGSize {
    var scaledSize: CGSize {
        .init(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
}
