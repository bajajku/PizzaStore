//
//  PizzaModel.swift
//  PizzaStore
//
//  Created by Kunal Bajaj on 2025-01-28.
//

import Foundation

struct Pizza: Identifiable, Decodable, Encodable {
    let id: Int
    let name: String
    let image: String
}
    
