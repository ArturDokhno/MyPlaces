//
//  MapViewController.swift
//  MyTableView
//
//  Created by Артур Дохно on 05.12.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // можем извлечь принудительно так как данные при переходе
    // будут браться из ячейки которая уже заполнена всеми
    // необходимыми данными
    
    var place: Place!

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // вызываем метод когда будем открывать данное вью
        
        setupPlacemark()
    }
    
    @IBAction func closeVC(_ sender: Any) {
        
        // данный метод закрывает текущее вью и выводит его из памяти
        
        dismiss(animated: true)
    }
    
    // метод присваивает маркер для места
    
    private func setupPlacemark() {
        
        // если у места нет локации то выходим от суда
        
        guard let location = place.location else { return }
        
        // если есть то создаем экземпляр класса CLGeocoder
        // данный класс преобразует координаты в название мест
        // данный класс использовать буду с адресом из location что бы преобразовать
        // их в географические координаты что бы отобразить на карте
        
        let geocoder = CLGeocoder()
        
        // данный метод как раз это и делает
        
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            // проверяем не содежит ли обьект ошибок
            
            if let error = error {
                print(error)
                return
            }
            
            // если ошибки нет извлекаем опционал из placemark
            
            guard let placemarks = placemarks else { return }
            
            // получаем одну метку на карте из массива placemarks
            // по индекту с помощью first, получаем данные из массива по первому индексу
            
            let placemark = placemarks.first
            
            // что бы добавить данные о месте в марке
            // используем класс MKPointAnnotation он используется что описать
            // какую-то точку на карте
            
            let annotation = MKPointAnnotation()
            
            // добавляем описание об места в экземпляр класса MKPointAnnotation
            
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            
            // привязываю созданую анотацию к конкретной точке на карте
            // в соотвествии с место положением маркера на карте
            
            // если получилось определить место положения маркера то идем дальше
            
            guard let placemarkLocation = placemark?.location else { return }
            
            // привязываю анотацию к точке на карте
            
            annotation.coordinate = placemarkLocation.coordinate
            
            // задаем видиную область на карте что бы видно было все созданые анотации
            // вызываем метод showAnnotations помещая туда анотацией annotation
            
            self.mapView.showAnnotations([annotation], animated: true)
            
            // что бы выделить созданую анотацию вызываем метод selectAnnotation
            // передаем туда обьект annotation
            
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
}

