//
//  Date.swift
//  RTH
//
//  Created by SSG on 8/10/16.
//  Copyright © 2016 AliDiep. All rights reserved.
//

import UIKit

class Date: NSDate {
    
    static var sharedInstance = Date()
    
    var hour:String {
        return String(component.hour)
    }
    
    var minute:String {
        return String(component.minute)
    }
    
    var hm:String {
        let format = NSDateFormatter()
        format.dateFormat = "h:mm a"
        return format.stringFromDate(date)
    }
    
    var day:String {
        return String(component.day)
    }
    var weekDay:String {
        let format = NSDateFormatter()
        format.dateFormat = "eeee"
        return format.stringFromDate(date)
    }
    var month:String{
        let format = NSDateFormatter()
        format.dateFormat = "MM"
        return format.stringFromDate(date)
    }
    var year:String{
        return String(component.year)
    }
    var formatInput = NSDateFormatter()
    var formatOutput = NSDateFormatter()
    var component = NSDateComponents()
    var date = NSDate()
    
    override init() {
        super.init()
        configFormat()
    }
    
    func configFormat() {
        self.formatInput.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.formatOutput.dateFormat = "h:mm a"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func parseFromString(d: String) -> NSDate? {
        if let date = self.formatInput.dateFromString(d) {
            return parseFromDate(date)
        }
        return nil
    }
    
    func parseFromDate(d: NSDate) -> NSDate {
        date = d
        let calen = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        component = calen.components([.Hour, .Minute, .Day, .Month, .Year], fromDate: date)
        return date
    }
    
    func print(date: String?) -> String {
        if date == nil || date == "" {
            return "To be defined"
        }
        let d = self.formatInput.dateFromString(date!)
        let res = self.formatOutput.stringFromDate(d!)
        return res
    }
    
    func printDateToDate(from: String, to: String) -> String{
        let dateFrom = Date()
        guard (dateFrom.parseFromString(from) != nil) else {
            return "8:00AM - 8:00PM"
        }
        
        let dateTo = Date()
        guard dateTo.parseFromString(to) != nil else {
            return "8:00AM - 8:00PM"
        }
        
        var res = "\(dateFrom.hm) - \(dateTo.hm) | \(dateFrom.day) - \(dateTo.day)/\(dateTo.month)/\(dateTo.year)"
        if dateFrom.month != dateTo.month {
            res = "\(dateFrom.hm) - \(dateTo.hm) | \(dateFrom.day)/\(dateFrom.month)/\(dateFrom.year) - \(dateTo.day)/\(dateTo.month)/\(dateTo.year)"
        }
        return res
    }
    
    func printTimeOpen(from: String, to: String) -> String {
        let dateFrom = Date()
        guard (dateFrom.parseFromString(from) != nil) else {
            return "8:00AM - 8:00PM"
        }
        
        let dateTo = Date()
        guard dateTo.parseFromString(to) != nil else {
            return "8:00AM - 8:00PM"
        }
        
        let res = "\(dateFrom.hm) - \(dateTo.hm)"
        return res
    }
}
