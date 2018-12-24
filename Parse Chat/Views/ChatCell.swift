//
//  ChatCell.swift
//  Parse Chat
//
//  Created by Stephon Fonrose on 12/20/18.
//  Copyright © 2018 Stephon Fonrose. All rights reserved.
//

import UIKit
import Parse

class ChatCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var message: PFObject! {
        didSet {
            messageLabel.text = message["text"] as? String
            if let user = message["user"] as? PFUser {
                usernameLabel.text = user.username
            } else {usernameLabel.text = "<No Username>"}
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM d, yyyy h:mm a"
            dateLabel.text = dateFormatterPrint.string(from: message.createdAt!)
        }
    }
    @IBOutlet weak var chatBubble: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatBubble.layer.cornerRadius = 20
        chatBubble.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
