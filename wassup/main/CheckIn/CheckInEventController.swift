//
//  CheckInHostController.swift
//  wassup
//
//  Created by MAC on 9/1/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class CheckInEventController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tbl: UITableView!
    
    var data:[Dictionary<String,AnyObject>]!
    var debounceTimer:NSTimer!
    var page = 1
    var isLoading = false
    var typeSearch:ObjectType?
    var isFinish = false
    var ref = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.addTarget(self, action: #selector(refreshData(_:)), forControlEvents: .ValueChanged)
        tbl.addSubview(ref)
        
        data = [Dictionary<String, AnyObject>]()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshData(ref: UIRefreshControl) {
        page = 1
        data.removeAll()
        loadData()
    }
    
    func loadData() {
        let md = Search()
        if typeSearch == ObjectType.Event {
            md.events(0, index: page, keyword: GLOBAL_KEYWORD, action: "8", districtId: "", city: "", callback: callAPI)
        } else {
            md.hosts(0, index: page, keyword: GLOBAL_KEYWORD, action: "8", districtId: "", city: "", callback: callAPI)
        }
    }
    
    func callAPI(result: AnyObject?) {
        if result != nil {
            if let d = result!["objects"] as? [Dictionary<String,AnyObject>] {
                if d.count <= 0 {
                    self.isFinish = true
                }
                for ele:Dictionary<String,AnyObject> in d {
                    self.data.append(ele)
                }
                self.tbl.reloadData()
            }
        }
        self.isLoading = false
        self.ref.endRefreshing()
    }
}

extension CheckInEventController: UISearchBarDelegate, UISearchDisplayDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        GLOBAL_KEYWORD = text
        if let timer = debounceTimer {
            timer.invalidate()
        }
        debounceTimer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(filterContentForSearchText), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(debounceTimer!, forMode: "NSDefaultRunLoopMode")
    }
    
    func filterContentForSearchText() {
        page = 1
        data.removeAll()
        loadData()
    }
}

extension CheckInEventController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellEvent", forIndexPath: indexPath) as! CellEvent
        let d:Dictionary<String,AnyObject> = self.data[indexPath.row]
        LazyImage.showForImageView(cell.avatar, url: CONVERT_STRING(d["image"]))
        cell.name.text = CONVERT_STRING(d["name"])
        
        cell.address.text = ""
        cell.address.text = CONVERT_STRING(d["location"])
        
        cell.time.text = ""
        if self.typeSearch == ObjectType.Event {
            cell.time.text = Date().printDateToDate(CONVERT_STRING(d["starttime"]), to: CONVERT_STRING(d["endtime"]))
        }
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !isFinish && !isLoading && indexPath.row == (data?.count)!-1 {
            page+=1
            isLoading = true
            loadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailCheckIn" {
            
        }
    }
}
