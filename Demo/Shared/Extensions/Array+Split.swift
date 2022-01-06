//
// Created by Shaban Kamel on 27/12/2021.
// Copyright (c) 2021 Jean-Marc Boullianne. All rights reserved.
//

import Foundation

public extension Array {
    func split() -> [[Element]] {
        guard !isEmpty else {
            return []
        }
        guard count > 1 else {
            return [self]
        }
        let ct = count
        let half = ct / 2
        let leftSplit = self[0..<half]
        let rightSplit = self[half..<ct]
        return [Array(leftSplit), Array(rightSplit)]
    }
}