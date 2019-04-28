//
//  ChannelDetailVC.swift
//  Radio
//
//  Created by Keval Patel on 4/27/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit
import SDWebImage
class ChannelDetailVC: UIViewController {
    @IBOutlet weak var imgViewChannel: UIImageView!
    @IBOutlet weak var lblDj: UILabel!
    @IBOutlet weak var lblDjEmail: UILabel!
    @IBOutlet weak var lblTitleListeners: UILabel!
    @IBOutlet weak var lblListeners: UILabel!
    @IBOutlet weak var lblTitleGenre: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblTitleDescription: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewDescription: UIView!

    enum labelTitles: String{
        case genre = "Genre"
        case description = "Desription"
        case numberOfListeners = "Number of Listener"

    }
    var channelViewModel: ChannelViewModel?
    let utilityQueue = DispatchQueue.global(qos: .utility)
    let mainQueue = DispatchQueue.main
    var channelImage = UIImage(named: "LargePlaceHolder")
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Check for Internet Connectivity
        if InternetConnectivity.isConnectedToNetwork() == false{
            self.noInternetAlert()
        }
        imageViewConfiguration()
        guard channelViewModel != nil else {return}
        detailViewConfiguration()
        downloadAndDisplayImage(utilityQueue, mainQueue)
    }
    
    
    deinit {
        print("Deinitialized")
    }
    
    //MARK: - imageViewConfiguration
    func imageViewConfiguration(){
        imgViewChannel.layer.cornerRadius = imgViewChannel.frame.size.height/10
        imgViewChannel.clipsToBounds = true
    }
    //MARK: - detailViewConfiguration
    func detailViewConfiguration(){
        self.navigationItem.title = channelViewModel?.title
        lblDj.text = channelViewModel?.dj
        lblGenre.text = channelViewModel?.genre
        lblListeners.text = channelViewModel?.listeners
        //Set text to Description label and provide dynamic height for **viewDescription**
        viewDescription.frame.size.height = heightForView(channelViewModel?.description ?? "", lblDescription)
        lblDjEmail.text = channelViewModel?.djmail
        lblTitleGenre.text = labelTitles.genre.rawValue
        lblTitleDescription.text = labelTitles.description.rawValue
        lblTitleListeners.text = labelTitles.numberOfListeners.rawValue
    }
    //MARK: - imageViewProperties
    func downloadAndDisplayImage(_ utilityQueue: DispatchQueue, _ completionQueue: DispatchQueue){
        utilityQueue.async {
            self.imgViewChannel.sd_setImage(with: URL(string: self.channelViewModel?.largeimage ?? ""), placeholderImage:UIImage(named: "LargePlaceHolder"), options: .refreshCached, completed: { (image, err, cache, url) in
                completionQueue.async {
                    if image != nil{
                        self.imgViewChannel.image = image
                        self.channelImage = image
                    }
                }
            })
        }
    }

    //MARK: - function to change the height of description view as per the length of description and set text for label
    func heightForView(_ text:String,_ label: UILabel) -> CGFloat{
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    @IBAction func tapImageView(_ sender: Any) {
        if let fullScreenVC = self.storyboard?.instantiateViewController(withIdentifier: "FullScreenImageVC") as? FullScreenImageVC{
            fullScreenVC.img = channelImage
            self.navigationController?.present(fullScreenVC, animated: true, completion: nil)
        }
    }
    
}
