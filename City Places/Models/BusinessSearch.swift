//
//  BusinessSearch.swift
//  City Places
//
//  Created by Juan Hernandez Pazos on 02/08/22.
//

import Foundation

struct BusinessSearch: Decodable {
    
    var businesses = [Business]()
    var total = 0
    var region = Region()
}

struct Region: Decodable {
    var center = Coordinate()
}
