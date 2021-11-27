//
//  PlaceModel.swift
//  MyTableView
//
//  Created by Артур Дохно on 27.11.2021.
//

import Foundation

struct Place {
    
    var name: String
    var location: String
    var type: String
    var image: String
    
    static let restaurantNames = [
        "Traveler's Coffee", "Дрова", "Кофеин", "Joint Pub",
        "MISHKA BAR", "Мао", "Cafe Botanica", "Traveler's Coffee",
        "Болгарская роза", "Семейная пиццерия", "People's",
        "Диван-Сарай", "Hurma", "На высоте", "Мерцана"
    ]

    static func getPlaces() -> [Place] {
        
        // создаем пустой массив типа Place
        
        var places = [Place]()
        
        // с помощью цикла пробегаемся по каждому элементу массива restaurantNames
        // и добавляем каждый элемент в массив places типа Place
        // вызвав его инициализатор и подставляя данные массива restaurantNames
        // в нужные нам параметры имя и картинка
        
        for place in restaurantNames {
            places.append(Place(name: place, location: "Сургут", type: "Ресторан", image: place))
        }
        
        // возвращаем массив типа Place
        
        return places
    }
    
}
