//
//  WWDCYearInfoCollectionViewCellContentDelegate.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 27/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal protocol WWDCYearInfoCollectionViewCellContentDelegate: class {
    func update(for batchInfo: WWDCYear)
}
