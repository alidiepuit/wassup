//
//  ListCollectionController.swift
//  wassup
//
//  Created by MAC on 9/13/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class ListCollectionController: UIViewController {

    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCollection: UIButton!
    
    var userId = ""
    let marginTop = CGFloat(8)
    var typeListCollection = "save"
    var data:[Dictionary<String,AnyObject>]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if typeListCollection == "list" {
            constraintTop.constant = 45 + marginTop
        }
        data = [Dictionary<String,AnyObject>]()
    }
    
    override func viewDidAppear(animated: Bool) {
        data.removeAll()
        tableView.reloadData()
        callAPI()
    }
    
    func callAPI() {
        let md = Collection()
        if typeListCollection == "save" {
            md.getMyCollections(handleData)
        } else {
            md.getCollections(userId, callback: handleData)
        }
    }
    
    func handleData(result:AnyObject?) {
        let data = result!["collections"] as! [Dictionary<String,AnyObject>]
        for a:Dictionary<String,AnyObject> in data {
            self.data.append(a)
            let lastIndexPath = NSIndexPath(forRow: self.data.count - 1, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([lastIndexPath], withRowAnimation: .None)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickCreateCollection(sender: AnyObject) {
        performSegueWithIdentifier("CreateCollection", sender: nil)
    }
    
    @IBAction func clickSaveCollection(sender: AnyObject) {
        
    }
    
    @IBAction func goBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}

extension ListCollectionController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellListCollection
        cell.initData(data[indexPath.row])
        return cell
    }
}
