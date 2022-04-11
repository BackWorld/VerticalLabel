//
//  VerticalLabel.swift
//  DemoVerticalText
//
//  Created by zhuxuhong on 2022/4/7.
//

import UIKit

public class VerticalLabel: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setNeedsUpdate()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
        setNeedsUpdate()
    }
    
    lazy var scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.addSubview(textsView)
//        sc.bounces = false
        sc.contentInset = .zero
        sc.contentOffset = .zero
        return sc
    }()
    
    func setupViews() {
        addSubview(scrollView)
    }
    
    @IBInspectable public var containerSize: CGSize = .zero {
        didSet{
            setNeedsUpdate()
        }
    }
    @IBInspectable public var text: String? {
        didSet{
            setNeedsUpdate()
        }
    }
    public var attributedText: NSAttributedString? {
        didSet{
            setNeedsUpdate()
        }
    }
    @IBInspectable public lazy var textColor: UIColor = .black {
        didSet{
            setNeedsUpdate()
        }
    }
    @IBInspectable public var wordSpacing: CGFloat = 1 {
        didSet{
            wordSpacing = min(5, max(1, wordSpacing))
            setNeedsUpdate()
        }
    }
    @IBInspectable public var limitedLines: Int = 0 {
        didSet{
            setNeedsUpdate()
        }
    }
    @IBInspectable public var lineSpacing: CGFloat = 0 {
        didSet{
            setNeedsUpdate()
        }
    }
    @IBInspectable var fontName: String = "" {
        didSet{
            font = fontWithNameSize()
        }
    }
    @IBInspectable var fontSize: CGFloat = 16 {
        didSet{
            font = fontWithNameSize()
        }
    }
    func fontWithNameSize() -> UIFont {
        guard !fontName.isEmpty,
              let font = UIFont(name: fontName, size: fontSize) else {
            return .systemFont(ofSize: fontSize)
        }
        return font
    }
    
    public lazy var font: UIFont = fontWithNameSize() {
        didSet{
            setNeedsUpdate()
        }
    }
    public var breaking: BreakingMode = .truncate {
        didSet{
            setNeedsUpdate()
        }
    }
    public var layoutDirection: DisplayDirection = .leftToRight {
        didSet{
            setNeedsUpdate()
        }
    }
    public var xPosition: XPosition = .left {
        didSet{
            setNeedsUpdate()
        }
    }
    public var yPosition: YPosition = .top {
        didSet{
            setNeedsUpdate()
        }
    }
    public var lineAlignment: LineAlignment = .top {
        didSet{
            setNeedsUpdate()
        }
    }
    
    private var texter = Texter()
    
    private lazy var tmpLabel: UILabel = {
        let lb = UILabel()
        lb.font = font
        lb.text = text
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    private lazy var textsView: TextsView = {
        let view = TextsView()
        return view
    }()
    private var drawLabel: UILabel {
        if let _ = attributedText {
            return tmpLabel
        }
        tmpLabel.font = font
        tmpLabel.textColor = textColor
        return tmpLabel
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        setNeedsUpdate()
    }
}

public extension VerticalLabel {
    @IBInspectable var breakingMode: Int {
        set{
            guard let value = BreakingMode(rawValue: newValue) else {
                return
            }
            breaking = value
        }
        get {
            return breaking.rawValue
        }
    }
    @IBInspectable var direction: Int {
        set{
            guard let value = DisplayDirection(rawValue: newValue) else {
                return
            }
            layoutDirection = value
        }
        get {
            return layoutDirection.rawValue
        }
    }
    @IBInspectable var horizontal: Int {
        set{
            guard let value = XPosition(rawValue: newValue) else {
                return
            }
            xPosition = value
        }
        get {
            return  xPosition.rawValue
        }
    }
    @IBInspectable var vertical: Int {
        set{
            guard let value = YPosition(rawValue: newValue) else {
                return
            }
            yPosition = value
        }
        get {
            return yPosition.rawValue
        }
    }
    @IBInspectable var lineAlign: Int {
        set{
            guard let value = LineAlignment(rawValue: newValue) else {
                return
            }
            lineAlignment = value
        }
        get {
            return lineAlignment.rawValue
        }
    }
}

public extension VerticalLabel {
    func setNeedsUpdate() {
        calculating()
        drawingTexts()
    }
}

extension VerticalLabel {
    public var contentSize: CGSize {
        return textsArea.size
    }
    
    var _containerSize: CGSize {
        var w = containerSize.width
        var h = containerSize.height
        if w.isZero, h.isZero {
            return bounds.size
        }
        switch w {
        case -1: w = .infinity
        case 0: w = bounds.width
        default: break
        }
        switch h {
        case -1: h = .infinity
        case 0: h = bounds.height
        default: break
        }
        if w.isInfinite, h.isInfinite {
            h = bounds.height
        }
        return .init(width: w, height: h)
    }
}

extension VerticalLabel {
    var characters: [Character] {
        guard let firstLine = texter.lines.first else {
            return []
        }
        var x: CGFloat = isLTR ? 0 : (textsArea.maxX - firstLine.maxWidth)
        var yBase: CGFloat = 0
        var y: CGFloat = 0
        
        let area = textsArea
        
        var list: [Character] = []
        
        for line in texter.lines {
            switch lineAlignment {
            case .top: yBase = 0
            case .center: yBase = (area.height - line.height) / 2
            case .bottom: yBase = area.height - line.height
            }
            y = yBase
            for word in line.words {
                list.append(.init(text: word.text, frame: .init(origin: .init(x: x, y: y), size: word.size)))
                y += word.size.height
            }
            if isLTR {
                x += (line.maxWidth + lineSpacing)
            }
            else {
                x -= (line.maxWidth + lineSpacing)
            }
        }
        
        return list
    }
}

public extension VerticalLabel {
    enum BreakingMode: Int {
        case truncate
        case wordWrap
    }
    enum DisplayDirection: Int {
        case leftToRight
        case rightToLeft
    }
    enum XPosition: Int {
        case left
        case center
        case right
    }
    enum YPosition: Int {
        case top
        case center
        case bottom
    }
    enum LineAlignment: Int {
        case top
        case center
        case bottom
    }
}

extension VerticalLabel {
    class Texter {
        var lines: [Line] = []
        
        class Line: CustomStringConvertible {
            var words: [Word]
            var maxWidth: CGFloat
            
            var height: CGFloat {
                return words.reduce(0){ $0 + $1.size.height }
            }
            
            init(words: [Word], maxWidth: CGFloat) {
                self.words = words
                self.maxWidth = maxWidth
            }
            
            var description: String {
                return "{words: \(words)}, {maxWidth: \(maxWidth)}"
            }
        }
        
        class Word: CustomStringConvertible {
            var text: NSAttributedString
            var size: CGSize
            
            init(text: NSAttributedString, size: CGSize) {
                self.text = text
                self.size = size
            }
            
            var description: String {
                return "{text: \(text.string)}, {size: \(size)}"
            }
        }
    }
    
    class Character: CustomStringConvertible {
        var text: NSAttributedString
        var frame: CGRect
        init(text: NSAttributedString, frame: CGRect) {
            self.text = text
            self.frame = frame
        }
        var description: String {
            return "{text: \(text)}, frame: {\(frame)}"
        }
    }
}

extension VerticalLabel {
    func setLabelAttrText(_ text: NSAttributedString) {
        drawLabel.text = nil
        drawLabel.attributedText = text
    }
    func labelAttrTextFittedSize(with text: NSAttributedString) -> CGSize {
        setLabelAttrText(text)
        let flexibleSize = CGSize(width: .zero, height: .max)
        return drawLabel.sizeThatFits(flexibleSize)
    }
    
    func setLabelText(_ text: String) {
        drawLabel.text = text
        guard let attrText = drawLabel.attributedText else {
            return
        }
        var range = NSMakeRange(0, text.count)
        var attrs = attrText.attributes(at: 0, effectiveRange: &range)
        if let pg = attrs[.paragraphStyle] as? NSParagraphStyle,
           let mpg = pg.mutableCopy() as? NSMutableParagraphStyle {
            mpg.lineHeightMultiple = wordSpacing
            attrs[.paragraphStyle] = mpg
        }
        drawLabel.attributedText = NSAttributedString(string: text, attributes: attrs)
    }
    func labelTextFittedSize(with text: String) -> CGSize {
        setLabelText(text)
        let flexibleSize = CGSize(width: .zero, height: .max)
        return drawLabel.sizeThatFits(flexibleSize)
    }
    
    class TextsView: UIView {
        var characters: [Character] = [] {
            didSet{
                setNeedsDisplay()
            }
        }
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            for c in characters {
                c.text.draw(in: c.frame)
            }
        }
    }
    
    var originUpdatedTextsArea: CGRect {
        var area = textsArea
        switch (xPosition, yPosition) {
        case (.left, .top):
            area.origin = .zero
        case (.left, .center):
            area.origin.y = (bounds.height - area.size.height)/2
        case (.left, .bottom):
            area.origin.y = bounds.height - area.size.height
            
        case (.right, .top):
            area.origin.x = bounds.width - area.size.width
        case (.right, .center):
            area.origin.x = bounds.width - area.size.width
            area.origin.y = (bounds.height - area.size.height)/2
        case (.right, .bottom):
            area.origin.x = bounds.width - area.size.width
            area.origin.y = bounds.height - area.size.height
            
        case (.center, .top):
            area.origin.x = (bounds.width - area.size.width) / 2
        case (.center, .center):
            area.origin.x = (bounds.width - area.size.width) / 2
            area.origin.y = (bounds.height - area.size.height)/2
        case (.center, .bottom):
            area.origin.x = (bounds.width - area.size.width) / 2
            area.origin.y = bounds.height - area.size.height
        }
        return area
    }
    
    func drawingTexts() {
        var area = originUpdatedTextsArea
        scrollView.contentSize = contentSize
        
        if _containerSize.width.isInfinite {
            area.origin.x = .zero
            if layoutDirection == .rightToLeft {
                scrollView.contentOffset = .init(x: contentSize.width - bounds.size.width, y: 0)
            }
        }
        
        textsView.backgroundColor = .clear
        textsView.frame = area
        textsView.characters = characters
    }
    
    var textsArea: CGRect {
        let lines = texter.lines
        let w = lines.reduce(0){ $0 + $1.maxWidth + lineSpacing } - lineSpacing
        let heights = lines.map{ $0.height }
        guard
            let h = heights.max(by: { $0 <= $1 }) else {
            return .zero
        }
        return .init(origin: .zero, size: .init(width: w, height: h))
    }
    
    var isLTR: Bool {
        return layoutDirection == .leftToRight
    }
    
    func calculating() {
        let text = attributedText?.string ?? text
        guard let text = text else {
            return
        }
        texter = .init()
        var y = CGFloat.zero
        var x = CGFloat.zero
        var maxW = CGFloat.zero
        
        var words: [Texter.Word] = []
        var isChangedLine = false
        func resetValues() {
            y = 0
            maxW = 0
            words = []
            isChangedLine = true
        }
        
        func addNewLineIfNeeded() -> Bool {
            x += (maxW + lineSpacing)
            if x > _containerSize.width {
                if  breaking == .truncate,
                    var words = texter.lines.last?.words
                {
                    words = words.dropLast(3)
                    let size = labelTextFittedSize(with: ".")
                    let text = drawLabel.attributedText!
                    let breakings: [Texter.Word] = (0...2).map{_ in
                        .init(text: text, size: size)
                    }
                    words.append(contentsOf: breakings)
                    texter.lines.last?.words = words
                }
                return false
            }
            texter.lines.append(.init(words: words, maxWidth: maxW))
            if limitedLines > 0, texter.lines.count == limitedLines {
                return false
            }
            return true
        }
        func addWord(size: CGSize){
            words.append(.init(text: drawLabel.attributedText!, size: size))
        }
        
        for (i,char) in text.enumerated()
        {
            isChangedLine = false
            if char.isNewline {
                if !addNewLineIfNeeded() {
                    break
                }
                resetValues()
                continue
            }
            
            let str = String(char)
            var size: CGSize = .zero
            if let attrText = attributedText?.attributedSubstring(from: NSMakeRange(i, str.count)) {
                size = labelAttrTextFittedSize(with: attrText)
            }
            else {
                size = labelTextFittedSize(with: str)
            }
            
            guard size != .zero else {
                continue
            }
            
            if maxW < size.width {
                maxW = size.width
            }
            
            y += size.height
            if y > _containerSize.height {
                if !addNewLineIfNeeded() {
                    break
                }
                resetValues()
                addWord(size: size)
                maxW = size.width
            }
            else {
                y -= size.height
                addWord(size: size)
            }
            
            if !isChangedLine, i == text.count-1 {
                if !addNewLineIfNeeded() {
                    break
                }
            }
            
            y += size.height
        }
    }
}

