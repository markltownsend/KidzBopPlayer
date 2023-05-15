//
//  SongCell.swift
//  KidzBopPlayer
//
//  Created by Mark Townsend on 9/3/19.
//

import UIKit

class SongCell: UITableViewCell {

    static let cellID = "SongCell"
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var albumTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
