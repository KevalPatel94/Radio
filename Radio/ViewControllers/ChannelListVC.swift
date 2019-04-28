//
//  ChannelListVC.swift
//  Radio
//
//  Created by Keval Patel on 4/27/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit
import RxSwift
class ChannelListVC: UIViewController {
    
    @IBOutlet weak var tblChannels: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    enum urlStrings : String{
        case getChannel = "https://raw.githubusercontent.com/jvanaria/jvanaria.github.io/master/channels.json"
    }
    enum constants: String {
        case unknown = "Unknown"
        case titleDJ = "DJ"
        case titleSelect = "Select"
        case titleCancel = "Cancel"
        case all = "All"
        case tblChannelsAccessibility = "table--channlesTableView"
    }
    var alertView: UIAlertController?
    var pickerView: UIPickerView?
    let utilityQueue = DispatchQueue.global(qos: .utility)
    let mainQueue = DispatchQueue.main
    lazy var refresher : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    var channelViewModels = [ChannelViewModel]()
    var filteredViewModels = [ChannelViewModel]()
    var djList = [constants.all.rawValue]
    var selectedDj = constants.all.rawValue

    /* RxSwift variabhles for filtering functionality*/
    var disposeBag = DisposeBag()
    private var selectedDJ = Variable(constants.all.rawValue)
    var observableForDJ:Observable<String>{
        return selectedDJ.asObservable()
    }
    /* RxSwift variabhles for filtering functionality*/

   
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfiguration()
        getChannelData()
        /*RxSwift function: - Subscribes to the observable*/
        subscriberToSelectedDJ()
    }
    
    // Refreshing Filtered Data
    @objc func refreshData(){
        //Check For Internet Connectivity and Notify User
        guard InternetConnectivity.isConnectedToNetwork() == true else {
            //End Refreshing and pop up noInternet Alert
            self.refresher.endRefreshing()
            self.activity.isHidden = true
            self.noInternetAlert()
            return
        }
        //Check Whether refresher is refreshing
        guard refresher.isRefreshing == true else {
            return
        }
        //GetData Api Call
        getChannelData()
    }
    
    //MARK: - getData BY calling Web Service
    func getChannelData() {
        //Check For Internet Connectivity and Notify User
        guard InternetConnectivity.isConnectedToNetwork() == true else {
            //End Refreshing and pop up noInternet Alert
            self.refresher.endRefreshing()
            self.activity.isHidden = true
            self.noInternetAlert()
            return
        }
        //Call WebService
        WebService.shared.fetchArticles(urlStrings.getChannel.rawValue, utilityQueue, mainQueue) { (channels, error) in
            
            UIView.animate(withDuration: 0.6, animations: {
                self.refresher.endRefreshing()
                self.tblChannels.contentOffset = .zero
            })
            //Check For Error
            if let error = error{
                //Pop Up Error Alert
                self.errorAlert("Couldn't Find Data", error.localizedDescription)
            }
            //Mapping Models to channelViewModels Array
            self.channelViewModels = channels?.map({return ChannelViewModel($0)}) ?? []
            //Mapping Models to filteredViewModels Array
            self.filteredViewModels = self.channelViewModels
            //Mapping Dj to DjList
            self.djList.append(contentsOf: self.channelViewModels.map({
                if $0.dj == ""{
                    return constants.unknown.rawValue
                }
                return $0.dj}))
            //Remove Duplicates from DjList
            self.djList = self.djList.removeDuplicates()
            self.tblChannels.reloadData()
            
        }
    }
    
    //MARK: - tableViewProperties
    func tableViewConfiguration(){
        tblChannels.delegate = self
        tblChannels.dataSource = self
        tblChannels.tableFooterView = UIView()
        if #available(iOS 10.0, *) {
            tblChannels.refreshControl = refresher
        } else {
            tblChannels.addSubview(refresher)
        }
         
        tblChannels.accessibilityIdentifier = constants.tblChannelsAccessibility.rawValue
    }
    
    
    //MARK: - Button Actions
    @IBAction func selBtnFilter(_ sender: Any) {
        self.constructAlertView(constants.titleDJ.rawValue)
    }
}


//MARK: - TableViewDelegate and DataSource
extension ChannelListVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredViewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channelCell = tblChannels.dequeueReusableCell(withIdentifier: "ChannelCell") as? ChannelCell
        channelCell?.channelViewModel = filteredViewModels[indexPath.row]
        return channelCell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let channelDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ChannelDetailVC") as? ChannelDetailVC{
            channelDetailVC.channelViewModel = filteredViewModels[indexPath.row]
            self.navigationController?.pushViewController(channelDetailVC, animated: true)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refresher.isRefreshing == true{
            refreshData()
        }
    }
}


//MARK: - PickerView Delegate for DJList ActionSheet
extension ChannelListVC: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (djList.count)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return "\(djList[row])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDj = djList[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = djList[row]
        return pickerLabel!
    }
}


//MARK: - Extension Filter Module implemented using RxSwift
extension ChannelListVC{
    //MARK:- Construct AlertView
    func constructAlertView(_ title: String){
        selectedDj = constants.all.rawValue
        alertView = UIAlertController(
            title: title,
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .actionSheet)
        
        // Add alert Actions
        let action = UIAlertAction(title: constants.titleSelect.rawValue, style: UIAlertAction.Style.default) { (action) in
            self.selectedDJ.value = self.selectedDj
        }
        let anotheraction = UIAlertAction(title: constants.titleCancel.rawValue, style: UIAlertAction.Style.cancel) { (action) in
            
        }
        alertView?.addAction(action)
        alertView?.addAction(anotheraction)
        
        // Add Picker View
        pickerView = UIPickerView(frame:
            CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerView?.dataSource = self
        pickerView?.delegate = self
        alertView?.view.addSubview(pickerView!)
        
        // Present Alert
        self.present(alertView!, animated: true) {
            self.pickerView?.frame.size.width = (self.alertView?.view.frame.size.width)!
        }
        
    }
    
    //MARK: - Configure subscriber for
    func subscriberToSelectedDJ(){
        //Subscribe on observableForDJ
        observableForDJ.subscribe(onNext: { [weak self] (nameOfDj) in
            //Will get execute every time selectedDJ will get change
            self?.configureFilteredViewModel()
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
        }) {
            //Memory Management
            // Most Important part to Dispose using disposeBag
            }.disposed(by: disposeBag)
    }
    
    //Function that configure the filtered Array
    func configureFilteredViewModel(){
        guard self.channelViewModels.count >= 1 else{return}
        //If The Category selected is "All"
        if self.selectedDj == constants.all.rawValue{self.filteredViewModels = self.channelViewModels}
        //If The Category selected is "Unknown" which means "" from api response
        else if self.selectedDJ.value == constants.unknown.rawValue{self.filteredViewModels = self.channelViewModels.filter({$0.dj == ""})}
        //Case for selected category for DJ other than "All" and "Unknown"
        else{self.filteredViewModels = self.channelViewModels.filter({$0.dj == self.selectedDJ.value})}
        //Reload tblChannels and scroll to first row
        self.tblChannels.reloadData()
        self.tblChannels.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
