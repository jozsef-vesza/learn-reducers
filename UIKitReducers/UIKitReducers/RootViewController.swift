//
//  RootViewController.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 25..
//

import UIKit

class RootViewController: UIViewController {
    
    var store: Store<AppState, AppAction>!
    
    private let items = [
        (title: "Menu", destination: "showMenu"),
        (title: "Favourites", destination: "showFavourites")
    ]
    
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "root", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: items[indexPath.row].destination, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let menuViewController = segue.destination as? MenuViewController {
            menuViewController.store = store
        } else if let favouritesViewController = segue.destination as? FavouritesViewController {
            favouritesViewController.store = store
        }
    }
}
