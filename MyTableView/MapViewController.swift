//
//  MapViewController.swift
//  MyTableView
//
//  Created by Артур Дохно on 05.12.2021.
//

import UIKit
import MapKit
import CoreLocation

// протокол для того что бы передавать данные адреса с карты в текстовое воле

protocol MapViewControllerDelegate {
    
    // @objc optional это возволит сделать данный метод не обязательным
    // можно так же через расширение сделать методы протокола не обязательными

    // делаем address опциональным что бы при нажатии кнопки готово
    // не нужно было извлекать опционал в методе getAddress
    
    func getAddress(_ address: String?)
}

class MapViewController: UIViewController {
    
    // обьявляем свойство класса с типом протокола
    
    var mapViewControllerDelegate: MapViewControllerDelegate?
    
    // экземпляр класса который позволит отслеживать место положение пользователя
    
    let locationManager = CLLocationManager()
    
    // данное свойсво определяет метраж в центроки видимости места нахождения
    // пользователя на карте
    
    let regionInMeters = 5_000.00
    
    // данное свойсво будет принимать индификатор в зависимости
    // от значения индификатора будем вызывать тот или иной метод
    
    var incomeSegueIdentifier = ""
    
    var place = Place()
    
    // индификатор для метода dequeueReusableAnnotationView (withIdentifier :)
    
    let annotationIdentifie = "annotationIdentifie"
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapPinImage: UIImageView!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var addressLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // вызываем метод отслеживания место положения пользователя
        
        checkLocationServices()
        
        // назначаем делегатом данный класс который будет
        // ответственым за выполнения методов протокола MKMapViewDelegate
        
        mapView.delegate = self
        
        // вызываем метод когда будем открывать данное вью
        // через индификатор showPlace
        
        setupMapView()
        
        addressLabel.text = "" 
    }
    
    @IBAction func centerViewInUserLocation() {
        
        showUserLocation()
    }
    
    @IBAction func doneButtonPressed() {
        
        // вызываем метод протокола getAddress
        // и предаем в него данные из поля addressLabel
        // когда будем реализовать метод протокола в класса NewPlaceVC
        // то метод getAddress будет уже иметь данные с поля addressLabel
        
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        
        // методом dismiss закрываем текущее окно и передаем данные
        // в NewPlaceVC там вызыву метод getAddress
        // который уже будет содержать данные с поля addressLabel
        
        dismiss(animated: true)
    }
    
    @IBAction func closeVC(_ sender: Any) {
        
        // данный метод закрывает текущее вью и выводит его из памяти
        
        dismiss(animated: true)
    }
    
    // метод setupPlacemark будет срабатывать когда
    // индификатор по которому перешли будет равен showPlace
    
    private func setupMapView() {
        
        if incomeSegueIdentifier == "showPlace" {
            setupPlacemark()
            
            // скрываем mapPinImage, addressLabel и doneButton
            // если пользователь перешел по этому индификатора
            
            mapPinImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
        }
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
            
            // если индификатор по которому перейдет пользователь будет
            // getAddress вызываем метод showUserLocation()
            
            if incomeSegueIdentifier == "getAddress" {
                showUserLocation()
            }
            
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
    
    // данный метод будет центровать карту на место положение пользователя
    // и получения адреса для кнопки в текстовом поле адресс во вью NewPlaceVC
    
    private func showUserLocation() {
        
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
    
    // метод определяющий координт под пином
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        // определяем центр карты через centerCoordinate
        // создав для этого константы ширины и долготы
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        // нужно вернуть кординаты точки поэтому вызываем класс CLLocation
        // и передаем туда в качестве параметров ранее созданые константы
        // ширины и долготы места на которое указывает пин
        
        return CLLocation(latitude: latitude, longitude: longitude)
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
    
    // имплементирую метод протокола MKMapViewDelegate
    // который позволит получить адрес места на которое указывает центр карты
    // данный метод вызывается каждый раз когда меняется видимая область на карте
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        // опередяем текущие кардинаты
        
        let center = getCenterLocation(for: mapView)
        
        // создаем экземпляр класса
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            
            // проверяем ошибки
            
            if let error = error {
                print(error)
                return
            }
            
            // извликаем массив
            
            guard let placemarks = placemarks else { return }
            
            // данный массив содержит одну метку
            // извлекаю ее в константу
            // получаем обьект класса CLPlacemark
            
            let placemark = placemarks.first
            
            // извлекаем улицу и номер дома
            
            let streetName = placemark?.thoroughfare
            let buildNumber = placemark?.subThoroughfare
            
            // передаем значения в лейбл
            // согласно документации возвращаем результат в главный поток асинхронно
            
            DispatchQueue.main.async {
                
                // проверяем streetName и buildNumber на nil
                // в блоке if можем уже принудительно извлечь опционал так как
                // точно знаю что они не пустые
                
                if streetName != nil, buildNumber != nil {
                    self.addressLabel.text = "\(streetName!), \(buildNumber!)"
                } else if  streetName != nil {
                    self.addressLabel.text = "\(streetName!)"
                } else {
                    self.addressLabel.text = ""
                }
                
            }
        }
        
    }
    
}

// обновляем положение пользователя на карте

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
