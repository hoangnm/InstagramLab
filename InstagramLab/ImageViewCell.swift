//
//  ImageViewCell.swift
//  InstagramLab
//
//  Created by VietCas on 3/9/16.
//  Copyright © 2016 com.hoangphuong. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {

    
    @IBOutlet weak var profileView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
