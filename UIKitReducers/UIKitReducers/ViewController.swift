//
//  RootViewController.swift
//  UIKitReducers
//
//  Created by József Vesza on 2020. 11. 25..
//

import UIKit

class RootViewController: UIViewController, StoreUserViewController {
    
    var store: Store!
    
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

extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        
        return cell
    }
}

extension RootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: items[indexPath.row].destination, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? StoreUserViewController)?.store = store
    }
}
