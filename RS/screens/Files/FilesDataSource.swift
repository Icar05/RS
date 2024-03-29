//
//  FilesDataSource.swift
//  HobbyRandomizer
//
//  Created by ICoon on 23.06.2022.
//

import Foundation

protocol FileDataSourceDelegate: NSObject{
    func onItemSelected(model: DisplayFileCellModel)
}

class FilesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate{
    
    
    private var data: [DisplayFileCellModel] = []
    
    weak var delegate: FileDataSourceDelegate? = nil
    
    func setData(data: [DisplayFileCellModel]){
        self.data = data
    }
    
    func getIdentifier() -> String{
        return String(describing: DisplayFileCell.self)
    }
    
    func getQuestionIdentifier() -> String{
        return String(describing: DisplayQuestionCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func isNotEmpty() -> Bool {
        return self.data.count > 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: getIdentifier(), for: indexPath) as! DisplayFileCell
        cell.configure(model: self.data[indexPath.row])
        cell.modify()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.data[indexPath.row]
        self.delegate?.onItemSelected(model: model)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    
}


