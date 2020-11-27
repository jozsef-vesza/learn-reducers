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
