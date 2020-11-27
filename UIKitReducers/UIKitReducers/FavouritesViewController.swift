//
//  FavouritesViewController.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 25..
//

import UIKit
import Combine

class FavouritesViewController: UIViewController {

    var store: Store<AppState, AppAction>!
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var items: [Item] = []
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        store.$value
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] (value) in
                guard let self = self else { return }
                self.items = value.favourites
                self.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
}

// MARK: - UITableViewDataSource
extension FavouritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favourite", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            store.send(.favourites(.removeFromFavourites(item)))
        }
    }
}
