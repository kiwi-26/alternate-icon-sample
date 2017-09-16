//
//  ViewController.swift
//  alternate-icon-sample
//
//  Created by 長谷川敬 on 2017/09/15.
//  Copyright © 2017年 kiwi26. All rights reserved.
//

import UIKit
import UserNotifications
import CoreSpotlight
import MobileCoreServices

class ViewController: UITableViewController {
    
    private let iconNames = ["Icon-App-A", "Icon-App-B", "Icon-App-C"]
    private let otherCellTexts = [("5秒後に通知を設定", "設定後、アプリを閉じてください"), ("Spotlightにサンプルを登録", nil)]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "アイコンを変える"
        case 1:
            return "その他"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        switch indexPath.section {
        case 0:
            let image = UIImage(named: iconNames[indexPath.row])
            cell.textLabel?.text = iconNames[indexPath.row]
            cell.imageView?.image = image
        case 1:
            cell.textLabel?.text = otherCellTexts[indexPath.row].0
            cell.detailTextLabel?.text = otherCellTexts[indexPath.row].1
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let identifier = iconNames[indexPath.row]
            if indexPath.row == 0 {
                UIApplication.shared.setAlternateIconName(nil, completionHandler: nil)
            } else {
                UIApplication.shared.setAlternateIconName(identifier, completionHandler: nil)
            }
        case 1:
            switch indexPath.row {
            case 0:
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.getNotificationSettings { settings in
                    let status = settings.authorizationStatus
                    switch status {
                    case .authorized:
                        self.setNotification()
                    case .denied:
                        break
                    case .notDetermined:
                        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                            if granted {
                                self.setNotification()
                            }
                        }
                    }
                }

            case 1:
                let spotlightTitle = "Kisekae spotlight sample"
                let spotlightDescription = "Kisekae アプリの検索結果サンプルです"
                
                let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeContent as String)
                attributeSet.title = spotlightTitle
                attributeSet.contentDescription = spotlightDescription
                attributeSet.keywords = [spotlightTitle, spotlightDescription]
                attributeSet.identifier = "1234"
                attributeSet.languages = ["ja", "en"]
                
                let domainIdentifier = "me.koga.alternate-icon-sample"
                let searchableItem = CSSearchableItem(uniqueIdentifier: attributeSet.identifier, domainIdentifier: domainIdentifier, attributeSet: attributeSet)
                
                let searchableIndex = CSSearchableIndex(name: "me.koga.alternate-icon-sample-searchable-index")
                
                searchableIndex.fetchLastClientState { (clientState, error) in
                    searchableIndex.beginBatch()
                    
                    searchableIndex.indexSearchableItems([searchableItem], completionHandler: nil)
                    
                    let clientState = NSKeyedArchiver.archivedData(withRootObject: NSDate())
                    searchableIndex.endBatch(withClientState: clientState, completionHandler: nil)
                }
            default:
                break
            }

        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Let's Kisekae!"
        content.body = "Notification Sample"
        content.sound = UNNotificationSound.default()

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request, withCompletionHandler: nil)
    }
}
