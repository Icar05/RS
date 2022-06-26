//
//  extensions.swift
//  HobbyRandomizer
//
//  Created by Apple Mac Book on 14.10.2021.
//

import UIKit


extension UIColor {
    static let coolGreen = UIColor(hexColor: "349C52")
    static let coolRed = UIColor(hexColor: "E30002")
    static let coolOrange = UIColor(hexColor: "FAA602")
    static let colorMain = UIColor(named: "MainColor")
    static let colorBorderGray = UIColor(named: "BorderGray")
    static let colorCappuccino = UIColor(named: "Cappuccino")
    static let colorCocoa = UIColor(named: "Cocoa")
}

extension UITableViewCell{
    func modify(){
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        selectionStyle = .none
    }
}


extension UIViewController{
    func showAlert(model: RandItemCellModel){
        let alert = UIAlertController(title: model.title, message: model.subTitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showAlert(title: String, subtitle: String){
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension UIImageView{
    func border(){
        layer.masksToBounds = true
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.colorBorderGray?.cgColor
        layer.cornerRadius = 8
    }
}


public extension UIImage {
    convenience init?(source: String, bundle: Bundle) {
        if #available(iOS 13.0, *) {
            self.init(named: source, in: bundle, with: .none)
        } else {
            self.init(named: source)
        }
    }
}

extension UIImageView{
    func setImageColor(color: UIColor){
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

extension UIColor {
    public convenience init?(hexColor: String){
        var cString:String = hexColor.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return nil
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        return
    }
}

extension String{
    
    
    
    //right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
                ,leftRange.upperBound <= rightRange.lowerBound else { return nil }
        
        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }
    
    var withoutSpecialCharacters: String {
        return self.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
    }
    
    func truncate(length: Int, trailing: String = "") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }
    
    func titleCase() -> String {
        return self
            .replacingOccurrences(of: "([A-Z])",
                                  with: " $1",
                                  options: .regularExpression,
                                  range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized // If input is in llamaCase
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }
    
    func localized(_ args: [CVarArg]) -> String {
        return localized(args)
    }
    
    func localized(_ args: CVarArg...) -> String {
        return String(format: localized, args)
    }
}

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
        object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}


extension Array {
    
    var tail: Array {
        return Array(self.dropFirst())
    }
    
}
