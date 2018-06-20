//
//  NetworkManager.swift
//  Verizon5GApp1
//
//  Created by Smita Tamboli on 11/06/18.
//  Copyright © 2018 netcracker. All rights reserved.
//

import Foundation

class NetworkManager {
    private let session = URLSession(configuration: .default)
    
    //MARK: Public method
    func makePostRequest(urlString: String, headerBody: [String: Any], completion: @escaping CallbackBlock) {
        
        let url = URL(string: urlString)
        
        var urlRequest = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        let defaultDate = Utility.date(from: Date())
        
        let parameterDictionary = ["event_id": "VZW5G0599",
         "check_duplicate": false,
         "rejected_count": "0",
         "credit_check": false,
         "reverse_rate": true,
         "event_source": "\(headerBody["event_source"] ?? "99910001000")",
         "event_type": "1000013",
         "event_date": "\(defaultDate ?? "")",
         "domain_id": "1",
         "attributes":[
            ["id": 1,
            "name": "Location",
            "value": "\(headerBody["Location"] ?? "")"],
            ["id": 2,
            "name": "SponsorID",
            "value": "\(headerBody["SponsorID"] ?? "")"],
            ["id": 3,
              "name": "SliceID",
              "value": "\(headerBody["SliceID"] ?? "")"],
            ["id": 4,
              "name": "Latency",
              "value": "\(headerBody["Latency"] ?? "")"],
            ["id": 5,
              "name": "Usage, KB",
              "value": "\(headerBody["Usage, KB"] ?? "")"],
            ["id": 12,
                "name": "attr12",
                "value": "1275040370"],
            ["id": 24,
             "name": "attr24",
             "value": "(service_specific)"]]
            ] as [String : Any]
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        urlRequest.httpBody = httpBody
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                
                completion(nil, response, error as NSError?)
                
            } else {
                
                do {
                    
                    let result = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    let parsePostApiData = ParsePostApiResponse()
                    let postApiResult = parsePostApiData.parseResponse(response: result as! [String: Any])
                    
                    completion(postApiResult, response, nil)
                    
                } catch let error as NSError {
                    completion(nil, response, error as NSError?)
                }
                
            }
        }
        
        task.resume()
        
    }
}
