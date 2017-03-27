//
//  PersonsSettingTableViewController.swift
//  Semreya
//
//  Created by Hui on 2017-01-16.
//  Copyright © 2017 Hui. All rights reserved.
//

import UIKit

class PersonsSettingTableViewController: UITableViewController {
    @IBOutlet weak var changeEnableSweden: UISwitch!
    @IBOutlet weak var changeEnableChina: UISwitch!
    @IBOutlet weak var changeEnableDelivered: UISwitch!
    @IBOutlet weak var adminMode: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        changeEnableSweden.setOn(GlobelData.sharedInstance.setting.enableSweden, animated: true)
        
        changeEnableChina.setOn(GlobelData.sharedInstance.setting.enableChina, animated: true)
        
          changeEnableDelivered.setOn(GlobelData.sharedInstance.setting.enableDelivered, animated: true)
       
        changeEnableSweden.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        
        changeEnableChina.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
         changeEnableDelivered.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        
    
    }


    
    func switchValueDidChange() {
        if changeEnableSweden.isOn {
            GlobelData.sharedInstance.setting.enableSweden = true
        } else {
              GlobelData.sharedInstance.setting.enableSweden = false
        }
        
        if changeEnableChina.isOn{
            GlobelData.sharedInstance.setting.enableChina = true
        }else{
            GlobelData.sharedInstance.setting.enableChina = false
        }
        
        if changeEnableDelivered.isOn{
            GlobelData.sharedInstance.setting.enableDelivered = true
        }else{
            GlobelData.sharedInstance.setting.enableDelivered = false
        }
        
        if adminMode.isOn{
            GlobelData.sharedInstance.setting.adminMode = true
        }else{
            GlobelData.sharedInstance.setting.adminMode = false
        }
        
        
        
        GlobelData.sharedInstance.saveSettings()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

 
 
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
