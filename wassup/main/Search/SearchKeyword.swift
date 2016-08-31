//
//  FeedsController.swift
//  wassup
//
//  Created by MAC on 8/18/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class SearchKeyword: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var searchController: UISearchDisplayController!
    var searchText = ""
    var tabPage:TabPageViewController?
    let searchBar = UISearchBar()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], forState: UIControlState.Normal)
        
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.backgroundColor = UIColor.fromRgbHex(0x31ACF9)
        searchBar.tintColor = UIColor.whiteColor()
        searchBar.barTintColor = UIColor.fromRgbHex(0x90CEF6)
        searchBar.showsCancelButton = true
        searchBar.placeholder = Localization("Tìm kiếm")
        searchBar.setValue(Localization("Huỷ"), forKey: "_cancelButtonText")
        self.navigationItem.titleView = searchBar
        
        for view in searchBar.subviews {
            for v in view.subviews {
                if v is UIButton {
                    if let btn = v as? UIButton {
                        btn.setTitle(Localization("Huỷ"), forState: .Normal)
                    }
                }
                if v is UITextField {
                    if let btn = v as? UITextField {
                        btn.autocapitalizationType = .None
                    }
                }
            }
        }
        
        //don't show search bar on new context
        definesPresentationContext = true
        
        tabPage = TabPageViewController.create()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = storyboard.instantiateViewControllerWithIdentifier("SubSearchKeyword") as! SubSearchKeyword
        vc1.typeSearch = ObjectType.Tag
        
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("SubSearchKeyword") as! SubSearchKeyword
        vc2.typeSearch = ObjectType.Users
        
        let vc3 = storyboard.instantiateViewControllerWithIdentifier("SubSearchKeyword") as! SubSearchKeyword
        vc3.typeSearch = ObjectType.Event
        
        let vc4 = storyboard.instantiateViewControllerWithIdentifier("SubSearchKeyword") as! SubSearchKeyword
        vc4.typeSearch = ObjectType.Host
        
        let vc5 = storyboard.instantiateViewControllerWithIdentifier("SubSearchKeyword") as! SubSearchKeyword
        vc5.typeSearch = ObjectType.Article
        
        tabPage!.tabItems = [(vc1, Localization("Từ khoá")),
                             (vc2, Localization("User")),
                             (vc3, Localization("Sự kiện")),
                             (vc4, Localization("Địa điểm")),
                             (vc5, Localization("Blog"))]
        
        var option = TabPageOption()
        option.currentColor = UIColor.fromRgbHex(0x31ACF9)
        option.tabEqualizeWidth = true
        option.numberOfItem = 5
        tabPage!.option = option
        
        self.addChildViewController(tabPage!)
        tabPage!.view.frame = self.container.frame
        self.container.addSubview(tabPage!.view)
        insideView = container
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UISearchBar Delegate
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        NSNotificationCenter.defaultCenter().postNotificationName("LOAD_DATA_SEARCH", object: nil, userInfo: ["keyword": searchText])
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    
    func searchDisplayControllerWillBeginSearch(controller: UISearchDisplayController) {
        
    }
    
    //MARK: Table View Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellFeed", forIndexPath: indexPath)
        return cell
    }
}
