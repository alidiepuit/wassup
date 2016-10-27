//
//  FilterHost.swift
//  wassup
//
//  Created by MAC on 8/27/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class FilterHost: FilterEvent {

    override func commonInit() {
        contentView = self.loadViewFromNib("FilterHost")
        self.tbl?.registerNib(UINib(nibName: FilterCell.iden, bundle: nil), forCellReuseIdentifier: FilterCell.iden)
        contentView!.frame = self.bounds
        contentView!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(contentView!)
        
        self.initNotify()
    }
    
    override var dataTime: [CellDropdown] {
        return [CellDropdown(id: "8", value: Localization("Gần nhất")),
                CellDropdown(id: "1", value: Localization("Mới nhất")),
        ]
    }
    
    override func loadDistrict() {
        let md = Filter()
        md.getDistrict(self.cityId.value, objectType: ObjectType.Host) {
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
