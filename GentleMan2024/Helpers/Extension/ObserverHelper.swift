//
//  ObserverHelper.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 7/9/24.
//

import ObjectiveC
import Foundation

public var observerKey: UInt8 = 0

class ObserverHelper {
    var observer: NSObjectProtocol?

    deinit {
        if let observer = observer {
            print("deinit NotificationCenter removeObserver ObserverHelper")
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
