//
//  RandomParser.swift
//  RS
//
//  Created by ICoon on 24.07.2022.
//


import Foundation
import UIKit

/**
 ➫  item ° Description
 */


class RandomParser : Parser{
    
    
    
    func isAppropriatedParcer(key: String) -> Bool {
        return key == "Random"
    }
    
    func parseData(input: String) -> [RandItemCellModel] {
        
        var models: [RandItemCellModel] = []
        
//        input.split(separator: "➦").tail.forEach{
            
//            let subString = $0.split(separator: "➫")[0]
            
//            if  let type = getType(value: String(subString).withoutSpecialCharacters){
                let items = input.split(separator: "➫").tail
                items.forEach{
                    
                    let content = $0.split(separator: "°")
                    let model = RandItemCellModel(
                        title: content[0].trimmingCharacters(in: .whitespacesAndNewlines),
                        subTitle: content[1].trimmingCharacters(in: .whitespacesAndNewlines),
                        type: .Random)
                    
                    models.append(model)
                }
//            }
//        else{
//                print("MainParser: \(String($0)) not type")
//            }
            
//        }
        
        return models
    }
    
}
