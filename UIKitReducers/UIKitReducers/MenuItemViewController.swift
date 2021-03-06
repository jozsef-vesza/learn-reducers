//
//  MenuItemViewController.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 25..
//

import UIKit
import Combine

class MenuItemViewController: UIViewController {
    
    var store: Store<Item?, MenuItemAction>!
    var item: Item?
    
    @IBOutlet private weak var favouriteButton: UIButton!
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.$value
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] (value) in
                guard let self = self, let selectedItem = value else { return }
                self.item = selectedItem
                self.navigationItem.title = selectedItem.name
                self.updateFavouriteButtonTitle()
            }
            .store(in: &subscriptions)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.send(.deselect)
    }
    
    @IBAction private func favouriteButtonPressed(_ sender: Any) {
        guard let item = item else { return }
        item.isFavourite ?
            store.send(.removeFromFavourites(item)) :
            store.send(.addToFavourites(item))
    }
    
    private func updateFavouriteButtonTitle() {
        guard let item = item else { return }
        let title = item.isFavourite ?
            "Remove from Favourites" :
            "Add to Favourites"
        favouriteButton.setTitle(title, for: .normal)
    }
}
