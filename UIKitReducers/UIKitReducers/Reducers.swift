//
//  Reducers.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 27..
//

import Foundation

func menuReducer(value: inout [Item], action: MenuAction) -> Void {
    switch action {
    case let .itemSelected(selectedIndex):
        removeSelection(value: &value)
        value[selectedIndex].isSelected = true
    }
}

func menuItemReducer(value: inout [Item], action: MenuItemAction) -> Void {
    switch action {
    case let .addToFavourites(item):
        toggleFavourite(value: &value, item: item, isFavourite: true)
    case let .removeFromFavourites(item):
        toggleFavourite(value: &value, item: item, isFavourite: false)
    case .deselect:
        removeSelection(value: &value)
    }
}

func favouritesReducer(value: inout [Item], action: FavouritesAction) -> Void {
    switch action {
    case let .removeFromFavourites(item):
        toggleFavourite(value: &value, item: item, isFavourite: false)
    }
}

func logging(
    _ reducer: @escaping (inout AppState, AppAction) -> Void
) -> (inout AppState, AppAction) -> Void {
    return { value, action in
        reducer(&value, action)
        print("Action: \(action)")
        print("State:")
        dump(value)
        print("---")
    }
}

private func removeSelection(value: inout [Item]) {
    for var item in value {
        if item.isSelected { item.isSelected = false }
    }
}

private func toggleFavourite(value: inout [Item], item: Item, isFavourite: Bool) {
    for (index, storedItem) in value.enumerated() {
        if storedItem == item {
            value[index].isFavourite = isFavourite
        }
    }
}
