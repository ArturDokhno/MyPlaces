//
//  MapManager.swift
//  MyTableView
//
//  Created by Артур Дохно on 25.12.2021.
//

import UIKit
import MapKit

class MapManager {
    
    // экземпляр класса который позволит отслеживать место положение пользователя
    let locationManager = CLLocationManager()
    
    // данное свойство принимает координаты заведения
    // для построения маршрута от пользователя до места
    private var placeCoordinate: CLLocationCoordinate2D?
    
    // данное свойсво определяет метраж в центроки видимости места нахождения
    // пользователя на карте
    private let regionInMeters = 1_000.00
    
    // массив в котором храним маршруты
    private var directionsArray: [MKDirections] = []
    
    // метод присваивает маркер для места
    func setupPlacemark(place: Place,
                                mapView: MKMapView) {
        
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
            annotation.title = place.name
            annotation.subtitle = place.type
            
            // привязываю созданую анотацию к конкретной точке на карте
            // в соотвествии с место положением маркера на карте
            // если получилось определить место положения маркера то идем дальше
            guard let placemarkLocation = placemark?.location else { return }
            
            // привязываю анотацию к точке на карте
            annotation.coordinate = placemarkLocation.coordinate
            
            // передаю координаты места в свойство placeCoordinate для
            // построения маршрута от пользователя к месту
            self.placeCoordinate = placemarkLocation.coordinate
            
            // задаем видиную область на карте что бы видно было все созданые анотации
            // вызываем метод showAnnotations помещая туда анотацией annotation
            mapView.showAnnotations([annotation], animated: true)
            
            // что бы выделить созданую анотацию вызываем метод selectAnnotation
            // передаем туда обьект annotation
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    // проверяю если доступ к необходимым службам позволяющим отслеживать
    // место положение пользователя
    func checkLocationServices(mapView: MKMapView,
                                       segueIdentifier: String,
                                       closure: () -> ()) {
        
        // locationServicesEnabled Возвращает логическое значение
        // указывающее включены ли на устройстве службы определения местоположения
        if CLLocationManager.locationServicesEnabled() {
            
            // отслеживание место положения
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // вызываем метод проверки статуса разрешения
            checkLocationAuthorization(mapView: mapView,
                                       segueIdentifier: segueIdentifier)
            closure()
            
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
    
    // метод отвечает за проверку статуса разрешения отслеживания место положения
    func checkLocationAuthorization(mapView: MKMapView,
                                            segueIdentifier: String) {
        
        // есть пять уровней доступа к место положению пользоватля нужно проверить все
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            
            // если индификатор по которому перейдет пользователь будет
            // getAddress вызываем метод showUserLocation()
            if segueIdentifier == "getAddress"  { showUserLocation(mapView: mapView) }
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
    func showUserLocation(mapView: MKMapView) {
        
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
    
    // метод для построения маршрута от пользователя до места
    func getDirections(for mapView: MKMapView,
                               previousLocation: (CLLocation) -> ()) {
        
        // определяю место положения пользователя
        guard let location = locationManager.location?.coordinate else {
            
            // если место нахождения не определилось то появится предупреждение
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
        
        // включаю режим постоянного отлеживания место положения пользователя
        // данный режим включаю после того как маршрут определен
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude,
                                    longitude: location.longitude))
        
        // запрос на создания маршура в параметр подставляю место положения пользователя
        // так как createDirectionRequest возвращяет опционал извлекаю его
        guard let request = createDirectionsRequest(from: location) else {
            showAlert(title: "Error", message: "Distination is not found")
            return
        }
        
        // создаем маршрут на основе данных которые получили
        let directions = MKDirections(request: request)
        
        // удаляю все старые маршруты перед построением новых
        resetMapview(withNew: directions,
                     mapView: mapView)
        
        // запускаю расчет маршрута
        // данный метод возвращет расчитаный маршрут со всеми данными
        directions.calculate { (response, error) in
            
            // извлекаю ошибку
            if let error = error {
                print(error)
                return
            }
            
            // пробую извлечь маршрут
            guard let response = response else {
                
                // если не получилось извлечь маршрут выводим сообщение об ошибке
                self.showAlert(title: "Error", message: "Directions is not available")
                return
            }
            
            // обьект response содержит массив с маршрутами
            // перебираю массив каждый элемент содержит возможный маршрут
            for route in response.routes {
                
                // polyline содержит полный путь маршрута
                mapView.addOverlay(route.polyline)
                
                // setVisibleMapRect опеределяет зону видимости карты по которой
                // определится маршрут
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                // определяю растояние маршрута
                let distance = String(format: "%.1f",route.distance / 1000)
                
                // определяю время в пути
                let timeInterval = String(format: "%.1f", route.expectedTravelTime / 60)
                
                print("Растояние до места: \(distance)")
                print("Время в пути составит: \(timeInterval)")
            }
        }
    }
    
    // метод для настройки запроса построения маршрута
    // принимает координаты
    // возворащяет настроеный запрос который опциональный
    // его и будем использовать в getDirections
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        // определяем координаты место назначения
        // для этого нужно проверять координаты места куда
        // будет строится маршрут от пользователя
        // просто так выйди не можем так как нужно передать MKDirections.Request?
        // поэтому в гуарде возвращяем нил
        guard let destinationCoordinate = placeCoordinate else { return nil }
        
        // создаем точку старата маршрута
        let startLocation = MKPlacemark(coordinate: coordinate)
        
        // создаем точку прибытия
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        // создаю запрос на построение маршрута от старта до прибытия
        let request = MKDirections.Request()
        
        // определяю стартовую точку маршрута
        request.source = MKMapItem(placemark: startLocation)
        
        // определяю конечную точку маршрута
        request.destination = MKMapItem(placemark: destination)
        
        // задаем тип транспорта для маршрута
        request.transportType = .automobile
        
        // данное свойство позволяет показывать пользователю
        // разные разные альтернативные маршруты на карте
        request.requestsAlternateRoutes = true
        
        // возвращаем обьект request
        return request
    }
    
    // метод для отлеживания положение узера
    func startTrackingUserLocation(for mapView: MKMapView,
                                           and location: CLLocation?,
                                           closure: (_ currentLocation: CLLocation) -> ()) {
        
        guard let location = location else { return }
        let center = getCenterLocation(for: mapView)
        
        // если растояние от предыдущего место положение пользователя
        // до конечной точки более 50 метров то отлеживаем
        // центруя карту на место положение пользователя
        guard center.distance(from: location) > 50 else { return }
        
        closure(center)
    }
    
    
    // метод который будет очищять маршруты пред построением новых
    func resetMapview(withNew directions: MKDirections,
                              mapView: MKMapView) {
        
        // удаляю с карты текущие наложения на карте
        mapView.removeOverlays(mapView.overlays)
        
        // добавляю в массив текущие массивы
        directionsArray.append(directions)
        
        // через замыкание перебираем все значения в массиве
        // отменяем у каждого элеманта маршрут
        let _ = directionsArray.map { $0.cancel() }
        
        // удаляем все элементы из массива
        directionsArray.removeAll()
    }
    
    // метод определяющий координт под пином
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
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
    private func showAlert(title: String,
                           message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "Ok",
                                    style: .default)
        
        alert.addAction(okAlert)
        
        // что бы метод презент работал в классе который наследуется не от UIView
        // создаю обьект UIWindow и инициализирую его свойство rootViewController
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        
        // опредяю позиционирование окна относительно других окон
        // определяю его поверх других окон
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        
        // делаем окно ключевым и видемым
        alertWindow.makeKeyAndVisible()
        
        // передаем в rootViewController презент alert
        alertWindow.rootViewController?.present(alert, animated: true)
    }
    
}
