//
//  CheckInCollectionCell.swift
//  wassup
//
//  Created by MAC on 9/1/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class CheckInCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var searchBar: UITextField!
    
    var debounceTimer:NSTimer?
    var step = 0
    var data:[Dictionary<String,String>]!
    var selectedTag:TagView!
    var listSelectedTag:[TagView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagListView.delegate = self
        tagListView.textFont = UIFont(name: "Helvetica", size: 15)!
        
        searchBar.corner(20, border: 1, colorBorder: 0xDFE6EC)
        searchBar.intentLeft(20)
        searchBar.addTarget(self, action: #selector(beginSearching), forControlEvents: .EditingChanged)
        
        self.data = [Dictionary<String,String>]()
        self.listSelectedTag = [TagView]()
    }
    
    func initData(step: Int) {
        self.step = step
        loadData()
    }
    
    func beginSearching() {
        let keyword = searchBar.text!
        GLOBAL_KEYWORD = keyword.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        print(GLOBAL_KEYWORD)
        if let timer = debounceTimer {
            timer.invalidate()
        }
        debounceTimer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(filterContentForSearchText), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(debounceTimer!, forMode: "NSDefaultRunLoopMode")
    }

    func filterContentForSearchText() {
        loadData()
    }
    
    func loadData() {
        let md = Search()
        md.getTagsEachStepCheckIn(step, keyword: GLOBAL_KEYWORD) {
            (result:AnyObject?) in
            if result != nil {
                if let d = result!["tags"] as? [Dictionary<String,String>] {
                    self.data = d
                }
                self.loadTags()
            }
        }
    }
    
    func loadTags() {
        self.tagListView.removeAllTags()
        for tag:Dictionary<String,String> in self.data! {
            self.tagListView.addTag(tag["tag"]!, id: tag["id"]!)
        }
    }
}

extension CheckInCollectionCell: UITextFieldDelegate {
    
}

extension CheckInCollectionCell: TagListViewDelegate {
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        if step == 0 {
            if self.selectedTag == nil {
                self.selectedTag = tagView
                tagView.selected = true
            } else {
                if self.selectedTag != tagView {
                    self.selectedTag.selected = false
                    tagView.selected = true
                    self.selectedTag = tagView
                }
            }
        } else {
            tagView.selected = !tagView.selected
            if tagView.selected {
                self.listSelectedTag.append(tagView)
            } else {
                self.listSelectedTag = self.listSelectedTag.filter() { $0 == tagView }
            }
        }
    }
    
    func tagRemoveButtonPressed(title: String, tagView: TagView, sender: TagListView) {
        
    }

}