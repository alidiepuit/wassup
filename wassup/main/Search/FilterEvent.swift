//
//  FilterEvent.swift
//  wassup
//
//  Created by MAC on 8/26/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class FilterEvent: UIView {
    var contentView:UIView?
    // other outlets
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnCenter: UIButton!

    var cityId = CellDropdown(id: "24", value: "Hồ Chí Minh")
    
    var dataTime: [CellDropdown] {
        
        return [CellDropdown(id: "8", value:"Gần nhất"),
                    CellDropdown(id: "1", value:"Mới nhất"),
                    CellDropdown(id: "2", value:"Đang diễn ra"),
                    CellDropdown(id: "3", value:"Sắp diễn ra")
                    ]
    }
    
    var dataDistrict = [CellDropdown]()
    var dataRange = [CellDropdown(id: "", value:"Tất cả"),
                     CellDropdown(id: "4", value:"Hôm nay"),
                     CellDropdown(id: "5", value:"Ngày mai"),
                     CellDropdown(id: "6", value:"Trong tuần"),
                     CellDropdown(id: "7", value:"Trong tháng")
                    ]
    
    var selIndex = 0
    var selTime = "1"
    var selDistrict = ""
    var selRange = ""
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        contentView = self.loadViewFromNib("FilterEvent")
        self.tbl?.registerNib(UINib(nibName: FilterCell.iden, bundle: nil), forCellReuseIdentifier: FilterCell.iden)
        contentView!.frame = self.bounds
        contentView!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(contentView!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(resetFilterAfterSelectProvince(_:)), name: "REFRESH_FILTER_AFTER_SELECT_PROVINCE", object: nil)
    }
    
    @IBAction func clickBtnLeft(sender: AnyObject) {
        selIndex = 0
        btnLeft.backgroundColor = UIColor.fromRgbHex(0xAAAAAA)
        if btnCenter != nil {
            btnCenter.backgroundColor = UIColor.whiteColor()
        }
        if btnRight != nil {
            btnRight.backgroundColor = UIColor.whiteColor()
        }
        tbl.reloadData()
    }
    
    @IBAction func clickBtnCenter(sender: AnyObject) {
        selIndex = 1
        btnLeft.backgroundColor = UIColor.whiteColor()
        if btnCenter != nil {
            btnCenter.backgroundColor = UIColor.fromRgbHex(0xAAAAAA)
        }
        if btnRight != nil {
            btnRight.backgroundColor = UIColor.whiteColor()
        }
        loadDistrict()
    }
    
    @IBAction func clickBtnRight(sender: AnyObject) {
        selIndex = 2
        btnLeft.backgroundColor = UIColor.whiteColor()
        if btnCenter != nil {
            btnCenter.backgroundColor = UIColor.whiteColor()
        }
        if btnRight != nil {
            btnRight.backgroundColor = UIColor.fromRgbHex(0xAAAAAA)
        }
        tbl.reloadData()
    }
    
    @IBAction func clickCancel(sender: AnyObject) {
        self.removeFromSuperview()
        self.hidden = true
    }
    
    func activeFilter() {
        self.removeFromSuperview()
        self.hidden = true
        NSNotificationCenter.defaultCenter().postNotificationName("REFRESH_DATA_WITH_FILTER", object: nil,
                                                                  userInfo: ["time": selTime,
                                                                    "district": selDistrict,
                                                                    "range": selRange,
            ])
    }
    
    func resetData() {
        if btnCenter != nil {
            btnCenter.setTitle(cityId.value, forState: .Normal)
        }
        loadDistrict()
    }
    
    func resetFilterAfterSelectProvince(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String, String>
        cityId = CellDropdown(id: d["cityId"]!, value: d["cityName"]!)
        resetData()
    }
}

extension FilterEvent: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selIndex {
        case 0:
            return dataTime.count
        case 1:
            return dataDistrict.count
        case 2:
            return dataRange.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FilterCell.iden, forIndexPath: indexPath) as! FilterCell
        var selected = false
        switch selIndex {
        case 0:
            cell.title.text = dataTime[indexPath.row].value
            if selTime == dataTime[indexPath.row].id {
                selected = true
                btnLeft.setTitle(dataTime[indexPath.row].value, forState: .Normal)
            }
            break;
        case 1:
            cell.title.text = dataDistrict[indexPath.row].value
            if selDistrict == dataDistrict[indexPath.row].id {
                selected = true
                btnCenter.setTitle(dataDistrict[indexPath.row].value, forState: .Normal)
            }
            break;
        case 2:
            cell.title.text = dataRange[indexPath.row].value
            if selRange == dataRange[indexPath.row].id {
                selected = true
                btnRight.setTitle(dataRange[indexPath.row].value, forState: .Normal)
            }
            break;
        default:
            cell.title.text = ""
        }
        if selected {
            cell.backgroundColor = UIColor.grayColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch selIndex {
        case 0:
            selTime = dataTime[indexPath.row].id
            btnLeft.setTitle(dataTime[indexPath.row].value, forState: .Normal)
        case 1:
            selDistrict = dataDistrict[indexPath.row].id
            btnCenter.setTitle(dataDistrict[indexPath.row].value, forState: .Normal)
        case 2:
            selRange = dataRange[indexPath.row].id
            btnRight.setTitle(dataRange[indexPath.row].value, forState: .Normal)
        default:
            break;
        }
        
        self.activeFilter()
    }
}

extension FilterEvent {
    func loadDistrict() {
        let md = Filter()
        md.getDistrict(self.cityId.value, objectType: ObjectType.Event) {
            (result:AnyObject?) in
            if result != nil {
                if let d = result!["districts"] as? [Dictionary<String, String>] {
                    self.dataDistrict = [CellDropdown(id: "", value: Localization("Tất cả"))]
                    for b in d {
                        self.dataDistrict.append(CellDropdown(id: b["id"]!, value: b["name"]!))
                    }
                }
            }
            
            self.tbl?.reloadData()
        }
    }
}
