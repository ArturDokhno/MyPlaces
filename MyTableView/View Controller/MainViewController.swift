//
//  MainViewController.swift
//  MyTableView
//
//  Created by Артур Дохно on 26.11.2021.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    // загружаем наши данные из таблицы Realm
    // Results позволяет работать с данными в реальном времени
    
    var places: Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // отображаем данные из базы данных в приложении
        // инициализируя places и вызывая метод objects
        // стави .self указывая что нужно нам именно тип данных Place
        // а не модель данных
        
        places = realm.objects(Place.self)
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // если база пустая возвращаем количесво ячеек 0
        // если нет то возвращаем количесво ячеек равной
        // количеству моделей в базе
        
        return places.isEmpty ? 0 : places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let place = places[indexPath.row]

        cell.nameLabel.text = place.name
        cell.locationlabel.text = place.location
        cell.typeLabel.text = place.type
        
        // imageData не будет пустым можем извлечь принудительно
        
        cell.imageOfPlace.image = UIImage(data: place.imageData!)

        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2

        return cell
    }
    
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
        
        // обновляем данные таблицы для отображения нового места в ячейки 
        
        tableView.reloadData()
    }
    
}
