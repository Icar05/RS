//
//  RandItemCellModel.swift
//  HobbyRandomizer
//
//  Created by ICoon on 08.06.2022.
//

import Foundation

enum ItemType: String, Codable, CaseIterable{
    case ToDo, HardDayNight, HappyWeekend
}

struct RandItemCellModel: Codable{
    var title: String
    var subTitle: String
    var type: ItemType
}

extension ItemType{
    
    func getTitle() -> String{
        switch self {
        case .ToDo:
            return Translations.Create.typeTodo
        case .HardDayNight:
            return Translations.Create.typeHardDayNight
        case .HappyWeekend:
            return Translations.Create.typeHappyWeekend
        }
    }
    
    func getImage() -> UIImage{
        switch self {
        case .ToDo:
            return UIImage(source: "work", bundle: .main)!
        case .HardDayNight:
            return UIImage(source: "hobby", bundle: .main)!
        case .HappyWeekend:
            return UIImage(source: "progress", bundle: .main)!
        }
    }
    
    func getColorForType() -> UIColor{
        switch self {
        case .ToDo:
            return UIColor.coolRed!
        case .HardDayNight:
            return UIColor.coolGreen!
        case .HappyWeekend:
            return UIColor.coolOrange!
        }
    }
}
