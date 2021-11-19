//
//  PlaceModel.swift
//  MyTableView
//
//  Created by Артур Дохно on 19.11.2021.
//

import Foundation

struct Place {
    
    var name: String
    var location: String
    var type: String
    var image: String
    
    static let restaurantNames = [
        "Veranda", "Диван-Сарай", "Joint Pub", "Дрова",
        "Cafe seven", "Hurma", "People's", "Семейная пиццерия",
        "Медведь", "Мао", "Traveler's Coffee", "Перчини Grill&Wine"
    ]
    
    static func getPlaces() -> [Place] {
        
        var places = [Place]()
        
        for place in restaurantNames {
            places.append(Place(name: place, location: "Сургут", type: "Ресторан", image: place))
        }
        
        return places
    }
}
