//
//  NewEventViewController.swift
//  TempoApp
//
//  Created by Chew on 4/7/19.
//  Copyright © 2019 TempoApp Development. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SwiftyJSON

class NewEventViewController: UIViewController {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var chilis: CosmosView!
    @IBOutlet weak var date: UIDatePicker!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: UIStoryboardSegue) {
        // Add a new meal.
        print("Button pressed")
        let parameters = [
            "name": titleLabel.text as! String,
            "description": descriptionLabel.text as! String,
            "difficulty": chilis.rating,
            "type": 1,
            "duedate": date.date
        ] as [String : Any]
            
        let authkey = defaults.string(forKey: defaultsKeys.keyOne)
        
        let headers: HTTPHeaders = [
            "Authorization": authkey!
        ]
        print("Sending request")
        AF.request("https://api.tempoapp.pro/v1/event/create", method: .post, parameters: parameters, headers: headers).responseJSON { response in
            print(response)
            let json = JSON(response.data as Any)
            if response.response?.statusCode == 429 {
                return
            }
            if response.response?.statusCode == 400 {
                //self.errorLabel.text = json["reason"].string!
                return
            }
            print("Sent!")
        }
        _ = self.navigationController?.popViewController(animated: true)
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
