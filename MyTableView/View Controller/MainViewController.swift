//
//  MainViewController.swift
//  MyTableView
//
//  Created by Артур Дохно on 26.11.2021.
//

import UIKit

class MainViewController: UITableViewController {
    
    var places = Place.getPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel.text = places[indexPath.row].name
        cell.locationlabel.text = places[indexPath.row].location
        cell.typeLabel.text = places[indexPath.row].type
        cell.imageOfPlace.image = UIImage(named: places[indexPath.row].image)
        
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    // создаем функцию выхода для кнопки Cancel на экране NewPlaceViewController
    
    @IBAction func cancelActione(_ segue: UIStoryboardSegue) { }
    
}
