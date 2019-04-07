//
//  EventsViewController.swift
//  TempoApp
//
//  Created by Chew on 4/7/19.
//  Copyright © 2019 TempoApp Development. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventsViewController: UITableViewController {
    
    var tdata:[String] = []
    var tids:[Int] = []

    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authkey = defaults.string(forKey: defaultsKeys.keyOne)
        
        let headers: HTTPHeaders = [
            "Authorization": authkey!
        ]
        
        AF.request("https://api.tempoapp.pro/v1/event/all", method: .get, headers: headers).responseJSON { response in
            print(response)
            if response.response?.statusCode == 429 {
                return
            }
            let json = JSON(response.data as Any)
            for (key, subJson) in json {
                if subJson["parent_id"] != 0 {
                    if let title = subJson["name"].string {
                        self.tdata.append(title)
                        print(self.tdata)
                    }
                    if let id = subJson["id"].int {
                        self.tids.append(id)
                    }
                }
                
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func goToCreate(_ sender: Any) {
        self.performSegue(withIdentifier: "ToCreateEventSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tdata.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        print(indexPath.row)
        print(tdata)
        
        cell.textLabel?.text = tdata[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected: \(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        
        var id = tids[indexPath.row]
        
        defaults.set(id, forKey: defaultsKeys.keyTwo)
        
        self.performSegue(withIdentifier: "ToEventDetailSegue", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
