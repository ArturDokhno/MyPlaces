//
//  MapViewController.swift
//  MyTableView
//
//  Created by Артур Дохно on 05.12.2021.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func closeVC(_ sender: Any) {
        
        // данный метод закрывает текущее вью и выводит его из памяти 
        
        dismiss(animated: true)
    }
    
}

