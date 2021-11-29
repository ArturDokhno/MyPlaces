//
//  StorageManager.swift
//  MyTableView
//
//  Created by Артур Дохно on 29.11.2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveOject(_ place: Place) {
        
        try! realm.write {
            realm.add(place)
        }
    }
    
}
