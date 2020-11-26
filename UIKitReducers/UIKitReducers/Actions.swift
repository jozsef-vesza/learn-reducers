//
//  Actions.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 26..
//

import Foundation

enum AppAction {
    case menu(MenuAction)
    case menuItem(MenuItemAction)
    case favourites(FavouritesAction)
}

enum MenuAction {
    case itemSelected(Int)
}

enum MenuItemAction {
    case addToFavourites(AppState.Item)
    case removeFromFavourites(AppState.Item)
}

enum FavouritesAction {
    case removeFromFavourites(AppState.Item)
}

func appReducer(value: inout AppState, action: AppAction) -> Void {
    switch action {
    case let .menu(.itemSelected(selectedIndex)):
        var items = value.items.map {
            return AppState.Item(name: $0.name,
                                 isFavourite: $0.isFavourite,
                                 isSelected: false)
        }
        items[selectedIndex].isSelected = true
        
        value.items = items
    case let .menuItem(.addToFavourites(item)):
        value.items = value.items.map {
            return $0.name == item.name ?
                AppState.Item(name: item.name, isFavourite: true, isSelected: item.isSelected) :
                $0
        }
    case let .menuItem(.removeFromFavourites(item)):
        removeFromFavourites(value: &value, item: item)
    case let .favourites(.removeFromFavourites(item)):
        removeFromFavourites(value: &value, item: item)
    }
}

private func removeFromFavourites(value: inout AppState, item: AppState.Item) {
    value.items = value.items.map {
        return $0.name == item.name ?
            AppState.Item(name: item.name, isFavourite: false, isSelected: item.isSelected) :
            $0
    }
}
