
import SwiftUI

public struct WWFlipWordCardUI: View {
    
    private let words: [WordCard]
    private let isAscending: Bool
    private let configure: Configure
    
    private let onDragEnded: ((_ direction: CardAwayDirection, _ index: Int) -> Void)?
    
    @Binding private var currentIndex: Int              // 目前顯示綁定的單字索引
    
    @State private var dragOffset: CGFloat = 0          // 拖曳偏移量 => 用來做滑動切頁動畫
    @State private var isAnimatingPage = false          // 是否正在執行翻頁動畫
    @State private var isFlipped = false                // 目前卡片是否翻面
    @State private var selectedName = ""                // 選到的資料表名稱
    @State private var isAutoReading = false            // 翻頁自動跟讀單字
    
    public var body: some View {
        cardStack
    }
    
    /// 初始化
    /// - Parameters:
    ///   - words: 單字資料來源
    ///   - isAscending: 文字 / 音標排列順序
    ///   - currentIndex: 目前顯示綁定的單字索引
    ///   - configure: 文字相關設定
    ///   - onDragEnded: 翻頁完成後的通知
    public init(words: [WordCard], isAscending: Bool, currentIndex: Binding<Int>, configure: Configure, onDragEnded: ((_ direction: CardAwayDirection, _ index: Int) -> Void)? = nil) {
        self.words = words
        self.isAscending = isAscending
        self.configure = configure
        self.onDragEnded = onDragEnded
        _currentIndex = currentIndex
    }
}

// MARK: - 私有屬性
private extension WWFlipWordCardUI {
    
    /// 三層卡片堆疊
    var cardStack: some View {
        
        ZStack {
            
            /// 最後方卡片
            if let farBackWord {
                WordCardView(wordCard: farBackWord, isFlipped: false, isAscending: isAscending, configure: configure)
                    .offset(x: farBackOffsetX, y: farBackOffsetY)
                    .scaleEffect(farBackScale)
                    .rotationEffect(.degrees(farBackRotation))
                    .opacity(farBackOpacity)
                    .animation(.interactiveSpring(response: 0.28, dampingFraction: 0.9), value: currentIndex)
                    .animation(.interactiveSpring(response: 0.28, dampingFraction: 0.9), value: dragOffset)
                    .zIndex(0)
            }
            
            /// 中間卡片
            if let backWord {
                WordCardView(wordCard: backWord, isFlipped: false, isAscending: isAscending, configure: configure)
                    .offset(x: backOffsetX, y: backOffsetY)
                    .scaleEffect(backScale)
                    .rotationEffect(.degrees(backRotation))
                    .opacity(backOpacity)
                    .animation(.interactiveSpring(response: 0.28, dampingFraction: 0.9), value: currentIndex)
                    .animation(.interactiveSpring(response: 0.28, dampingFraction: 0.9), value: dragOffset)
                    .zIndex(1)
            }
            
            /// 前景卡片
            if let currentWord {
                WordCardView(wordCard: currentWord, isFlipped: isFlipped, isAscending: isAscending, configure: configure)
                    .offset(x: dragOffset, y: frontLift)
                    .scaleEffect(frontScale)
                    .rotationEffect(.degrees(frontRotation))
                    .shadow(color: .black.opacity(frontShadowOpacity), radius: 18, x: frontShadowX, y: 8)
                    .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .highPriorityGesture(deckDragGesture)
                    .onTapGesture { flipCard() }
                    .zIndex(2)
            }
        }
    }
}

// MARK: - 私有屬性
private extension WWFlipWordCardUI {
    
    /// 目前正在顯示的單字
    ///
    /// 使用 `currentIndex` 搭配 `[safe:]` 取值，避免索引超出範圍時發生 crash
    var currentWord: WordCard? {
        words[safe: currentIndex]
    }
    
    /// 前一層預覽卡片要顯示的單字
    ///
    /// 依照拖曳方向決定要取上一筆或下一筆，讓卡片堆疊在滑動時能自然更新，同樣使用 `[safe:]` 保護索引，避免資料不足時越界
    var backWord: WordCard? {
        words[safe: loopIndex(currentIndex + (dragOffset < 0 ? -1 : 1))]
    }
    
    /// 最後一層預覽卡片要顯示的單字
    ///
    /// 依照拖曳方向再往外推一筆，作為三層卡片堆疊中的最底層預覽，透過 `[safe:]` 讓這層卡片也能在資料變動時維持安全
    var farBackWord: WordCard? {
        words[safe: loopIndex(currentIndex + (dragOffset < 0 ? -2 : 2))]
    }
}

// MARK: - 私有屬性
private extension WWFlipWordCardUI {
            
    /// 上一張索引 => 會依照目前索引往前一筆，並支援循環
    var previousIndex: Int {
        loopIndex(currentIndex - 1)
    }
    
    /// 下一張索引 => 會依照目前索引往後一筆，並支援循環
    var nextIndex: Int {
        loopIndex(currentIndex + 1)
    }
    
    /// 拖曳進度值，範圍為 0 到 1 => 用來控制後方卡片的位移、縮放與旋轉動畫
    var dragProgress: CGFloat {
        let width = max(UIScreen.main.bounds.width, 1)
        return min(max(abs(dragOffset) / width, 0), 1)
    }
    
    /// 是否正在往下一張滑動
    var swipingNext: Bool {
        dragOffset < 0
    }
    
    /// 前景卡片的浮動高度
    var frontLift: CGFloat {
        -min(abs(dragOffset) * 0.035, 10)
    }
    
    /// 前景卡片的縮放比例
    var frontScale: CGFloat {
        1 - min(abs(dragOffset) / 2400, 0.02)
    }
    
    /// 前景卡片的旋轉角度
    var frontRotation: Double {
        Double(dragOffset / 42)
    }
    
    /// 前景卡片陰影透明度
    var frontShadowOpacity: Double {
        0.08 + Double(min(abs(dragOffset) / 700, 0.08))
    }
    
    /// 前景卡片陰影水平偏移
    var frontShadowX: CGFloat {
        dragOffset / 20
    }
    
    /// 中間後方卡片的 X 偏移
    var backOffsetX: CGFloat {
        let pull: CGFloat = 14
        return swipingNext ? 10 - pull * dragProgress : 10 + pull * dragProgress
    }
    
    /// 中間後方卡片的 Y 偏移
    var backOffsetY: CGFloat {
        14 - (12 * dragProgress)
    }
    
    /// 中間後方卡片的縮放比例
    var backScale: CGFloat {
        0.94 + 0.045 * dragProgress
    }
    
    /// 中間後方卡片的旋轉角度
    var backRotation: Double {
        swipingNext ? 0.55 - Double(0.55 * dragProgress) : -0.55 + Double(0.55 * dragProgress)
    }
    
    /// 中間後方卡片的透明度
    var backOpacity: Double {
        0.92 + 0.06 * Double(dragProgress)
    }
    
    /// 最後方卡片的 X 偏移
    var farBackOffsetX: CGFloat {
        swipingNext ? 20 - 6 * dragProgress : 20 + 6 * dragProgress
    }
    
    /// 最後方卡片的 Y 偏移
    var farBackOffsetY: CGFloat {
        28 - 6 * dragProgress
    }
    
    /// 最後方卡片的縮放比例
    var farBackScale: CGFloat {
        0.88 + 0.02 * dragProgress
    }
    
    /// 最後方卡片的旋轉角度
    var farBackRotation: Double {
        swipingNext ? 0.28 - Double(0.18 * dragProgress) : -0.28 + Double(0.18 * dragProgress)
    }
    
    /// 最後方卡片的透明度
    var farBackOpacity: Double {
        0.68 + 0.10 * Double(dragProgress)
    }
}

// MARK: - 私有拖曳手勢
private extension WWFlipWordCardUI {
    
    /// 拖曳手勢 => 左滑切下一張，右滑切上一張
    var deckDragGesture: some Gesture {
        
        DragGesture(minimumDistance: 8, coordinateSpace: .local)
            .onChanged { handleDeckDragChanged($0) }
            .onEnded { try? handleDeckDragEnded($0) }
    }
}

// MARK: - 小工具
private extension WWFlipWordCardUI {
        
    /// 卡片滑出動畫
    /// - Parameters:
    ///   - direction: CardAwayDirection
    ///   - update: 動畫結束後要執行的索引更新
    func animateCardAway(direction: CardAwayDirection, update: @escaping () -> Void) throws {
        
        isAnimatingPage = true
        
        let width = UIScreen.main.bounds.width
        let target = direction.rawValue * width * 0.95
        
        withAnimation(.easeOut(duration: 0.13)) { dragOffset = target }
        
        Task { @MainActor in
            
            try await Task.sleep(for: .milliseconds(110))
            
            update()
            isFlipped = false
            dragOffset = -direction.rawValue * 12
            
            withAnimation(.easeOut(duration: 0.09)) { dragOffset = 0 }
            
            try await Task.sleep(for: .milliseconds(100))
            isAnimatingPage = false
        }
    }
    
    /// 將索引限制在單字陣列範圍內，並支援循環
    func loopIndex(_ index: Int) -> Int {
        
        guard !words.isEmpty else { return 0 }
        
        let remainder = index % words.count
        return remainder >= 0 ? remainder : remainder + words.count
    }
        
    /// 翻牌
    func flipCard() {
        guard !isAnimatingPage else { return }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) { isFlipped.toggle() }
    }
    
    /// 將目前索引限制在有效範圍內
    ///
    /// 當單字陣列是空的時，直接把 `currentIndex` 設為 0，如果索引超出陣列範圍，則修正到最後一筆或第一筆，避免發生越界
    func clampCurrentIndex() {
        
        guard !words.isEmpty else { currentIndex = 0; return }
        
        if currentIndex >= words.count { currentIndex = words.count - 1 }
        if currentIndex < 0 { currentIndex = 0 }
    }
}

// MARK: - DragGesture
private extension WWFlipWordCardUI {
    
    /// 拖曳中：更新卡片偏移量
    func handleDeckDragChanged(_ value: DragGesture.Value) {
        guard !isAnimatingPage, !isFlipped else { return }
        dragOffset = value.translation.width
    }
    
    /// 拖曳結束：判斷是否要切換上一張或下一張
    func handleDeckDragEnded(_ value: DragGesture.Value) throws {
        
        guard !isAnimatingPage, !isFlipped else { return }
        
        let threshold: CGFloat = 90
        let predicted = value.predictedEndTranslation.width
        
        if predicted < -threshold {
            try animateCardAway(direction: .left) {
                currentIndex = nextIndex
                onDragEnded?(.left, currentIndex)
            }
        } else if predicted > threshold {
            try animateCardAway(direction: .right) {
                currentIndex = previousIndex
                onDragEnded?(.right, currentIndex)
            }
        } else {
            withAnimation(.interactiveSpring(response: 0.34, dampingFraction: 0.9)) {
                dragOffset = 0
            }
        }
    }
}
