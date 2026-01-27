//
//  Double+Extension.swift
//  Glamera Business
//
//  Created by Abdulhamid on 9/16/23.
//  Copyright © 2023 Smart Zone. All rights reserved.
//

import Foundation

extension Double{
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * (percentageVal / 100.0)
        return val
    }
    
    func roundedToTwoDecimalPlaces() -> Double {
        return (self * 100).rounded() / 100
    }
    
    func roundedDouble() -> Double {
        let divisor = pow(10.0, Double(2))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    var toString: String {
        return String(self)
    }
}
