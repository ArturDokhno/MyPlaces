//
//  NewPlaceViewController.swift
//  MyTableView
//
//  Created by Артур Дохно on 27.11.2021.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    @IBOutlet var imageOfPlace: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // создаем if else в котором скрываем клавиатуру
        // при нажатии на любую ячейку кроме нулевой
        
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

// подписываемся под протокол пикер делегат что бы воспользоваться методом
// didFinishPickingMediaWithInfo
// подписываемся под протокол навигатор делегат что бы делегировать метод
// imagePickerController в choseImagePicker в обьект класса let imagePicker
 
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // создаем функциию для выбора источника изображения из системного интерфейса
    
    func choseImagePicker(sourse: UIImagePickerController.SourceType) {
        
        // проверяем доступность источника изображения
        
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            
            // создаем экземпляр класса
            
            let imagePicker = UIImagePickerController()
            
            // определяем кто будет делегировать обязаности метода imagePickerController
            // назначаем данный класс как делегата выполняющим данный метод
            
            imagePicker.delegate = self
            
            // позволяем позльзователю редактировать выбраное изображение
            
            imagePicker.allowsEditing = true
            
            // определяем тип иточника изображения
            
            imagePicker.sourceType = sourse
            
            // отображаем imagePicker на экране через презентер
            
            present(imagePicker, animated: true)
        }
    }
    
    // вызываем метод сообщающий делегату что пользователь выбрал изображение
    // данный метод должен делегироваться в метод choseImagePicker
    // а именно к обьекту класса UIImagePickerController() let imagePicker
    // так как он соответствует протоколу UIImage
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // присваиваем значение в imageOfPlace взятое по ключу из словаря info
        // заначение выбираем editedImage потому что ранее мы позволили
        // пользователю редактировать выбраное изображение
        // приводим это зачение к UIImage
        
        imageOfPlace.image = info[.editedImage] as? UIImage
        
        // маштабируем изображение по содержимому UIImage
        
        imageOfPlace.contentMode = .scaleAspectFill
        
        // обрезаем изображение по границам UIImage
        
        imageOfPlace.clipsToBounds = true
        
        // закрываем ImagePickerController
        
        dismiss(animated: true)
        
    }
    
}
