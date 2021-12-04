//
//  MainViewController.swift
//  MyTableView
//
//  Created by Артур Дохно on 26.11.2021.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // обьявляем экземпляр класса UISearchController
    // searchResultsController передаем nil
    // что бы сообщить UISearchController что будем использовать тот же
    // View для отображения результатов поиска
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    // загружаем наши данные из таблицы Realm
    // Results позволяет работать с данными в реальном времени
    
    private var places: Results<Place>!
    
    // вспомогательно свойство для сортировки возростанию или убыванию
    // которое мы будем менять при нажатии кнопки
    
    private var ascendingSorting = true
    
    // массив в котором будет хранится отфильтрованые данные
    // с помощью поисковика
    
    private var filteredPlaces: Results<Place>!
    
    // булевое значение которое указывает пустая строка поиска или нет
    
    private var seachBarIsEmpty: Bool {
        
        // извлекаем опционал текст из поиска если не получится
        // вернем фолс, значит строка поиска не пустая
        
        guard let text = searchController.searchBar.text else { return false }
        
        // если строка поиска пустая вернется тру
        
        return text.isEmpty
    }
    
    // свойсвто которое будет отслеживать что отображать в таблице
    // данные из массива filteredPlaces или places
    
    private var isFiltering: Bool {
        
        // поисковоя строка активирована и не пустая
        // тогда вернем тру
        
        return searchController.isActive && !seachBarIsEmpty
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // отображаем данные из базы данных в приложении
        // инициализируя places и вызывая метод objects
        // стави .self указывая что нужно нам именно тип данных Place
        // а не модель данных
        
        places = realm.objects(Place.self)
        
        // Настраиваем ascendingSorting
        
        // сообщаем segmentedControl что получаетелем изменений текста
        // в поисковите должен быть данный класс
        
        searchController.searchResultsUpdater = self
        
        // позволяем управлять данными который выдаст поиск
        // сможем редактировать или удалять ячейки
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        // присваиваем название поисковой строки
        
        searchController.searchBar.placeholder = "Search"
        
        // интегрируем строку поиска в navigation bar
        
        navigationItem.searchController = searchController
        
        // позвоялем отпускать строку поиска при переходе на другой экран
        
        definesPresentationContext = true
        
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // если isFiltering возвращает тру то
        // отображаем количесво ячеек из массива filteredPlaces
        // иначе из массива places
        
        if isFiltering {
            return filteredPlaces.count
        }
    
        // если база пустая возвращаем количесво ячеек 0
        // если нет то возвращаем количесво ячеек равной
        // количеству моделей в базе
        
        return places.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        // если isFiltering тру то присваиваем массиву place
        // значения из массива filteredPlaces по индексу
        // если fals то присваиваем массиву place
        // значения из массива places по индексу
        
        let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]

        cell.nameLabel.text = place.name
        cell.locationlabel.text = place.location
        cell.typeLabel.text = place.type
        
        // imageData не будет пустым можем извлечь принудительно
        
        cell.imageOfPlace.image = UIImage(data: place.imageData!)

        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    // метод вызывающий дейсвие при свайпи ячейки
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // определяем обьекст для удаления
        // берем обьект из массива places по индексу текущей строки
        
        let place = places[indexPath.row]
        
        // создаем дейсвие удаления с загодлвком "Delete"
        // параметр стаил ставим дефолд что бы наша кнопка была красной
        
        let deleteAction = UITableViewRowAction(style: .default,
                                                title: "Delete") { (_, _) in
            
            // удаляем обьект из базы данных
            
            StorageManager.deleteObject(place)
            
            // удаляем строку по индексу
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        // возвращаем дейсвие deleteAction в виде массива как и просит метод
        
        return [deleteAction]
        
    }
    
    // убираем выделение кнопки при нажатии 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // проверяем переход на равеносво с showDetail
        // с помощью переоределения init и его параметра identifier
        // который является опциональным стрингом
        
        if segue.identifier == "showDetail" {
            
            // извлекаем индекс ячейки котрую нажали
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            // повторяем тот же если иначе что бы
            // выбиралась ячейка при фитрации кореткно
            // в виду того что у нас два разных массива
            // а ячейка для редактирования выбирается из основного массива
            // при фильтрации мы выбирали не коретную ячейку так как индексы ячеек
            // не совпадали для этого мы сделали выбор ячейки в зависимости
            // если текст в поисковике или нет
            
            let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
            
            // передаем данные с ячейки которую выбрали в NewPlaceViewController
            // с помощью атрибута destination у segue
            
            let newPlaceVC = segue.destination as! NewPlaceViewController
            
            // обращаемся к экземпляру newPlaceVC и его свойству
            // currentPlace назначая в него выбраный place
            
            newPlaceVC.currentPlace = place
            
        } else {
            
        }
        
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        // создаем экземпляр класса NewPlaceViewController в константе NewPlaceVC
        // через segue обращаемся к source
        // что бы передать данные с контролера на который переходили ранее
        // на контролеер с которого мы перешли на контролер от куда и будем брать данные
        // для заполнение информации ячейки
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        
        // вызываем метод saveNewPlace
        // из экземпляра класа
        
        newPlaceVC.savePlace()
        
        // обновляем данные таблицы для отображения нового места в ячейки
        
        tableView.reloadData()
    }
    
    @IBAction func cancelButton(_ segue: UIStoryboardSegue) { }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
        // вызываем метод сортировки
        
        sorting()
        
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        
        // меняем значение на противоположное
        // с помощью переключателя
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            
            // усли тру то выбираем стрелочками вверх
            
            reversedSortingButton.image = UIImage(named: "ZA")
        } else {
            
            // иначе стрелками вниз
            
            reversedSortingButton.image = UIImage(named: "AZ")
        }
        
        // вызываем метод сортировки
        
        sorting()
        
    }
    
    private func sorting() {
        
        // если выбран первый селектор по индексу 0
        // сортируем с ключем и по возрастанию или убыванию
        // подставляя булевое значение ascendingSorting
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            // сортируем данные по дате добавления
            
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
            
        } else {
            
            // сортируем данные по имени
            
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
            
        }
        
        // обновляем таблице что бы отобразились наши сортировки
        
        tableView.reloadData()
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // вызываем метод фильтрации поставляя туда
        // подставляем в параметр значение из поиской строки
        // можем извлеч опцианал так как метод updateSearchResults будет вызываться
        // только когда будем нажимать на поисковую строку
        // даже если строка будет пустой она не будут нил
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    // метод фильтрации контента
    
    private func filterContentForSearchText(_ searchText: String) {
        
        // заполняем массив отфильтроваными результатами
        // выполняем поиск по полям name и location
        // поиск совершаем по CONTAINS
        // в независимости от регистра символов указав [c]
        // в %@ подставляются переменная searchText
        
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@",
        searchText, searchText)
        
        // обновляем таблицу
        
        tableView.reloadData()
        
    }
    
}
