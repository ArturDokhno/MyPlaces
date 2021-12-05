//
//  MapViewController.swift
//  MyTableView
//
//  Created by Артур Дохно on 05.12.2021.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // экземпляр класса который позволит отслеживать место положение пользователя
    
    let locationManager = CLLocationManager()
    
    // данное свойсво определяет метраж в центроки видимости места нахождения
    // пользователя на карте
    
    let regionInMeters = 10_000.00
    
    var place = Place()
    
    // индификатор для метода dequeueReusableAnnotationView (withIdentifier :)
    
    let annotationIdentifie = "annotationIdentifie"

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // вызываем метод отслеживания место положения пользователя
        
        checkLocationServices()
        
        // назначаем делегатом данный класс который будет
        // ответственым за выполнения методов протокола MKMapViewDelegate
        
        mapView.delegate = self

        // вызываем метод когда будем открывать данное вью
        
        setupPlacemark()
    }
    
    // данный метод будет центровать карту на место положение пользователя

    @IBAction func centerViewInUserLocation() {
        
        // проверяем доступность место положения пользователя если все хорошо
        // то показываем его место положение на карте с помощью MKCoordinateRegion
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            
            // setRegion изменяет текущию область видимости
            
            mapView.setRegion(region, animated: true)
        }
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
    
    // проверяю если доступ к необходимым службам позволяющим отслеживать
    // место положение пользователя
    
    private func checkLocationServices() {
    
        // locationServicesEnabled Возвращает логическое значение
        // указывающее включены ли на устройстве службы определения местоположения
        
        if CLLocationManager.locationServicesEnabled() {
            
            // вызываем метод для отслеживания место положения
            
            setupLocationManager()
            
            // вызываем метод проверки статуса разрешения
            
            checkLocationAuthorization()
            
        } else {
            // показываем алерт в главном потоке с пустя одну секунду
            // пожно было сделать что бы алерт выходил в методе viewDidApear
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Location Services are Disabled",
                    message: "To enable it go: Settings -> Privacy -> Location Services and turn On")
            }
        }
    }
    
    // метод в котором сделаны первоначальные настройки LocationManager
    
    private func setupLocationManager() {
        
        // методы протокола CLLocationManagerDelegate будет выполнять данный класс
        
        locationManager.delegate = self
        
        // данный параметр позволяет получать точность данных о место положении
        // kCLLocationAccuracyBest позволяет получить максимальную точность место положения
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // метод отвечает за проверку статуса разрешения отслеживания место положения
    
    private func checkLocationAuthorization() {
        
        // есть пять уровней доступа к место положению пользоватля нужно проверить все
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            break
        case .denied:
            // show alert controller
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // show alert controller
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case is avaible")
        }
    }
    
    // алерт контролеер когда служба геолокации не доступна
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAlert)
        present(alert, animated: true)
    }
    
}

// данный протокол позволит более тонко настраивать банер на карте
// так же имеет ряд других полезных функций
 
extension MapViewController: MKMapViewDelegate {
    
    // Возвращает вид, связанный с указанным объектом аннотации
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // нужно убедится что данный обьект не евляется место положением пользователя
        // возваряем нил как пишут в документации что бы предоставить отображение
        // пользователя на карте по умолчанию
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        // вместо того что бы создовать новое представление при каждом вызове этого метода
        // вызываем метод dequeueReusableAnnotationView (withIdentifier :) класса MKMapView
        // чтобы узнать, существует ли уже существующее представление аннотации желаемого типа
        
        var annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: "annotationIdentifie")
        
        // если на карте нет представление с анотацией то
        // инициализируем новый обьекст
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(
                annotation: annotation,
                reuseIdentifier: annotationIdentifie)
            
            // canShowCallout позволит отобразить дополнительную анотацию в виде банера
            
            annotationView?.canShowCallout = true
        }
        
        // создаем свойсво в котором будем хранить изображение для отображения в банере
        // добавляем размер изображению которое будет отображаться в банере
        
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 50,
                                                  height: 50))
        
        // извлекаю опциональное изображение place.imageData
        
        if let imageData = place.imageData {
            
            // округляем изображение
            
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            
            // добавляем изображение в
            
            imageView.image = UIImage(data: imageData)
            
            // помещяем полученое изображение в сам банер
            
            annotationView?.rightCalloutAccessoryView = imageView
        }
        return annotationView
    }
    
}

// обновляем положение пользователя на карте

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
