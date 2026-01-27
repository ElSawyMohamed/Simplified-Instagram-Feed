//
//  DataTransferError+ConnectionError.swift
//  CodeBase
//
//  Created by MohamedSawy on 4/7/24.
//

import Foundation

extension DataTransferError: ConnectionError {
    var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
}
