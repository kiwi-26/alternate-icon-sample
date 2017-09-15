//
//  ViewController.swift
//  alternate-icon-sample
//
//  Created by 長谷川敬 on 2017/09/15.
//  Copyright © 2017年 kiwi26. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    private let iconNames = ["Icon-App-A", "Icon-App-B", "Icon-App-C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let image = UIImage(named: iconNames[indexPath.row])
        cell.textLabel?.text = iconNames[indexPath.row]
        cell.imageView?.image = image
        cell.imageView?.layer.cornerRadius = (image?.size.width)!/2
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = iconNames[indexPath.row]
        
        let application = UIApplication.shared
        if indexPath.row == 0 {
            application.setAlternateIconName(nil, completionHandler: nil)
        } else {
            application.setAlternateIconName(identifier, completionHandler: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
