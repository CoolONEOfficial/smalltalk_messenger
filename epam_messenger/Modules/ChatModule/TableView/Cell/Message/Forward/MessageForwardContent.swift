//
//  MessageForwardContent.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 29.03.2020.
//

import UIKit

class MessageForwardContent: UIView, MessageCellContentProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var forwardLabel: UILabel!
    
    // MARK: - Vars
    
    var shouldSetupConstraints = true
    
    var cell: MessageCellProtocol!
    var mergeContentNext: Bool!
    var mergeContentPrev: Bool!
    var kindIndex: Int!
    var messageForward: MessageForwardProtocol! {
        didSet {
            forwardLabel.text = "Forwarded from ..."
        }
    }
    
    var message: MessageProtocol! {
        return messageForward
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
        self.messageForward = message as! MessageForwardProtocol
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
        Bundle.main.loadNibNamed("MessageForwardContent", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Methods
    
    override func updateConstraints() {
        super.updateConstraints()
        if shouldSetupConstraints {
            if let bubbleView = superview?.superview {
                if messageForward.isIncoming {
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
    
    func didLoadUser(_ user: UserProtocol) {
        cell.delegate?.cellUserData(messageForward.kindForwardUser(at: kindIndex)!) { userModel in
            let userName: String
            if let userModel = userModel {
                userName = "\(userModel.name)"
            } else {
                userName = "deleted user"
            }
            
            self.forwardLabel.text = "Forwarded from \(userName)"
        }
    }
    
    var topMargin: CGFloat {
        return 4
    }
    
    var bottomMargin: CGFloat {
        return 4
    }
}
