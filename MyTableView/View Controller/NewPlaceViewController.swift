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
            
            // создаем алерт контрллер стиля "лист дейсвий" появляющейся с низу экрана
            // далее создаем кнопки дейсвия которые добавим в алерт контроллер
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            // создаем кнопку дейвия в алерт контроллере
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                
                // вызываем метод choseImagePicker
                
                self.choseImagePicker(sourse: .camera)
            }
            
            // создаем кнопку дейсвия в алерт контроллере
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                
                // вызываем метод choseImagePicker
                
                self.choseImagePicker(sourse: .photoLibrary)
            }
            
            // создаем кнопку выхода в алерт контроллере
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            // добавляем кнопки в алерт контролер
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            // презентуем алерт контроллер 
            
            present(actionSheet, animated: true)
            
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

// MARK: - Work with image

extension NewPlaceViewController {
    
    // создаем функциию для выбора источника изображения из системного интерфейса
    
    func choseImagePicker(sourse: UIImagePickerController.SourceType) {
        
        // проверяем доступность источника изображения
        
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            
            // создаем экземпляр класса
            
            let imagePicker = UIImagePickerController()
            
            // позволяем позльзователю редактировать выбраное изображение
            
            imagePicker.allowsEditing = true
            
            // определяем тип иточника изображения
            
            imagePicker.sourceType = sourse
            
            // отображаем imagePicker на экране через презентер
            
            present(imagePicker, animated: true)
        }
    }
    
}
