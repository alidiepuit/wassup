//
//  DetailEventController.swift
//  wassup
//
//  Created by MAC on 8/22/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class AboutDetailEventController: FeedsController {

    var detail:Dictionary<String,AnyObject>!
    var cate = ObjectType.Event
    var id = ""
    override var sectionHasData: Int {
        return 1
    }
    var headerHeight = CGFloat(0)
    
    var images = [SKPhoto]()
    var browser = SKPhotoBrowser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inset = UIEdgeInsetsMake(45, 0, 0, 0)
        tableView.contentInset = inset;
        
        tableView.registerNib(UINib(nibName: "DetailEvent", bundle: nil), forCellReuseIdentifier: "DetailEvent")
        
        loadDetail()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(resizeHeightHeader(_:)), name: "RESIZE_HEIGHT_HEADER_DETAIL_EVENT", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showBrowserImage(_:)), name: "SHOW_BROWSER_IMAGE", object: nil)
    }
    
    func showBrowserImage(noti:NSNotification) {
        let d = noti.userInfo as! Dictionary<String,AnyObject>
        browser.initializePageIndex(CONVERT_INT(d["index"]))
        presentViewController(browser, animated: true, completion: nil)
    }
    
    func resizeHeightHeader(noti: NSNotification) {
        if headerHeight == 0 {
            let d = noti.userInfo as! Dictionary<String,CGFloat>
            headerHeight = d["height"]!
            tableView.reloadData()
        }
    }
    
    func loadDetail() {
        let md = Search()
        if cate == ObjectType.Event {
            md.getDetailEvent(self.id) {
                (result:AnyObject?) in
                if result != nil {
                    guard let d = result!["event"] as? Dictionary<String, AnyObject> else {
                        return
                    }
                    self.detail = d
                    self.tableView.reloadData()
                }
                self.ref.endRefreshing()
                self.loadBrowserImage()
            }
        } else {
            md.getDetailHost(self.id) {
                (result:AnyObject?) in
                if result != nil {
                    guard let d = result!["host"] as? Dictionary<String, AnyObject> else {
                        return
                    }
                    self.detail = d
                    self.tableView.reloadData()
                }
                self.ref.endRefreshing()
                self.loadBrowserImage()
            }
        }
    }
    
    func loadBrowserImage() {
        images.removeAll()
        if let d = detail["photos"] as? [String] {
            for a in d {
                let photo = SKPhoto.photoWithImageURL(a)
                images.append(photo)
            }
        }
        if images.count > 0 {
            browser = SKPhotoBrowser(photos: images)
        }
    }
    
    override func callAPI() {
        let md = Feeds()
        if cate == ObjectType.Event {
            md.listEventFeeds(self.id, index: page, top: 0, callback: self.handleData)
        } else {
            md.listHostFeeds(self.id, index: page, top: 0, callback: self.handleData)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && self.detail != nil {
            let  headerCell = tableView.dequeueReusableCellWithIdentifier("DetailEvent") as! DetailEvent
            headerCell.cate = cate
            headerCell.initData(self.detail!)
            return headerCell
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 && self.detail != nil {
            var hei = CGFloat(750)
            
            let listImage = self.detail["photos"] != nil ? self.detail["photos"] as! Array<String> : []
            if listImage.count <= 0 {
                hei -= 130
            }
            
            if headerHeight == 0 {
                do {
                    let str = CONVERT_STRING(self.detail!["description"])
                    let attr = try NSAttributedString(data: str.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                        NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding,
                        NSFontAttributeName: UIFont(name: "Helvetica", size: 15)!], documentAttributes: nil)
                    let hei = attr.heightWithConstrainedWidth(tableView.frame.size.width-16)
                    return hei+hei
                } catch {
                    return hei
                }
            }
            return hei+headerHeight
        }
        return 0
    }
}
