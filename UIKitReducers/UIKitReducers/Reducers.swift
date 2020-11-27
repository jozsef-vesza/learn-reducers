//
//  Reducers.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 27..
//

import Foundation

func menuReducer(value: inout [AppState.Item], action: MenuAction) -> Void {
    switch action {
    case let .itemSelected(selectedIndex):
        var items = value.map {
            return AppState.Item(name: $0.name,
                                 isFavourite: $0.isFavourite,
                                 isSelected: false)
        }
        items[selectedIndex].isSelected = true
        
        value = items
    }
}

func menuItemReducer(value: inout [AppState.Item], action: MenuItemAction) -> Void {
    switch action {
    case let .addToFavourites(item):
        value = value.map {
            return $0.name == item.name ?
                AppState.Item(name: item.name,
                              isFavourite: true,
                              isSelected: item.isSelected) :
                $0
        }
    case let .removeFromFavourites(item):
        removeFromFavourites(value: &value, item: item)
    case .deselect:
        value = value.map {
            AppState.Item(name: $0.name,
                          isFavourite: $0.isFavourite,
                          isSelected: false)
        }
    }
}

func favouritesReducer(value: inout [AppState.Item], action: FavouritesAction) -> Void {
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

private func removeFromFavourites(value: inout [AppState.Item], item: AppState.Item) {
    value = value.map {
        return $0.name == item.name ?
            AppState.Item(name: item.name, isFavourite: false, isSelected: item.isSelected) :
            $0
    }
}
