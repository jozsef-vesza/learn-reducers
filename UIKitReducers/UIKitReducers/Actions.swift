//
//  Actions.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 26..
//

import Foundation

func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    
    return { value, action in
        for reducer in reducers {
            reducer(&value, action)
        }
    }
}

func pullback<LocalValue, GlobalValue, Action>(
    _ reducer: @escaping (inout LocalValue, Action) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>
) -> (inout GlobalValue, Action) -> Void {
    return { globalValue, action in
        reducer(&globalValue[keyPath: value], action)
    }
}

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

func menuReducer(value: inout [AppState.Item], action: AppAction) -> Void {
    switch action {
    case let .menu(.itemSelected(selectedIndex)):
        var items = value.map {
            return AppState.Item(name: $0.name,
                                 isFavourite: $0.isFavourite,
                                 isSelected: false)
        }
        items[selectedIndex].isSelected = true
        
        value = items
    default:
        break
    }
}

func menuItemReducer(value: inout [AppState.Item], action: AppAction) -> Void {
    switch action {
    case let .menuItem(.addToFavourites(item)):
        value = value.map {
            return $0.name == item.name ?
                AppState.Item(name: item.name, isFavourite: true, isSelected: item.isSelected) :
                $0
        }
    case let .menuItem(.removeFromFavourites(item)):
        removeFromFavourites(value: &value, item: item)
    default:
        break
    }
}

func favouritesReducer(value: inout [AppState.Item], action: AppAction) -> Void {
    switch action {
    case let .favourites(.removeFromFavourites(item)):
        removeFromFavourites(value: &value, item: item)
    default:
        break
    }
}

private func removeFromFavourites(value: inout [AppState.Item], item: AppState.Item) {
    value = value.map {
        return $0.name == item.name ?
            AppState.Item(name: item.name, isFavourite: false, isSelected: item.isSelected) :
            $0
    }
}
