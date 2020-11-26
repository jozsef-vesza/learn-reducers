//
//  MenuViewController.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 25..
//

import UIKit
import Combine

class MenuViewController: UIViewController {
    
    var store: Store<AppState, AppAction>!

    @IBOutlet private weak var tableView: UITableView!
    
    private var items: [AppState.Item] = []
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        store.$value
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] (value) in
                guard let self = self else { return }
                self.items = value.items
                self.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItem", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name

        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.send(.menu(.itemSelected(indexPath.row)))
        performSegue(withIdentifier: "showMenuDetail", sender: self)
    }
}

// MARK: - Segue Management
extension MenuViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? MenuItemViewController else { return }
        destination.store = store
    }
}
