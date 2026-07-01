[English](./README.en.md) | [繁體中文](./README.md)

# 📚 [WWFlipWordCardUI](https://swiftpackageindex.com/William-Weng)

![SwiftUI](https://img.shields.io/badge/SwiftUI-524520?logo=swift)
[![Swift-5.10](https://img.shields.io/badge/Swift-5.10-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![iOS-17.0](https://img.shields.io/badge/iOS-17.0-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWFlipWordCardUI)
[![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

一個基於 SwiftUI 的單字卡元件，支援翻頁式卡片互動，適合用於單字學習、語言學習與教育類 App。

這個元件的設計目標是：讓你可以快速建立乾淨、可自訂、容易整合的單字卡 UI。

https://github.com/user-attachments/assets/567425de-0bb0-4e28-9d6f-14fa68f040e4

## ✨ 功能特色

- SwiftUI 原生元件。
- 翻頁式單字卡互動效果。
- 可依照 level 自訂顏色。
- 可依照詞性 / 類別自訂顏色。
- 可自訂單字、音標、中文的字體。
- 支援 `currentIndex` 綁定，方便外部控制目前卡片。
- 支援卡片切換回呼。

## 🚀 安裝方式

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/William-Weng/WWFlipWordCardUI.git", from: "1.0.0")
]
```

## 💡 使用方式

先 import 套件，並建立 `Configure` 來設定顏色與字體。

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

## 🧩 API 說明

### `Configure`

`Configure` 用來設定單字卡的外觀。

- `levelColors`：依照 level 對應顏色。
- `categoryColors`：依照詞性或類別對應顏色。
- `wordFont`：單字字體。
- `readingFont`：音標 / 讀音字體。
- `chineseFont`：中文翻譯字體。

### `WordCard`

代表一筆單字資料。

常見欄位如下：

- `id`
- `word`
- `reading`
- `categories`
- `chinese`
- `level`

### `WWFlipWordCardUI`

主要的 SwiftUI 單字卡元件。

參數說明：

- `words`：單字資料陣列。
- `isAscending`：控制卡片排序方式。
- `currentIndex`：目前卡片索引的綁定值。
- `configure`：外觀設定。
- `closure`：卡片切換時的回呼。

