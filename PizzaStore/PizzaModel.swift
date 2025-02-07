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
    
struct CartItem: Identifiable, Decodable, Encodable {
    let id: Int
    let pizzaId: Int
    let quantity: Int
    
    let pizza: Pizza?
    
}
