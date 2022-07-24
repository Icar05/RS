//
//  MenuPresenter.swift
//  HobbyRandomizer
//
//  Created by ICoon on 07.06.2022.
//

import Foundation

public final class MenuPresenter{
    
    
    unowned var view: MenuViewController!
    
    public func set(view: MenuViewController) {
        self.view = view
    }
    
    func viewDidLoad(){
        let data = prepareDataSource()
        self.view.didDataUpdate(data: data)
    }
    
    private func prepareDataSource() -> [MenuCellModel]{
        return [
            MenuCellModel(
                icon:UIImage(systemName: "plus.rectangle.on.folder")!,
                type: .Create,
                title: Translations.Menu.itemCreate
            ),
            MenuCellModel(
                icon:  UIImage(systemName: "wrench")!,
                type: .Test,
                title: Translations.Menu.itemTest
            ),
            MenuCellModel(
                icon:  UIImage(systemName: "suit.spade")!,
                type: .Casino,
                title: Translations.Menu.itemCasino
            ),
            MenuCellModel(
                icon:  UIImage(systemName: "filemenu.and.cursorarrow")!,
                type: .Todo,
                title: Translations.Menu.itemTodo
            ),
            MenuCellModel(
                icon:  UIImage(systemName: "chart.line.uptrend.xyaxis")!,
                type: .HardDayNight,
                title: Translations.Menu.itemHardDayNight
            ),
            MenuCellModel(
                icon:  UIImage(systemName: "gamecontroller")!,
                type: .WeekEnd,
                title: Translations.Menu.itemWeekend
            ),
            MenuCellModel(
                icon:  UIImage(systemName: "flag.filled.and.flag.crossed")!,
                type: .YesNo,
                title: Translations.Menu.itemYesNo
            ),
            MenuCellModel(
                icon:  UIImage(systemName: "folder")!,
                type: .Files,
                title: Translations.Menu.itemFiles
            ),
            MenuCellModel(
                icon:  UIImage(systemName: "gearshape")!,
                type: .Settings,
                title: Translations.Settings.settings
            )
        ]
    }
    
    
}
