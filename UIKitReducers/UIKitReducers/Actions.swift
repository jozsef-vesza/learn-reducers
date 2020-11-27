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

func pullback<GlobalValue, LocalValue, GlobalAction, LocalAction>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
    
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else {
            return
        }
        reducer(&globalValue[keyPath: value], localAction)
    }
}

enum AppAction {
    case menu(MenuAction)
    case menuItem(MenuItemAction)
    case favourites(FavouritesAction)
    
    var menu: MenuAction? {
        get {
            guard case let .menu(value) = self else { return nil }
            return value
        }
        set {
            guard case .menu = self, let newValue = newValue else { return }
            self = .menu(newValue)
        }
    }
    
    var menuItem: MenuItemAction? {
        get {
            guard case let .menuItem(value) = self else { return nil }
            return value
        }
        set {
            guard case .menuItem = self, let newValue = newValue else { return }
            self = .menuItem(newValue)
        }
    }
    
    var favourites: FavouritesAction? {
        get {
            guard case let .favourites(value) = self else { return nil }
            return value
        }
        set {
            guard case .favourites = self, let newValue = newValue else { return }
            self = .favourites(newValue)
        }
    }
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
                AppState.Item(name: item.name, isFavourite: true, isSelected: item.isSelected) :
                $0
        }
    case let .removeFromFavourites(item):
        removeFromFavourites(value: &value, item: item)
    }
}

func favouritesReducer(value: inout [AppState.Item], action: FavouritesAction) -> Void {
    switch action {
    case let .removeFromFavourites(item):
        removeFromFavourites(value: &value, item: item)
    }
}

private func removeFromFavourites(value: inout [AppState.Item], item: AppState.Item) {
    value = value.map {
        return $0.name == item.name ?
            AppState.Item(name: item.name, isFavourite: false, isSelected: item.isSelected) :
            $0
    }
}
