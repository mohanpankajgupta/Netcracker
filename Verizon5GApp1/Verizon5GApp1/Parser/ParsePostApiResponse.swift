//
//  ParsePostApiResponse.swift
//  Verizon5GApp1
//
//  Created by Smita Tamboli on 11/06/18.
//  Copyright © 2018 netcracker. All rights reserved.
//

import Foundation

class ParsePostApiResponse {
    
    func parseResponse(response: [String: Any]) -> PostApiCall {
        let postApi = PostApiCall()
        
        if let statusCode = response["status_code"] as? Int {
            postApi.statusCode = statusCode
        }
        
        if let message = response["message"] as? String {
            postApi.message = message
        }
        
        guard let eventDetail = response["eventDetails"] as? [String: Any] else {
            return postApi
        }
        
        if let eventId = eventDetail["event_id"] as? String {
            postApi.eventId = eventId
        }
        
        if let eventSource = eventDetail["event_source"] as? String {
            postApi.eventSource = eventSource
        }
        
        if let eventType = eventDetail["event_type"] as? String {
            postApi.eventType = eventType
        }
        
        if let attributes = eventDetail["attributes"] as? [[String: Any]] {
            
            for attribute in attributes {
                
                let idAndValues = PostApiIdAndValues()
                
                if let id = attribute["id"] as? Int {
                    idAndValues.id = id
                }
                
                if let value = attribute["value"] as? String {
                    idAndValues.value = value
                }
                
                postApi.attributes?.append(idAndValues)
                
            }
            
        }
        
        return postApi
    }
    
}
