//
//  Store.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 25..
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
    
    struct Item: Equatable {
        var name: String
        var isFavourite: Bool
        var isSelected: Bool
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.name == rhs.name
        }
    }
}

final class Store<Value, Action>: ObservableObject {
    let reducer: (inout Value, Action) -> Void
    
    @Published private(set) var value: Value
    
    init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.value = initialValue
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        reducer(&value, action)
    }
}
