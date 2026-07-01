//
//  Configure.swift
//  WWFlipWordCardUI
//
//  Created by William.Weng on 2026/7/1.
//

import SwiftUI

extension WWFlipWordCardUI {
    
    /// 文字相關設定
    public struct Configure {
        
        let levelColors: [String: Color]
        let categoryColors: [String: Color]
        
        let wordFont: Font
        let readingFont: Font
        let chineseFont: Font
        
        /// 初始化
        /// - Parameters:
        ///   - levelColors: 對應不同 level 的顏色設定
        ///   - categoryColors: 對應不同 category 的顏色設定
        ///   - wordFont: 單字本身的字體
        ///   - readingFont: 音標 / 語音標記的字體
        ///   - chineseFont: 中文翻譯的字體
        public init(levelColors: [String : Color], categoryColors: [String : Color], wordFont: Font, readingFont: Font, chineseFont: Font) {
            
            self.levelColors = levelColors
            self.categoryColors = categoryColors
            self.wordFont = wordFont
            self.readingFont = readingFont
            self.chineseFont = chineseFont
        }
    }
}
