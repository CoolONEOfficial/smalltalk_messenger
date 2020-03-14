//
//  MessageTextCell.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 13.03.2020.
//

import UIKit
import Reusable

class MessageTextCell: UITableViewCell, NibReusable {

    @IBOutlet var messageTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadMessageModel(
        _ messageModel: MessageModel
    ) {
        messageTextLabel.text = messageModel.text
    }
    
}
