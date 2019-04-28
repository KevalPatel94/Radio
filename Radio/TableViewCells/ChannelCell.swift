//
//  ChannelCell.swift
//  Radio
//
//  Created by Keval Patel on 4/27/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit
import SDWebImage
class ChannelCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDj: UILabel!
    var channelViewModel: ChannelViewModel!{
        didSet{
            lblTitle.text = channelViewModel.title
            lblDescription.text = channelViewModel.description
            lblDj.text = channelViewModel.dj
            imageViewConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfile.layer.cornerRadius = 5.0
        imgProfile.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - imageViewProperties
    func imageViewConfiguration(){
        imgProfile.sd_setImage(with: URL(string: channelViewModel?.xlimage ?? ""), placeholderImage:UIImage(named: "ChannelPlaceHolder"), options: .refreshCached, completed: { (image, err, cache, url) in
            if image != nil{
                self.imgProfile.image = image
            }
        })
    }

}
