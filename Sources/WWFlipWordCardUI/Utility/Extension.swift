//
//  Extension.swift
//  WWFlipWordCardUI
//
//  Created by William.Weng on 2026/7/1.
//

import Foundation
import SwiftUI


// MARK: - JSONSerialization (subscript function)
extension Collection {
    
    /// 集合安全取值
    /// - Returns: Element?
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
