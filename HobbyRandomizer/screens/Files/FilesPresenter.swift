//
//  FilesPresenter.swift
//  HobbyRandomizer
//
//  Created by ICoon on 23.06.2022.
//

import Foundation

public final class FilesPresenter{
    
    
    
    private let filesUtil: FileWriterUtil
    
    unowned var view: FilesViewController!
    
    public func set(view: FilesViewController) {
        self.view = view
    }
    
    init(filesUtil: FileWriterUtil){
        self.filesUtil = filesUtil
    }
    
    func viewDidLoad(){
        let data = filesUtil.readAllFilenames()
        self.view.onDataLoaded(data: data)
    }
    
    func parseFileData(fileName: String){
        
        let result: Any  = filesUtil.importModels(fileName: fileName) as Any
    
        if(result is [RandItemCellModel]){
            view.displayModels(data: result as! [RandItemCellModel])
            return
        }
        
        if(result is String){
            view.displayText(data: result as! String)
        }
        
        return
        
    }
    
    func removeItemByName(fileName: String){
        let result = filesUtil.removeItem(fileName: fileName)
        view.didFileRemoved(value: result)
    }
    
}
