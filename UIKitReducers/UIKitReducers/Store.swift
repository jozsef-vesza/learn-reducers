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

final class Store: ObservableObject {
    @Published private(set) var value: AppState
    
    init(initialValue: AppState) {
        self.value = initialValue
    }
    
    func addToFavourites(_ item: AppState.Item) {
        value.items = value.items.map {
            return $0.name == item.name ?
                AppState.Item(name: item.name, isFavourite: true, isSelected: item.isSelected) :
                $0
        }
    }
    
    func removeFromFavourites(_ item: AppState.Item) {
        value.items = value.items.map {
            return $0.name == item.name ?
                AppState.Item(name: item.name, isFavourite: false, isSelected: item.isSelected) :
                $0
        }
    }
    
    func selectItem(_ item: AppState.Item) {
        clearSelection()
        value.items = value.items.map {
            return $0.name == item.name ?
                AppState.Item(name: item.name, isFavourite: item.isFavourite, isSelected: true) :
                $0
        }
    }
    
    func clearSelection() {
        guard let item = value.selectedItem else { return }
        value.items = value.items.map {
            return $0.name == item.name ?
                AppState.Item(name: item.name, isFavourite: item.isFavourite, isSelected: false) :
                $0
        }
    }
}
