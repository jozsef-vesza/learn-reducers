//
//  AppState.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 27..
//

import Foundation

struct AppState {
    var items: [Item]
    var selectedItem: Item? {
        return items.first { $0.isSelected }
    }
    
    var favourites: [Item] {
        return items.filter { $0.isFavourite }
    }
}
