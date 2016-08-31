//
//  FeedsController.swift
//  wassup
//
//  Created by MAC on 8/18/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class FeedsController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var candies = [Candy]()
    
    var searchController: UISearchDisplayController!
    
    var filteredCandies = [Candy]()
    
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = CustomSearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 50), font: UIFont(name: "Futura", size: 14)!, textColor: UIColor.whiteColor())
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.backgroundColor = UIColor.fromRgbHex(0x3F9CF3)
        searchBar.tintColor = UIColor.whiteColor()
        searchBar.barTintColor = UIColor.fromRgbHex(0x3F9CF3)
        searchBar.showsCancelButton = true
        tableView.tableHeaderView = searchBar
        
        //don't show search bar on new context
        definesPresentationContext = true
        
        searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
        searchController.searchResultsDataSource = self
        searchController.searchResultsDelegate = self
        searchController.searchResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellFeed")
        searchController.displaysSearchBarInNavigationBar = true
        
//        self.navigationItem.titleView = searchController.searchBar
        
        candies = [
            Candy(category:"Chocolate", name:"Chocolate Bar"),
            Candy(category:"Chocolate", name:"Chocolate Chip"),
            Candy(category:"Chocolate", name:"Dark Chocolate"),
            Candy(category:"Hard", name:"Lollipop"),
            Candy(category:"Hard", name:"Candy Cane"),
            Candy(category:"Hard", name:"Jaw Breaker"),
            Candy(category:"Other", name:"Caramel"),
            Candy(category:"Other", name:"Sour Chew"),
            Candy(category:"Other", name:"Gummi Bear")
        ]
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UISearchBar Delegate
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCandies = candies.filter { candy in
            return candy.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.filterContentForSearchText(searchText)
    }
    
    //MARK: Table View Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController != nil && searchController.active && searchText != "" {
            return filteredCandies.count
        }
        return candies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellFeed", forIndexPath: indexPath)
        let candy: Candy
        if searchController.active && searchText != "" {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        cell.textLabel?.text = candy.name
        cell.detailTextLabel?.text = candy.category
        return cell
    }
}