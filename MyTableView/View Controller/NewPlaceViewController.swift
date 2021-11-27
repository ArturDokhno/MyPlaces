//
//  NewPlaceViewController.swift
//  MyTableView
//
//  Created by Артур Дохно on 27.11.2021.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // скрываем клавиатуру при нажатии на любую ячейку кроме нулевой
        
        if indexPath.row == 0 {
            
        } else {
            view.endEditing(true)
        }
    }
    
}

// MARK: - Text field delegate

extension NewPlaceViewController: UITextFieldDelegate {
    
    // скрываем клавиатуру при нажатии на кнопку Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
