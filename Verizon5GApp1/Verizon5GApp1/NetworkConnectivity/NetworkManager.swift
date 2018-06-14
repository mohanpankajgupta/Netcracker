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
        
        
        var locationArray = [String]()
        
        if let locationString = headerBody["location"] as? String {
            locationArray = Utility.seprateString(string: locationString)
        }
        
        let parameterDictionary = ["relatedParty":
            [
                [
                "role": "customer",
                "id": "\(headerBody["customer"] ?? "")"
                ]
            ],
            "orderItem":
                [
                    ["action" : "modify",
                    "id" : "1",
                    "service":
                        ["id" : "\(headerBody["service"] ?? "")",
                        "serviceCharacteristic": [
                            ["name": "location",
                             "value":locationArray]
                            ]]]]] as [String: Any]
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        print(httpBody)
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
