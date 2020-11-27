//
//  Model.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 27..
//

import Foundation

struct Item: Equatable {
    var name: String
    var isFavourite: Bool
    var isSelected: Bool
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}
