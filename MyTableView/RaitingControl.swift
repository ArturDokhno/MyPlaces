//
//  RaitingControl.swift
//  MyTableView
//
//  Created by Артур Дохно on 03.12.2021.
//

import UIKit
import SwiftUI

// @IBDesignable позволяет увидить верстку кодом в сториборде

@IBDesignable class RaitingControl: UIStackView {
    
    // MARK: - Properties
    
    private var retingButtons = [UIButton]()
    
    // свойсво отвечает за размер звезд
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        
        // назначаем наблюдателя за именениями свойстава
        // это что бы через сториборд менять зачения кнопок
        
        didSet {
            setupButtons()
        }
    }
    
    // свойсво отвечает за количесво звезд
    
    @IBInspectable var starCount: Int = 5 {
        
        // назначаем наблюдателя за именениями свойстава
        // это что бы через сториборд менять зачения кнопок 
        
        didSet {
            setupButtons()
        }
    }
    
    // здесь будем хранить рейтинг места
    // вызываем метод рейтинга в переменую рейтинг для отслеживания изменений
    
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    // MARK: - Initoalization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // вызываем наш метод создание кнопки и добавления ее в стеквью
        
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        // вызываем наш метод создание кнопки и добавления ее в стеквью
        
        setupButtons()
    }
    
    // MARK: - Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        
        // определеяем индекс кнопки которую нажал пользователь
        // firstIndex возвращяет индекс первого найденого элемента или вернет nil
        
        guard let index = retingButtons.firstIndex(of: button) else { return }
        
        // определяем рейтинг выбраной звезды
        // создаем константу в которую будем присваивать порядковый номер выбраной звезды
        
        let selectedRating = index + 1
        
        // если рейтинк выброной звезды будет совпадать
        // с текущим рейтингом то обнуляем
        // или присваиваем ей выбраный ретинг
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    
    // MARK: - Private Methods
    
    // cоздаем метод для добавления кнопки в стек
    // этот метод вызывается только раз при загрузки приложения
    
    private func setupButtons() {
        
        // позволяет назначить новый размер кнопкам и их
        // количесво через сторибор заменяя то что прописано в коде
        // через цикл перебираем массив и удаляем кнопки
        
        for button in retingButtons {
            
            // удаляем кнопки из сабвью
            
            removeArrangedSubview(button)
            
            // удаляем кнопки из стека
            
            button.removeFromSuperview()
        }
        
        // очищаем сам массив
        
        retingButtons.removeAll()
        
        // делаем так что бы наши кнопки отображались в сториборд
        // Bundle данный класс определяет место положение
        // ресурсов которые хранятся в Assets
        // в качесве класса выбираем собсвеный класс
        
        let bundle = Bundle(for: type(of: self))
        
        // загружаем картинки для кнопкок
        // traitCollection убеждаемся что загруженые верные изображения
        
        let fillStar = UIImage(named: "filledStar",
                               in: bundle,
                               compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle,
                                compatibleWith: self.traitCollection)
        
        let highlightedStar = UIImage(named: "highlightedStar",
                                      in: bundle,
                                      compatibleWith: self.traitCollection)
        
        
        
        // цикл для создание пяти кнопок
        
        for _ in 1...starCount {
            
            // создаем кнопку
            
            let button = UIButton()
            
            // устанавливаем для кнопки изображение
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(fillStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // устанавливай false что бы отключить автоматичейкие
            // сгенерированные констрейнты
            // в стек вью данный параметр отклбючен по умолчанию
            // поэтому можно его и удалить
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // добавляем высоту ячейки и ширину
            // и активируем данные констрейнты
            
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // вызываем метод нажатия на клавишу
            
            button.addTarget(self, action: #selector(ratingButtonTapped(button: )), for: .touchUpInside)
            
            // помещаем кнопку в стек
            
            addArrangedSubview(button)
            
            // помещяем созданую кнопку в массив
            
            retingButtons.append(button)
        }
        
        // вызываем метод присвоения ретинга
        
        updateButtonSelectionState()
    }
    
    // метод будет проходить итерацию по всем кнопка и устанавливать
    // соотвествующий рейтинг для звезды
    
    private func updateButtonSelectionState() {
        
        // enumerated() будет возвращять пару обьект и его индекс
        // c помощью него получю идекс кнопки
        
        for (index, button) in retingButtons.enumerated() {
            
            // берем кнопку и присваиваем ей тру или фолс
            // если индекс кнопки будет меньше рейтинга
            // то свойствуй isSelected будет присваиваться тру
            // и кнопка отобразит заполненую звезду
            // или присвоется фолс и звезда будет не заполненой
            
            button.isSelected = index < rating
            
        }
    }
}
