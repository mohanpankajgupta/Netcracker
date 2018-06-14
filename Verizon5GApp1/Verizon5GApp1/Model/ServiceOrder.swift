//
//  ServiceOrder.swift
//  Verizon5GApp1
//
//  Created by Smita Tamboli on 13/06/18.
//  Copyright © 2018 netcracker. All rights reserved.
//

import Foundation

class ServiceOrder {
    var externalId: String?
    var relatedParty:[RelatedParty]?
    var orderItem: [OrderItem]?
    var state: String?
    var id: String?
    var priority: String?
    var category: String?
    var orderDate: String?
    var href: String?
    var error: String?
    var description: String?
}
