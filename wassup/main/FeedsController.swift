//
//  FeedsController.swift
//  wassup
//
//  Created by MAC on 8/18/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class FeedsController: UITableViewController {
    
    var page = 2
    var data:[Dictionary<String, AnyObject>]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = [Dictionary<String, AnyObject>]()
        callAPI()
        
        tableView.registerNib(UINib(nibName: "CellFeed", bundle: nil), forCellReuseIdentifier: "CellFeed")
    }
    
    func callAPI() {
        let md = Feeds()
        md.getFeeds(index: page) {
            (result: AnyObject?) in
            if result != nil {
                if let d = result!["activities"] as? [Dictionary<String,AnyObject>] {
                    for a in d {
                        let item = a["item"] as! Dictionary<String,AnyObject>
                        let objectId = item["id"]
                        if CONVERT_STRING(objectId) != "" {
                            self.data?.append(a)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table View Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellFeed", forIndexPath: indexPath) as! CellFeed
        
        let d:Dictionary<String,AnyObject> = data![indexPath.row]
        cell.initCell(d)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let d:Dictionary<String,AnyObject> = data![indexPath.row]
        let item = d["item"] as! Dictionary<String,AnyObject>
        let comment = CONVERT_STRING(item["comment"])
        let heiComment = comment.heightWithConstrainedWidth(tableView.frame.size.width-30, font: UIFont(name: "Helvetica", size: 14)!)
        let heiLocation = CONVERT_STRING(item["location"]) != "" ? 56 : 0
        
        var heiListTag = 0
        if let feelings = item["feelings"] as? Dictionary<String,AnyObject> {
            if let _ = feelings["3"] as? [Dictionary<String,String>] {
                let listTags = feelings["3"] as! [Dictionary<String,String>]
                let viewlistTags = TagListView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width - 80, height: 53))
                viewlistTags.paddingY = 10
                viewlistTags.paddingY = 15
                viewlistTags.marginY = 10
                viewlistTags.marginX = 10
                viewlistTags.removeAllTags()
                viewlistTags.cornerRadius = 15
                viewlistTags.borderWidth = 2
                for tag:Dictionary<String,String> in listTags {
                    viewlistTags.addTag(tag["text_feeling"]!, id: tag["id"]!)
                }
                heiListTag = 45 * viewlistTags.rows
            }
        }
        
        return heiComment + CGFloat(heiLocation) + CGFloat(heiListTag) + 320;
    }
}
