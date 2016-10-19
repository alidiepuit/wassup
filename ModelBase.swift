//
//  ModelBase.swift
//  App568Play
//
//  Created by SSG on 4/25/16.
//  Copyright © 2016 Ramotion. All rights reserved.
//

import Foundation

var API: String {return "https://wassup.vn/app/api/"}

public class ModelBase: NSObject{
    func getIndex(page: Int) -> String {
        var idx = 0
        if page <= 1 {
            idx = 0
        } else {
            idx = (page-1)*10
        }
        return String(idx)
    }
    
    func getSeed() -> String{
        let ran = arc4random_uniform(9999) + 1;
        return String(ran)
    }
    
    public func callAPI(method: String, module: String, params:Dictionary<String, String>?, callback: ServiceResponse?) {
        let api = API + module
        let connector:Connector = Connector()
        connector.callService(method, serviceURL: api, params: params, callback: callback)
    }
    
    public func callAPI(module: String, params:Dictionary<String, AnyObject>?, callback: ServiceResponse?) {
        let api = API + module
        let connector:Connector = Connector()
        connector.callService(api, params: params, callback: callback)
    }
}
