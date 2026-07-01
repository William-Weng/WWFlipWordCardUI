//
//  ContentView.swift
//  Example
//
//  Created by William.Weng on 2026/7/1.
//

import SwiftUI
import WWFlipWordCardUI

struct ContentView: View {
    
    let config: Configure = .init(
        levelColors: [
            "A2": .black,
            "B1": .purple,
            "B2": .orange
        ],
        categoryColors: [
            "名詞": .blue,
            "形容詞": .green,
            "動詞": .red
        ],
        wordFont: .system(size: 48, weight: .bold, design: .rounded),
        readingFont: .system(size: 28, weight: .medium, design: .monospaced),
        chineseFont: .system(size: 32, weight: .bold, design: .rounded)
    )
    
    @State private var words: [WordCard] = [
        .init(id: 1, word: "ability", reading: "/əbɪləti/", categories: ["名詞"], chinese: "能力、才能", level: "A2"),
        .init(id: 2, word: "apparent", reading: "/əpɛrənt/", categories: ["形容詞"], chinese: "顯然的", level: "B1"),
        .init(id: 3, word: "observe", reading: "/əbzɝv/", categories: ["動詞"], chinese: "注意到、觀察", level: "B2"),
    ]
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        
        ZStack {
            Color.teal.ignoresSafeArea()
            WWFlipWordCardUI(words: words, isAscending: true, currentIndex: $currentIndex, configure: config)
                .frame(width: 320, height: 320)
        }
    }
}

#Preview {
    ContentView()
}

