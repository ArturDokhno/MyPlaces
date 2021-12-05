//
//  NewPlaceViewController.swift
//  MyTableView
//
//  Created by Артур Дохно on 27.11.2021.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    // создаем обьект в котоырм можем передать
    // обьект с типом Place из главного контроллера
    // нужно для редактирования данных выбраной ячейки
    
    var currentPlace: Place!
    
    // создаем переменную по которой будем отслеживать выбрано ли изображение
    // для нового места, если нет то будем устанавливать стандатное изображение
    
    var imageIsChange = false
    
    @IBOutlet var ratingControl: RaitingControl!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var imagePlace: UIImageView!
    @IBOutlet var namePlace: UITextField!
    @IBOutlet var locationPlace: UITextField!
    @IBOutlet var typePlace: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // отключаем кнопку по умолчанию
        
        saveButton.isEnabled = false
        
        // добавляем таргет с отлеживанием заполнено текстовое поле или нет
        
        namePlace.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        // вызываем метод редактирование
        
        setupEditScreen()
        
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // создаем if else в котором скрываем клавиатуру
        // при нажатии на любую ячейку кроме нулевой
        
        if indexPath.row == 0 {
            
            // создаем две переменных в которых будем хранить иконки для кнопок алерта 
            
            let cameraIcon = UIImage(named: "camera")
            let photoIcon = UIImage(named: "photo")
            
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
            
            // присваиваем иконку для кнопки и передвигаем title в левую сторону
            
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            // создаем кнопку дейсвия в алерт контроллере
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                
                // вызываем метод choseImagePicker
                
                self.choseImagePicker(sourse: .photoLibrary)
            }
            
            // присваиваем иконку для кнопки и передвигаем title в левую сторону
            
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // если переход не showMap то выходи от суда
        
        if segue.identifier != "showMap" { return }
        
        // если да то создаем экземпляр класса MapViewController
        
        let mapVC = segue.destination as! MapViewController
        
        // передаю в mapVC данные из текстового поля
        
        mapVC.place.name = namePlace.text!
        mapVC.place.location = locationPlace.text
        mapVC.place.type = typePlace.text
        mapVC.place.imageData = imagePlace.image?.pngData()
    }
    
    // создаем метод сохранения нового обьекта
    
    func savePlace() {
        
        // создаем переменую в которую будем присваивать изображение
        
        let image = imageIsChange ? imagePlace.image : UIImage(named: "imagePlaceholder")

        let imageData = image?.pngData()
        
        // инициализируем класс подставляя параметры из текст филдов
        
        let newPlace = Place(name: namePlace.text!,
                             location: locationPlace.text,
                             type: typePlace.text,
                             imageData: imageData,
                             rating: Double(ratingControl.rating))
        
        // выполянем проверку в каком методе мы находимя
        // редактирование или создание нового места
        
        if currentPlace != nil {
            try! realm.write{
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        }else {
            // сохраняем новое место в базу данных
            
            StorageManager.saveOject(newPlace)
        }
        
        
        
    }
    
    // данный метод нужен для того что бы редактировать то что мы получаем
    // из ячейки с место из главного контроллера
    
    private func setupEditScreen() {
        
        // проверяем наше место которое хотим изменить на пустое оно или нет
        
        if currentPlace != nil {
            
            setupNavigationBar()
            
            // ставим тру что бы изображение не менялось на стандартное
            
            imageIsChange = true
            
            // подставляем в поля второго контроллера
            // все значения получиненные из ячейки первого контроллера
            
            // привожу imageDate к типу image
            
            guard let date = currentPlace?.imageData,
                  let image = UIImage(data: date) else { return }
            
            imagePlace.image = image
            imagePlace.contentMode = .scaleToFill
            
            namePlace.text = currentPlace?.name
            locationPlace.text = currentPlace?.location
            typePlace.text = currentPlace?.type
            ratingControl.rating = Int(currentPlace.rating)
            
        }
        
    }
    
    // переделываем навигатор бар во время редактирования сущесвующей ячейки 
    
    private func setupNavigationBar() {
        
        // убираем надпись в левой кнопки навигатор бара
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil,
                                                        action: nil)
        }
        
        // убираем левую кнопку в баре
        
        navigationItem.leftBarButtonItem = nil
        
        // присваиваем заголовок название места в бар
        
        title = currentPlace?.name
        
        // делаем кнопку сохранения доступной
        
        saveButton.isEnabled = true
    }
    
    // создаем кнопку выхода для закртия текушего вью
    // и возврата к предыдущему
    
    @IBAction func cancelAction(_ sender: Any) {
        
        dismiss(animated: true)
        
    }
    
}

// MARK: - Text field delegate

extension NewPlaceViewController: UITextFieldDelegate {
    
    // скрываем клавиатуру при нажатии на кнопку Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // создаем метод отвечающий за то что бы кнопка Save
    // была активна в зависимости набран тект в namePlace или нет
    
    @objc private func textFieldChanged() {
        
        // проверяем пустое ли текстовое поле
        
        if namePlace.text?.isEmpty == false {
            
            // если не пустое кнопка Save активна
            
            saveButton.isEnabled = true
            
        } else {
            
            // иначе она не активна
            
            saveButton.isEnabled = false
        }
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
        
        imagePlace.image = info[.editedImage] as? UIImage
        
        // маштабируем изображение по содержимому UIImage
        
        imagePlace.contentMode = .scaleAspectFill
        
        // обрезаем изображение по границам UIImage
        
        imagePlace.clipsToBounds = true
        
        // если imageIsChange тру картинку не меняем
        
        imageIsChange = true
        
        // закрываем ImagePickerController
        
        dismiss(animated: true)
        
    }
    
}
