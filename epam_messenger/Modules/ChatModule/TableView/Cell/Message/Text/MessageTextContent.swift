//
//  MessageTextContent.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import UIKit
import TinyConstraints

class MessageTextContent: UIView, Messagable {
    
    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    // MARK: - Vars
    
    var superInsets: TinyEdgeInsets!
    var shouldSetupConstraints = true
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var mergeNext: Bool!
    var mergePrev: Bool!
    var textMessage: TextMessageProtocol! {
        didSet {
            superInsets = .vertical(4) + (
                textMessage.isIncoming
                    ? .left(16) + .right(8)
                    : .left(8) + .right(16)
            )
            
            let textColor: UIColor = textMessage.isIncoming
                ? .plainText
                : .accentText
            
            setupTextLabel(textColor)
            setupUsernameLabel(textColor)
            setupTimeLabel(textColor)
        }
    }
    
    private func setupTextLabel(_ textColor: UIColor) {
        textLabel.text = textMessage.text
        textLabel.textColor = textColor
    }
    
    private func setupUsernameLabel(_ textColor: UIColor) {
        let isHidden = mergePrev! || !textMessage.isIncoming
        
        usernameLabel.isHidden = isHidden
        if !isHidden {
            usernameLabel.textColor = textColor
            usernameLabel.text = "User Userov" // TODO: user name by id
        }
    }
    
    private func setupTimeLabel(_ textColor: UIColor) {
        timeLabel.text = timeFormatter.string(from: textMessage.date)
        timeLabel.textColor = textColor
        
        timeLabel.top(
            to: textLabel, textLabel.bottomAnchor,
            offset: textLabel.haveEndSpace
                ? -timeLabel.bounds.height
                : 0
        )
    }
    
    func loadMessage(_ message: MessageProtocol, mergeNext: Bool, mergePrev: Bool) {
        self.mergeNext = mergeNext
        self.mergePrev = mergePrev
        self.textMessage = message as? TextMessageProtocol
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
        if shouldSetupConstraints {
            edgesToSuperview(insets: superInsets)
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
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
