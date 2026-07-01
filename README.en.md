[English](./README.en.md) | [繁體中文](./README.md)

# 📚 [WWFlipWordCardUI](https://swiftpackageindex.com/William-Weng)

![SwiftUI](https://img.shields.io/badge/SwiftUI-524520?logo=swift)
[![Swift-5.10](https://img.shields.io/badge/Swift-5.10-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![iOS-17.0](https://img.shields.io/badge/iOS-17.0-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWFlipWordCardUI)
[![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

WWFlipWordCardUI is a SwiftUI-based word card component for building vocabulary flashcards with a flip interaction.

It is designed for language learning apps, educational tools, and any interface that needs a clean and customizable card presentation.

## ✨ Features

- SwiftUI native view.
- Flip-style word card interaction.
- Customizable colors by level and category.
- Customizable fonts for word, reading, and Chinese text.
- Supports an index binding for controlling the current card.
- Callback when the card changes.

## 🚀 Installation

### Swift Package Manager

Add `WWFlipWordCardUI` to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/William-Weng/WWFlipWordCardUI.git", from: "1.0.0")
]
```

## 💡 Usage

Import the module and create a `Configure` instance to customize colors and fonts.

```swift
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
```

## 🧩 API Overview

### `Configure`

Use `Configure` to customize the appearance of the card.

- `levelColors`: color mapping for CEFR levels or other level tags.
- `categoryColors`: color mapping for part-of-speech categories.
- `wordFont`: font for the main word.
- `readingFont`: font for phonetic reading.
- `chineseFont`: font for Chinese translation.

### `WordCard`

Represents a single vocabulary card item.

Typical fields include:

- `id`
- `word`
- `reading`
- `categories`
- `chinese`
- `level`

### `WWFlipWordCardUI`

The main SwiftUI view that renders the flip card UI.

Parameters:

- `words`: the card data source.
- `isAscending`: controls the ordering behavior.
- `currentIndex`: binding for the current displayed card index.
- `configure`: style configuration.
- `trailing closure`: callback when the card changes.
