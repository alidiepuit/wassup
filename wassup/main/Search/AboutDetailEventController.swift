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
    var disappear = false
    override var sectionHasData: Int {
        return 1
    }
    override var canClickCell:Bool {
        return false
    }
    override var showCover:Bool {
        return false
    }
    var contentHeight = CGFloat(0)
    
    var images = [SKPhoto]()
    var browser = SKPhotoBrowser()
    private var lastContentOffset: CGFloat = 0
    var message:GSMessage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inset = UIEdgeInsetsMake(45, 0, 0, 0)
        tableView.contentInset = inset;
        
        tableView.registerNib(UINib(nibName: "DetailEvent", bundle: nil), forCellReuseIdentifier: "DetailEvent")
        
        loadDetail()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(resizeHeightHeader(_:)), name: "RESIZE_HEIGHT_HEADER_DETAIL_EVENT", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showBrowserImage(_:)), name: "SHOW_BROWSER_IMAGE", object: nil)
        
        message = GSMessage(text: Localization("Hãy để lại ấn tượng của bạn!"), type: .Success, options: [
            .Animation(.Slide),
            .AnimationDuration(0.3),
            .AutoHide(false),
            .AutoHideDelay(3.0),
            .Height(44.0),
            .HideOnTap(true),
            .Position(.Bottom),
            .TextAlignment(.Center),
            .TextColor(UIColor.whiteColor()),
            .TextNumberOfLines(1),
            .TextPadding(30.0)
            ], inView: self.view, inViewController: self, delegate: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        disappear = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        disappear = true
        NSNotificationCenter.defaultCenter().removeObserver(self)
        message.hide()
    }
    
    func showBrowserImage(noti:NSNotification) {
        let d = noti.userInfo as! Dictionary<String,AnyObject>
        browser.initializePageIndex(CONVERT_INT(d["index"]))
        Utils.presentViewController(browser, animated: true, completion: nil)
    }
    
    func resizeHeightHeader(noti: NSNotification) {
        if contentHeight == 0 {
            let d = noti.userInfo as! Dictionary<String,CGFloat>
            contentHeight = d["height"]!
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
            var hei = CGFloat(620)
            
            let listImage = self.detail["photos"] != nil ? self.detail["photos"] as! Array<String> : []
            if listImage.count > 0 {
                hei += 140
            }
            
            var heiListTag = CGFloat(0)
            if let listTags = self.detail["tags"] as? [Dictionary<String,String>] {
                let viewlistTags = TagListView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width - 30, height: 53))
                viewlistTags.paddingY = 10
                viewlistTags.paddingX = 15
                viewlistTags.marginY = 10
                viewlistTags.marginX = 10
                viewlistTags.removeAllTags()
                viewlistTags.cornerRadius = 15
                viewlistTags.borderWidth = 2
                for tag:Dictionary<String,String> in listTags {
                    viewlistTags.addTag(tag["tag"]!, id: tag["tag_id"]!)
                }
                heiListTag = viewlistTags.intrinsicContentSize().height
                hei += heiListTag
            }
            
            if contentHeight == 0 {
                return hei
            }
            return hei + contentHeight
        }
        return 0
    }
    
    @IBAction override func unwind(sender: UIStoryboardSegue) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension AboutDetailEventController {

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        guard message != nil else {
            return
        }
        do {
            
            if disappear {
                message.hide()
                return
            }
            
            if (self.lastContentOffset > scrollView.contentOffset.y) {
                // move up
                try message.show()
            }
            else if (self.lastContentOffset < scrollView.contentOffset.y) {
                // move down
                message.hide()
            }
            
        }
        catch {
            
        }
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        do {
            let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
            if (bottomEdge >= scrollView.contentSize.height) {
                message.hide()
            } else if !disappear {
                try message.show()
            }
        }
        catch {
            
        }
    }
}


extension AboutDetailEventController {
    override func didTapMessage() {
        NSNotificationCenter.defaultCenter().postNotificationName("COMMENT_FROM_DETAIL", object: nil)
    }
}

