//
//  MainViewController.swift
//  MyTableView
//
//  Created by Артур Дохно on 26.11.2021.
//

import UIKit

class MainViewController: UITableViewController {
    
    let restaurantNames = [
        "Traveler's Coffee", "Дрова", "Кофеин", "Joint Pub",
        "MISHKA BAR", "Мао", "Cafe Botanica", "Traveler's Coffee",
        "Болгарская роза", "Семейная пиццерия", "People's",
        "Диван-Сарай", "Hurma", "На высоте", "Мерцана"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var conten = cell.defaultContentConfiguration()
        
        conten.text = restaurantNames[indexPath.row]

        cell.contentConfiguration = conten
        return cell
    }

    // MARK: - Navigation

    
    
}
