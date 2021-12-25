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
    
    let mapManager = MapManager()
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var place = Place()
    
    // индификатор для метода dequeueReusableAnnotationView (withIdentifier :)
    let annotationIdentifie = "annotationIdentifie"
    
    // данное свойсво будет принимать индификатор в зависимости
    // от значения индификатора будем вызывать тот или иной метод
    var incomeSegueIdentifier = ""
    
    // переменая которая будет хранить предыдущие место положение пользователя
    var previousLocation: CLLocation? {
        didSet {
            mapManager.startTrackingUserLocation(for: mapView,
                                                    and: previousLocation) { (currentLocation) in
                self.previousLocation = currentLocation
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.mapManager.showUserLocation(mapView: self.mapView)
                }
            }
        }
    }
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapPinImage: UIImageView!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var goButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // назначаем делегатом данный класс который будет
        // ответственым за выполнения методов протокола MKMapViewDelegate
        mapView.delegate = self
        
        // вызываем метод когда будем открывать данное вью
        // через индификатор showPlace
        setupMapView()
        
        addressLabel.text = ""
    }
    
    @IBAction func centerViewInUserLocation() {
        
        mapManager.showUserLocation(mapView: mapView)
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
    
    @IBAction func goButtonPressed() {
        mapManager.getDirections(for: mapView) { (location) in
            self.previousLocation = location
        }
    }
    
    // метод setupPlacemark будет срабатывать когда
    // индификатор по которому перешли будет равен showPlace
    private func setupMapView() {
        
        // скрываем кнопку прокладывая маршрута от пользователя до места
        goButton.isHidden = true
        
        mapManager.checkLocationServices(mapView: mapView,
                                         segueIdentifier: incomeSegueIdentifier) {
            mapManager.locationManager.delegate = self
        }
        
        if incomeSegueIdentifier == "showPlace" {
            
            mapManager.setupPlacemark(place: place, mapView: mapView)
            
            // скрываем mapPinImage, addressLabel и doneButton
            // если пользователь перешел по этому индификатора
            mapPinImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            
            // при переходе по showPlace снова отображаем кнопку
            goButton.isHidden = false
        }
    }
    
}
    
// данный протокол позволит более тонко настраивать банер на карте
// так же имеет ряд других полезных функций
extension MapViewController: MKMapViewDelegate {
    
    // Возвращает вид, связанный с указанным объектом аннотации
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
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
        let center = mapManager.getCenterLocation(for: mapView)
        
        // создаем экземпляр класса
        let geocoder = CLGeocoder()
        
        // есди перехожим на карту по showPlace то
        // с зарержной 3 секунды вызываем метод showUserLocation
        if incomeSegueIdentifier == "showPlace" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManager.showUserLocation(mapView: self.mapView)
            }
        }
        
        // для освобождение ресурсов вызываем метод cancelGeocode
        geocoder.cancelGeocode()
        
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
    
    // вызываем метод который отобразит линию маршрута на карте
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        
        // крашу линию
        renderer.strokeColor = .blue
        
        return renderer
    }
    
}

// обновляем положение пользователя на карте
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        mapManager.checkLocationAuthorization(mapView: mapView,
                                              segueIdentifier: incomeSegueIdentifier)
    }
}
