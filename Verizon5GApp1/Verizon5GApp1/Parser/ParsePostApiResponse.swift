//
//  ParsePostApiResponse.swift
//  Verizon5GApp1
//
//  Created by Smita Tamboli on 11/06/18.
//  Copyright © 2018 netcracker. All rights reserved.
//

import Foundation

class ParsePostApiResponse {
    
    func parseResponse(response: [String: Any]) -> ServiceOrder {
        let serviceOrder = ServiceOrder()
        
        print(response)
        
        if let error = response["error"] as? [String: Any] {
            if let cause = error["cause"] as? String {
                serviceOrder.error = cause
            }
            if let description = error["description"] as? String {
                serviceOrder.description = description
            }
        }
        
        if let externalId = response["externalId"] as? String {
            serviceOrder.externalId = externalId
        }
        
        if let relatedParty = response["relatedParty"] as? [[String: Any]] {
            
            for dictionary in relatedParty {
                
                let relatedParty = RelatedParty()
                
                if let id = dictionary["id"] as? String {
                    relatedParty.id = id
                }
                
                if let name = dictionary["name"] as? String {
                    relatedParty.name = name
                }
                
                if let role = dictionary["role"] as? String {
                    relatedParty.role = role
                }
                
                serviceOrder.relatedParty?.append(relatedParty)
            }
            
        }
        
        if let orderItem = response["orderItem"] as? [[String: Any]] {
            
            for dictionary in orderItem {
                
                let orderItem = OrderItem()
                
                if let id = dictionary["id"] as? String {
                    orderItem.id = id
                }
                
                if let action = dictionary["action"] as? String {
                    orderItem.action = action
                }
                
                if let state = dictionary["state"] as? String {
                    orderItem.state = state
                }
                
                if let dictionary = dictionary["service"] as? [String: Any] {
                    let service = Service()
                    
                    if let id = dictionary["id"] as? String {
                        service.id = id
                    }
                    
                    if let serviceCharacteristics = dictionary["serviceCharacteristic"] as? [[String: Any]] {
                        
                        for dictionary in serviceCharacteristics {
                            
                            let serviceCharacterstic = ServiceCharacteristic()
                            if let name = dictionary["name"] as? String {
                                serviceCharacterstic.name = name
                            }
                            if let value = dictionary["value"] as? String {
                                serviceCharacterstic.value = value
                            }
                            
                            service.serviceCharacteristic?.append(serviceCharacterstic)
                        }
                    }
                }
                
                serviceOrder.orderItem?.append(orderItem)
            }
        }
        
        if let id = response["id"] as? String {
            serviceOrder.id = id
        }
        
        if let priority = response["priority"] as? String {
            serviceOrder.priority = priority
        }
        
        if let category = response["category"] as? String {
            serviceOrder.category = category
        }
        
        if let state = response["state"] as? String {
            serviceOrder.state = state
        }
        
        if let orderDate = response["orderDate"] as? String {
            serviceOrder.orderDate = orderDate
        }
        
        if let href = response["href"] as? String {
            serviceOrder.href = href
        }
        
        return serviceOrder
    }
    
}
