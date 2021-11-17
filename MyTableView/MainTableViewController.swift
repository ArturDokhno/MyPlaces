//
//  MainTableViewController.swift
//  MainTableView
//
//  Created by Артур Дохно on 17.11.2021.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let restaurantNames = [
        "Veranda", "Диван-Сарай", "Joint Pub", "Дрова",
        "Cafe seven", "Hurma", "People's", "Семейная пиццерия",
        "Медведь", "Мао", "Traveler's Coffee", "Перчини Grill&Wine"
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
        
        cell.textLabel?.text = restaurantNames[indexPath.row]
        cell.imageView?.image = UIImage(named: restaurantNames[indexPath.row])
        
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
