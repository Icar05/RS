//
//  CreateViewDataSource.swift
//  HobbyRandomizer
//
//  Created by ICoon on 08.06.2022.
//

import Foundation

protocol CreateDataSourceDelegate: NSObject{
    func onModelCreated(freshModels: [RandItemCellModel])
    func onModelDeleted(freshModels: [RandItemCellModel])
}

class CreateViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, CreateViewDelegate {
    
    
    
    private var dataSourse: [RandItemCellModel] = []
    
    weak var delegate: CreateDataSourceDelegate? = nil
    
    
    func setData(data: [RandItemCellModel]){
        self.dataSourse = data
    }
    
    func getRandCellIdentifier() -> String{
        return String(describing: RandItemCell.self)
    }
    
    func getCreateItemCellIdentifier() -> String{
        return String(describing: CreateNewItemCell.self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourse.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: getCreateItemCellIdentifier(), for: indexPath) as! CreateNewItemCell
            cell.modify()
            cell.setupDelegate(delegate: self)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: getRandCellIdentifier(), for: indexPath) as! RandItemCell
        cell.configure(model: self.dataSourse[indexPath.row - 1])
        cell.modify()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return indexPath.row == 0 ? 300: 100
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.row == 0 ? UITableViewCell.EditingStyle.none : UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete && indexPath.row > 0 {
            self.dataSourse.remove(at: indexPath.row - 1)
            self.delegate?.onModelDeleted(freshModels: self.dataSourse)
        }
    }
    
    func onItemCreated(item: RandItemCellModel) {
        self.dataSourse.append(item)
        self.delegate?.onModelCreated(freshModels: self.dataSourse)
    }

    
}