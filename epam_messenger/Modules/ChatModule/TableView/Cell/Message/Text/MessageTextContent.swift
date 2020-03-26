//
//  MessageTextContent.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import UIKit
import TinyConstraints

class MessageTextContent: UIView, MessageCellContentProtocol {

    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var infoStack: UIStackView!
    
    // MARK: - Vars
    
    var shouldSetupConstraints = true
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var cell: MessageCellProtocol!
    var mergeContentNext: Bool!
    var mergeContentPrev: Bool!
    var kindIndex: Int!
    var textMessage: MessageTextProtocol! {
        didSet {
            
            let textColor: UIColor = textMessage.isIncoming
                ? .plainText
                : .accentText
            
            setupTextLabel(textColor)
            setupUsernameLabel(textColor)
            setupTimeLabel(textColor)
        }
    }
    
    var message: MessageProtocol! {
        return textMessage
    }
    
    private func setupTextLabel(_ textColor: UIColor) {
        textLabel.text = textMessage.kindText(at: kindIndex)
        textLabel.textColor = textColor
    }
    
    private func setupUsernameLabel(_ textColor: UIColor) {
        let isHidden = cell.mergePrev! || !textMessage.isIncoming || mergeContentPrev
        
        usernameLabel.isHidden = isHidden
        if !isHidden {
            usernameLabel.textColor = textColor
            usernameLabel.text = "User Userov" // TODO: user name by id
        }
    }
    
    private func setupTimeLabel(_ textColor: UIColor) {
        timeLabel.text = timeFormatter.string(from: textMessage.date)
        timeLabel.textColor = textColor
        
        infoStack.topToBottom(of: textLabel, offset: textLabel.haveEndSpace
            ? -timeLabel.bounds.height
            : 0
        )
    }
    
    func loadMessage(
        _ message: MessageProtocol,
        index: Int, cell: MessageCellProtocol,
        mergeContentNext: Bool,
        mergeContentPrev: Bool
    ) {
        self.kindIndex = index
        self.cell = cell
        self.mergeContentNext = mergeContentNext
        self.mergeContentPrev = mergeContentPrev
        self.textMessage = message as! MessageTextProtocol
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MessageTextContent", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Methods
    
    override func updateConstraints() {
        super.updateConstraints()
        if shouldSetupConstraints {
            if let bubbleView = superview?.superview {
                if textMessage.isIncoming {
                    leftToSuperview(offset: 10)
                    right(to: bubbleView, offset: -10)
                } else {
                    leftToSuperview(offset: 10)
                    right(to: bubbleView, offset: -16)
                }
            }
            
            shouldSetupConstraints = false
        }
    }
    
    var topMargin: CGFloat {
        return 4
    }
    
    var bottomMargin: CGFloat {
        return 4
    }
}

// MARK: Get lines of label extension from StackOverflow

fileprivate extension UILabel {
    
    func getSeparatedLines() -> [String] {
        if self.lineBreakMode != NSLineBreakMode.byWordWrapping {
            self.lineBreakMode = .byWordWrapping
        }
        var lines = [String]()
        let wordSeparators = CharacterSet.whitespacesAndNewlines
        var currentLine: String? = self.text
        let textLength: Int = (self.text?.count ?? 0)
        var rCurrentLine = NSRange(location: 0, length: textLength)
        var rWhitespace = NSRange(location: 0, length: 0)
        var rRemainingText = NSRange(location: 0, length: textLength)
        var done: Bool = false
        while !done {
            // determine the next whitespace word separator position
            rWhitespace.location += rWhitespace.length
            rWhitespace.length = textLength - rWhitespace.location
            rWhitespace = (self.text! as NSString).rangeOfCharacter(from: wordSeparators, options: .caseInsensitive, range: rWhitespace)
            if rWhitespace.location == NSNotFound {
                rWhitespace.location = textLength
                done = true
            }
            let rTest = NSRange(location: rRemainingText.location, length: rWhitespace.location - rRemainingText.location)
            let textTest: String = (self.text! as NSString).substring(with: rTest)
            let maxWidth = (textTest as NSString)
                .size(
                    withAttributes:
                    [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]
            ).width
            if maxWidth > 180 {
                lines.append(currentLine?.trimmingCharacters(in: wordSeparators) ?? "")
                rRemainingText.location = rCurrentLine.location + rCurrentLine.length
                rRemainingText.length = textLength - rRemainingText.location
                continue
            }
            rCurrentLine = rTest
            currentLine = textTest
        }
        lines.append(currentLine?.trimmingCharacters(in: wordSeparators) ?? "")
        return lines
    }
    
    var haveEndSpace: Bool {
        let lines = self.getSeparatedLines()
        
        if !lines.isEmpty {
            let lastLine: String = (lines.last as? String)!
            let fontAttributes = [NSAttributedString.Key.font.rawValue: font]
            let lastLineWidth = (lastLine as NSString).size(withAttributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]).width
            return lines.count > 1 ? lastLineWidth < 140 : lastLineWidth < 60
        }
        
        return false
    }
    
}
