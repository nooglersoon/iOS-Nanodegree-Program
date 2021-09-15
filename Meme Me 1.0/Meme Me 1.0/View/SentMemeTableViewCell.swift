//
//  SentMemeTableViewCell.swift
//  Meme Me 1.0
//
//  Created by Fauzi Achmad B D on 17/08/21.
//

import UIKit

class SentMemeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var labelViewCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
