//
//  EventViewCell.swift
//  FOCUS_Project
//
//  Created by Nicolas on 16/05/2017.
//  Copyright © 2017 Nicolas Charvoz. All rights reserved.
//

import UIKit

class EventViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(event: Event) {
        titleLabel.text = event.eventName
        dateLabel.text = event.eventDate
        priceLabel.text = "$" + String(event.eventPrice)
        
        let base64string = event.eventIcon
        
        let decodedString = Data(base64Encoded: base64string, options: .ignoreUnknownCharacters)
        let decodedImg = UIImage(data: decodedString!)
        
        logoView.image = decodedImg
    }
    
}
