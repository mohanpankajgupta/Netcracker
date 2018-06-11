//
//  Utility.swift
//  Verizon5GApp1
//
//  Created by Smita Tamboli on 08/06/18.
//  Copyright © 2018 netcracker. All rights reserved.
//

import Foundation

typealias CallbackBlock = (_ result: Any?, _ response:URLResponse?, _ error: NSError?) -> Void
let postApiUrl = "http://10.250.10.132:8091/api/rating/v2/events/submit"

class Utility {
    //MARK: Private variables
    private static let formatter = DateFormatter()
    
    private static func configureDateFormatter() {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    static func date(from string: String) -> Date? {
        configureDateFormatter()
        let date = formatter.date(from: string)
        
        return date
    }
    
    static func date(from date: Date) -> String? {
        configureDateFormatter()
        let date = formatter.string(from: date)
        
        return date
    }
}
