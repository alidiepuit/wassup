//
//  MapSearchTagController.swift
//  wassup
//
//  Created by MAC on 9/9/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class MapSearchTagController: UIViewController {

    var searchController: UISearchDisplayController!
    var searchText = ""
    var tabPage:TabPageViewController?
    let searchBar = UISearchBar()
    var debounceTimer: NSTimer?
    var page = 1
    var listSelected = [TagView]()
    
    @IBOutlet weak var tagListView:TagListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBar = UIBarButtonItem(image: UIImage(named: "ic_back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = backBar
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.backgroundColor = UIColor.fromRgbHex(0x31ACF9)
        searchBar.tintColor = UIColor.whiteColor()
        searchBar.barTintColor = UIColor.fromRgbHex(0x90CEF6)
        searchBar.showsCancelButton = true
        searchBar.placeholder = Localization("Tìm kiếm")
        searchBar.setValue(Localization("Search"), forKey: "_cancelButtonText")
        self.navigationItem.titleView = searchBar
        
        for view in searchBar.subviews {
            for v in view.subviews {
                if v is UIButton {
                    if let btn = v as? UIButton {
                        btn.setTitle(Localization("Search"), forState: .Normal)
                    }
                }
                if v is UITextField {
                    if let btn = v as? UITextField {
                        btn.autocapitalizationType = .None
                        btn.becomeFirstResponder()
                    }
                }
            }
        }
        
        //don't show search bar on new context
        definesPresentationContext = true
        
        tagListView.delegate = self
        tagListView.textFont = UIFont(name: "Helvetica", size: 15)!
        
        callAPI()
    }
    
    func callAPI() {
        let md = TagsModel()
        md.getTags(searchText, index: page) {
            (result: AnyObject?) in
            self.tagListView.removeAllTags()
            var d = result!["tags"] as! [Dictionary<String,AnyObject>]
            for a in self.listSelected {
                d = d.filter() {
                    if let type = ($0 as Dictionary<String,AnyObject>)["id"] as? String {
                        return type != a.id
                    }
                    return true
                }
            }
            
            for a in self.listSelected {
                self.tagListView.addTag((a.titleLabel?.text)!, id: a.id, selected: true)
            }
            
            for a in d {
                self.tagListView.addTag(CONVERT_STRING(a["tag"]), id: CONVERT_STRING(a["id"]))
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension MapSearchTagController: TagListViewDelegate {
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        tagView.selected = !tagView.selected
        if tagView.selected {
            listSelected.append(tagView)
        } else {
            listSelected = listSelected.filter() {
                if let type = ($0 as TagView).id as? String {
                    return type != tagView.id
                }
                return true
            }
        }
    }
    
    func tagRemoveButtonPressed(title: String, tagView: TagView, sender: TagListView) {
        
    }

}

extension MapSearchTagController: UISearchBarDelegate, UISearchDisplayDelegate {
    func filterContentForSearchText() {
        callAPI()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.navigationController?.popViewControllerAnimated(true)
        NSNotificationCenter.defaultCenter().postNotificationName("SEARCH_MAP_WITH_TAG", object: nil, userInfo: ["tags": listSelected])
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if let timer = debounceTimer {
            timer.invalidate()
        }
        debounceTimer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(filterContentForSearchText), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(debounceTimer!, forMode: "NSDefaultRunLoopMode")
    }
}
