//
//  DetailBlogController.swift
//  wassup
//
//  Created by MAC on 8/25/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class DetailBlogController: UIViewController, UIWebViewDelegate {
    
    var id = ""
    var activeLeft = false
    var activeRight = false
    
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var btnLeft: UIView!
    @IBOutlet weak var btnRight: UIView!
    @IBOutlet weak var icLeft: UIImageView!
    @IBOutlet weak var icRight: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cover: UIImageView!
    
    @IBOutlet weak var info: UILabel!
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var webviewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureJoin = UITapGestureRecognizer(target: self, action: #selector(clickLeft))
        btnLeft.addGestureRecognizer(gestureJoin)
        
        let gestureRight = UITapGestureRecognizer(target: self, action: #selector(clickRight))
        btnRight.addGestureRecognizer(gestureRight)
        
        btnLeft.corner(0, border: 1, colorBorder: 0xD1DBE9)
        btnRight.corner(0, border: 1, colorBorder: 0xD1DBE9)
        
        loadData()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func loadData() {
        let md = Search()
        md.eventDetailBlog(id){
            (result:AnyObject?) in
            if result != nil {
                guard let d = result!["article"] as? Dictionary<String, AnyObject> else {
                    return
                }
                var str = CONVERT_STRING(d["description"])
                
                str = Utils.HTMLImageCorrector(str)
                str = "<style>input[type=image]{width:\(UIScreen.mainScreen().bounds.size.width-20) !important;height: auto !important;} img{width:\(UIScreen.mainScreen().bounds.size.width-20) !important;height: auto !important;}</style><div style=\"width:\(self.webview.frame.size.width-20); word-wrap:break-word\">" + str + "</div>"
                self.webview.loadHTMLString(str, baseURL: NSURL(string:"http://dev.wassup.com.vn"))
                
                let isFollow = d["is_bookmark"] != nil ? CONVERT_BOOL(d["is_bookmark"]) : false
                if isFollow {
                    self.icLeft.image = UIImage(named: "ic_bookmark_enable")
                    self.activeLeft = true
                }
                
                let isCheckin = CONVERT_BOOL(d["is_like"])
                if isCheckin {
                    self.icRight.image = UIImage(named: "ic_love_enable")
                    self.activeRight = true
                }
                
                self.name.text = CONVERT_STRING(d["name"])
                let date = Date()
                let format = NSDateFormatter()
                format.dateFormat = "dd MMMM yyyy"
                date.formatOutput = format
                self.info.text = "\(date.print(CONVERT_STRING(d["created_at"]))) | \(CONVERT_STRING(d["author"]))"
                
                LazyImage.showForImageView(self.cover, url: CONVERT_STRING(d["image"]))
                
                self.title = CONVERT_STRING(d["name"])
            }
        }
    }

    @IBAction func clickLeft(sender: AnyObject) {
        activeLeft = !activeLeft
        if activeLeft {
            icLeft.image = UIImage(named: "ic_bookmark_enable")
        } else {
            icLeft.image = UIImage(named: "ic_bookmark")
        }
    }
    
    @IBAction func clickRight(sender: AnyObject) {
        activeRight = !activeRight
        if activeRight {
            icRight.image = UIImage(named: "ic_love_enable")
        } else {
            icRight.image = UIImage(named: "ic_love")
        }
        let md = User()
        md.likeBlog(id)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var observing = false
    var MyObservationContext = 0
    
    deinit {
        stopObservingHeight()
    }
    
    func startObservingHeight() {
        let options = NSKeyValueObservingOptions([.New])
        webview.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true;
    }
    
    func stopObservingHeight() {
        webview.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
        observing = false
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let keyPath = keyPath else {
            super.observeValueForKeyPath(nil, ofObject: object, change: change, context: context)
            return
        }
        switch (keyPath, context) {
        case("contentSize", &MyObservationContext):
            webviewHeightConstraint.constant = webview.scrollView.contentSize.height
        default:
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webviewHeightConstraint.constant = webView.scrollView.contentSize.height
        if (!observing) {
            startObservingHeight()
        }
        
        scroll.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, webview.frame.origin.y + webView.scrollView.contentSize.height)
        scroll.sizeToFit()
        scroll.layoutIfNeeded()
        scroll.setNeedsLayout()
    }
}
