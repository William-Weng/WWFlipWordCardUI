//
//  WordCard.swift
//  WWFlipWordCardUI
//
//  Created by William.Weng on 2026/7/1.
//

import Foundation

extension WWFlipWordCardUI {
    
    /// 共用的單字模型 => 用來統一畫面輸出
    public struct WordCard: Identifiable {
        
        public let id: Int
        public let word: String
        public let reading: String
        public let categories: [String]
        public let chinese: String
        public let level: String
        
        /// 初始化
        /// - Parameters:
        ///   - id: 流水號
        ///   - word: 單字
        ///   - reading: 發音
        ///   - categories: 單字詞性
        ///   - chinese: 中文翻譯
        ///   - level: 單字等級
        public init(id: Int, word: String, reading: String, categories: [String], chinese: String, level: String) {
            
            self.id = id
            self.word = word
            self.reading = reading
            self.categories = categories
            self.chinese = chinese
            self.level = level
        }
    }
}
