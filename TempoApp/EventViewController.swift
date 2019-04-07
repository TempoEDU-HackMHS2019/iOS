//
//  EventViewController.swift
//  TempoApp
//
//  Created by Chew on 4/7/19.
//  Copyright © 2019 TempoApp Development. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Cosmos

class EventViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var chilis: CosmosView!
    
    @IBOutlet weak var subEventTableVIew: UITableView!
    
    let defaults = UserDefaults.standard
    var id = 0
    
    var tdata:[String] = []
    var tids:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.id = defaults.integer(forKey: defaultsKeys.keyTwo)
        // Do any additional setup after loading the view.
        
        let authkey = defaults.string(forKey: defaultsKeys.keyOne)
        
        let headers: HTTPHeaders = [
            "Authorization": authkey!
        ]
        
        AF.request("https://api.tempoapp.pro/v1/event/\(self.id)", method: .get, headers: headers).responseJSON { response in
            print(response)
            if response.response?.statusCode == 429 {
                self.viewDidLoad()
            }
            let json = JSON(response.data as Any)
            self.titleLabel.text = json["name"].string ?? "Unknown!"
            self.descriptionLabel.text = json["description"].string!
            self.chilis.rating = json["difficulty"].double ?? 0.0
        }
        
        
    }
    
    @IBAction func deleteEvent(_ sender: Any) {
        let authkey = defaults.string(forKey: defaultsKeys.keyOne)
        
        let headers: HTTPHeaders = [
            "Authorization": authkey!
        ]
        let alert = UIAlertController(title: "Attention", message: "Are you sure you want to delete this event?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            print("default")
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {  action in
            print("destructive")
            AF.request("https://api.tempoapp.pro/v1/event/\(self.id)", method: .delete, headers: headers).responseJSON { response in
                print(response)
                if response.response?.statusCode == 429 {
                    return
                }
                if response.response?.statusCode == 400 {
                    return
                }
                _ = self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        print(indexPath.row)
        print(tdata)
        
        cell.textLabel?.text = tdata[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
