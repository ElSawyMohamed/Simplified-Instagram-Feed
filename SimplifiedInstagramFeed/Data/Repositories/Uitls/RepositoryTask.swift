//
//  RepositoryTask.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/16/24.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
