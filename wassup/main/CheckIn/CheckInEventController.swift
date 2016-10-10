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
        tbl.reloadData()
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
                    let indexPath = NSIndexPath(forRow: self.data.count - 1, inSection: 0)
                    self.tbl.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
            }
        }
        self.isLoading = false
        self.ref.endRefreshing()
    }
    
    @IBAction func saveComment(sender: UIStoryboardSegue) {
        if let vc = sender.sourceViewController as? CommentController, data = vc.saveData {
            let arrImage = data["arrImage"] as! [UIImage]
            let description = CONVERT_STRING(data["description"])
            let md = User()
            md.checkin(typeSearch!, id: CONVERT_STRING(data["id"]), description: description, images: arrImage, callback: nil)
        }
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
        Utils.loadImage(cell.avatar, link: CONVERT_STRING(d["image"]))
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("DetailCheckIn", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailCheckIn" {
            let navi = segue.destinationViewController as! UINavigationController
            let vc = navi.topViewController as! CommentController
            let row = self.tbl.indexPathForSelectedRow!.row
            let d = self.data[row]
            vc.data = d
            vc.cate = typeSearch!
            vc.cateView = ObjectType.Checkin
        }
    }
}
