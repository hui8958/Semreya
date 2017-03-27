//
//  ParcelViewController.swift
//  Semreya
//
//  Created by Hui on 2017-01-12.
//  Copyright © 2017 Hui. All rights reserved.
//

import UIKit

class ParcelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var status: UILabel!
    var parcel: Parcel?
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        self.table.refreshControl = UIRefreshControl()
        
        self.table.refreshControl!.addTarget(self, action: #selector(refreshData),
                                       for: .valueChanged)
        self.table.refreshControl!.attributedTitle = NSAttributedString(string: "稍等一下马上就来咯😘")
        
        
        if let parcel = parcel {
            //     navigationItem.title = meal.name
            name.text = parcel.name
            print("receive: " + parcel.name)
            if(parcel.state==3){
                 icon.image = UIImage(named: "delivered")
                status.text = "已送达"
            }else{
                 icon.image = UIImage(named: "ontheway")
                status.text = "在途中"
            }
           
            
            id.text = parcel.number
        }

        // Do any additional setup after loading the view.
    }

    func refreshData(){
        let serialQueue = DispatchQueue(label: "com.queue.Serial")
        serialQueue.async {
            
            self.parcel?.refreshData()
            self.table.reloadData()
            self.table.setNeedsDisplay()
            
            self.table.refreshControl!.endRefreshing()
        }
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parcel!.TrackingInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ParcelDetailTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ParcelDetailTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let trackinginfo = parcel?.TrackingInfos[indexPath.row]
        
        cell.time.text = trackinginfo?.time
        cell.location.text = trackinginfo?.location
        if(trackinginfo?.type == "SE"){
            cell.flag.image = UIImage(named: "sweden")
        }else{
             cell.flag.image = UIImage(named: "china")
        }
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0.0
        
        if GlobelData.sharedInstance.setting.enableSweden &&  parcel?.TrackingInfos[indexPath.row].type == "SE"{
        rowHeight = 99.0
        }else if !GlobelData.sharedInstance.setting.enableSweden &&  parcel?.TrackingInfos[indexPath.row].type == "SE"{
        rowHeight = 0
        }
        
        if GlobelData.sharedInstance.setting.enableChina &&  parcel?.TrackingInfos[indexPath.row].type == "CN"{
            rowHeight = 99.0
        }else if !GlobelData.sharedInstance.setting.enableChina &&  parcel?.TrackingInfos[indexPath.row].type == "CN"{
            rowHeight = 0
        }

        
        
        return rowHeight
    }
    
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "现在的位置"
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
