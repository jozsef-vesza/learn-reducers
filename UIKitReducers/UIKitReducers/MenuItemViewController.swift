//
//  MenuItemViewController.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 25..
//

import UIKit
import Combine

class MenuItemViewController: UIViewController {
    
    var store: Store<AppState, AppAction>!
    var item: AppState.Item?
    
    @IBOutlet private weak var favouriteButton: UIButton!
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.$value
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] (value) in
                guard let self = self, let selectedItem = value.selectedItem else { return }
                self.item = selectedItem
                self.navigationItem.title = selectedItem.name
                self.updateFavouriteButtonTitle()
            }
            .store(in: &subscriptions)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.send(.menuItem(.deselect))
    }
    
    @IBAction private func favouriteButtonPressed(_ sender: Any) {
        guard let item = item else { return }
        item.isFavourite ?
            store.send(.menuItem(.removeFromFavourites(item))) :
            store.send(.menuItem(.addToFavourites(item)))
    }
    
    private func updateFavouriteButtonTitle() {
        guard let item = item else { return }
        let title = item.isFavourite ?
            "Remove from Favourites" :
            "Add to Favourites"
        favouriteButton.setTitle(title, for: .normal)
    }
}
