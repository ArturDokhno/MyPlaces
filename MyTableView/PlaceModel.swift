//
//  PlaceModel.swift
//  MyTableView
//
//  Created by Артур Дохно on 19.11.2021.
//

import UIKit
import RealmSwift

class Place: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    
    let restaurantNames = [
        "Veranda", "Диван-Сарай", "Joint Pub", "Дрова",
        "Cafe seven", "Hurma", "People's", "Семейная пиццерия",
        "Медведь", "Мао", "Traveler's Coffee", "Перчини Grill&Wine"
    ]
    
    func savePlaces() {
        
        for place in restaurantNames {
            
            let image = UIImage(named: place)
            
            guard let imageData = image?.pngData() else { return }
            
            let newPlace = Place()
            
            newPlace.name = place
            newPlace.location = "Surgut"
            newPlace.type = "Restauran"
            newPlace.imageData = imageData
            
            StorageManager.saveObject(newPlace)
        }
    }
}
