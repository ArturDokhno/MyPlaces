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
  
}
