//
//  FullScreenImageVC.swift
//  Radio
//
//  Created by Keval Patel on 4/28/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit
import ZoomImageView
import SDWebImage

class FullScreenImageVC: UIViewController {
    @IBOutlet weak var btnCancel: UIButton!
    var img : UIImage?
    var imgProfilePic = ZoomImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
       configureImageView()
    }
    
    func configureImageView(){
        imgProfilePic.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height:  self.view.frame.height - 100)
        imgProfilePic.image = img
        self.view.addSubview(imgProfilePic)
    }

    //MARK: - Actions
    @IBAction func selBtnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
