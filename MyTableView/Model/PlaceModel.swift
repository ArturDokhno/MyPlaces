//
//  PlaceModel.swift
//  MyTableView
//
//  Created by Артур Дохно on 27.11.2021.
//

import UIKit
import RealmSwift

class Place: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    
    let restaurantNames = [
        "Traveler's Coffee", "Дрова", "Кофеин", "Joint Pub",
        "MISHKA BAR", "Мао", "Cafe Botanica", "Traveler's Coffee",
        "Болгарская роза", "Семейная пиццерия", "People's",
        "Диван-Сарай", "Hurma", "На высоте", "Мерцана"
    ]

    func savePlace() {
        
        for place in restaurantNames {
            
            let image = UIImage(named: place)
            
            guard let imageData = image?.pngData() else {  return }
            
            let newPlace = Place()
            
            newPlace.name = place
            newPlace.location = "Surgut"
            newPlace.type = "Restaurant"
            newPlace.imageData = imageData
            
            StorageManager.saveOject(newPlace)
        }
    }
    
}
