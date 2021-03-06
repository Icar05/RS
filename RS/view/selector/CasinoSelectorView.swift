//
//  CasinoSelectorView.swift
//  HobbyRandomizer
//
//  Created by Apple Mac Book on 14.10.2021.
//

import UIKit

@IBDesignable
class CasinoSelectorView: UIView {
    
    
    
    
    
    fileprivate var viewDrawUtil = ViewDrawUtil()
    
    fileprivate var viewWidth: CGFloat = 300
    
    fileprivate var viewHeith: CGFloat = 400
    
    fileprivate let padding = 20
    
    fileprivate var textLayer = CATextLayer()
    
    fileprivate var model: RandomizerModel? = nil
    
    
    override func prepareForInterfaceBuilder(){
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    override var bounds: CGRect {
        didSet {
            self.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeith)
        }
    }
    
    
    fileprivate func setup(){
        self.layer.bounds.size = CGSize(width: CGFloat(viewHeith), height: CGFloat(viewHeith))
        self.layer.masksToBounds = true
        self.backgroundColor = .white.withAlphaComponent(0)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    override func draw(_ rect: CGRect) {
        let y = (Int(viewHeith) / 3 * 2) + 10
        let start = CGPoint(x: padding, y: y)
        let end = CGPoint(x: Int(viewWidth) - padding, y: y)
        self.drawLineFromPointToPoint(start: start, end: end, lineWidth: 50, color: UIColor.brown)
                
        if(model == nil){
            self.drawCircle(size: 40, color: .orange, yOffset: y - 20)
            self.drawText(text: "?")
        }else{
            self.displayWinner(model: self.model!)
        }
        
        
    }
    
    fileprivate func getAttributedString(input: String) -> NSAttributedString{
        let dict:NSDictionary = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeWidth: 5,
            NSAttributedString.Key.strokeColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "EuphemiaUCAS", size: 25)!
        ]
        return NSAttributedString(string: input, attributes: dict as? [NSAttributedString.Key : Any])
    }
    
    func updateModel(model: RandomizerModel){
        self.model = model
        self.displayWinner(model: model)
    }
    
    func clearSelection(){
        let y = (Int(viewHeith) / 3 * 2) + 10
        self.model = nil
        self.drawCircle(size: 40, color: .orange, yOffset: y - 20)
        self.drawText(text: "?")
    }
    
    fileprivate func displayWinner(model: RandomizerModel){
        let y = (Int(viewHeith) / 3 * 2) + 10
        self.drawCircle(size: 40, color: model.color, yOffset: y - 20)
        self.drawText(text: "\(model.index)")
    }
    
    
    
    fileprivate func drawText(text: String){
        
        let startX = Int(viewWidth / 2) - 25
        let startY = (Int(viewHeith) / 3 * 2) - 8
        
        textLayer.removeFromSuperlayer()
        textLayer = CATextLayer()
        textLayer.string = getAttributedString(input:text)
        textLayer.alignmentMode = .center
        textLayer.frame = CGRect(x: Int(startX), y: startY, width: 50, height: 40)
        
        layer.addSublayer(textLayer)
        
    }
    
    
    
    fileprivate func drawLineFromPointToPoint(start: CGPoint, end: CGPoint, lineWidth: CGFloat, color: UIColor) {
        
        let shapeLayer = self.viewDrawUtil.drawLineFromPointToPoint(start: start, end: end, lineWidth: lineWidth, color: color)
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    fileprivate func drawCircle(size: CGFloat, color: UIColor, yOffset: Int){
        
        let point = CGPoint(x: (viewWidth - size) / 2, y: CGFloat(yOffset))
        let circleLayer = self.viewDrawUtil.drawCircle(size: size, color: color, point: point, strokeColor: .black)
        
        layer.addSublayer(circleLayer)
    }
    
    
    
}



