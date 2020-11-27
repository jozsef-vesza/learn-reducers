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
        value = value.map {
            return $0.name == item.name ?
                Item(name: item.name,
                              isFavourite: true,
                              isSelected: item.isSelected) :
                $0
        }
    case let .removeFromFavourites(item):
        removeFromFavourites(value: &value, item: item)
    case .deselect:
        removeSelection(value: &value)
    }
}

func favouritesReducer(value: inout [Item], action: FavouritesAction) -> Void {
    switch action {
    case let .removeFromFavourites(item):
        removeFromFavourites(value: &value, item: item)
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
    value = value.map {
        Item(name: $0.name,
                      isFavourite: $0.isFavourite,
                      isSelected: false)
    }
}

private func removeFromFavourites(value: inout [Item], item: Item) {
    value = value.map {
        return $0.name == item.name ?
            Item(name: item.name, isFavourite: false, isSelected: item.isSelected) :
            $0
    }
}
