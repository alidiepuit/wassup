//
//  CheckInController.swift
//  wassup
//
//  Created by MAC on 8/23/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class ListCheckInController: FollowerController {

    
    
    override func loadData(ref: UIRefreshControl?) {
        if cate == ObjectType.Event {
            let md = Event()
            md.listCheckins(eventId) {
                (result: AnyObject?) in
                if result != nil {
                    if let d = result!["users"] as? [Dictionary<String,AnyObject>] {
                        self.data = d
                        self.tableView.reloadData()
                    }
                }
                if ref != nil {
                    ref?.endRefreshing()
                }
            }
        } else {
            let md = Host()
            md.listCheckins(eventId) {
                (result: AnyObject?) in
                if result != nil {
                    if let d = result!["users"] as? [Dictionary<String,AnyObject>] {
                        self.data = d
                        self.tableView.reloadData()
                    }
                }
                if ref != nil {
                    ref?.endRefreshing()
                }
            }
        }
    }
}
