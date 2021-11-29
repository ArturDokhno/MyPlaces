//
//  MainViewController.swift
//  MyTableView
//
//  Created by Артур Дохно on 26.11.2021.
//

import UIKit

class MainViewController: UITableViewController {
    
//    var places = Place.getPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return places.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
//
//        let place = places[indexPath.row]
//
//        cell.nameLabel.text = place.name
//        cell.locationlabel.text = place.location
//        cell.typeLabel.text = place.type
//
//        if place.image == nil {
//            cell.imageOfPlace.image = UIImage(named: place.restaurantName!)
//        } else {
//            cell.imageOfPlace.image = place.image
//        }
//
//        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
//
//        return cell
//    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    //
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        // создаем экземпляр класса NewPlaceViewController в константе NewPlaceVC
        // через segue обращаемся к source
        // что бы передать данные с контролера на который переходили ранее
        // на контролеер с которого мы перешли на контролер от куда и будем брать данные
        // для заполнение информации ячейки
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        
        // вызываем метод saveNewPlace
        // из экземпляра класа
        
        newPlaceVC.saveNewPlace()
        
        // можем смело принудительно разворачивать опционал
        // а именно массив newPlace и данные из него добавлять в масив places
        // так как мы точно получили данные в виду того что
        // кнопка Save не будет активна пока необходимое поле не будет заполнено
        
//        places.append(newPlaceVC.newPlace!)
        
        // обновляем данные таблицы для отображения нового места в ячейки 
        
        tableView.reloadData()
    }
    
}
