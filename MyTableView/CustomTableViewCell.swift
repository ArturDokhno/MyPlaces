//
//  CustomTableViewCell.swift
//  MyTableView
//
//  Created by Артур Дохно on 27.11.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var imageOfPlace: UIImageView! {
        didSet {
            imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height / 2
        }
    }
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationlabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
}
