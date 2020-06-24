//
//  CornerView.swift
//  sample-chat-swift
//
//  Created by Anton Sokolchenko on 3/31/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

import UIKit

@IBDesignable
class CornerView: UIView {
    @IBInspectable var title: String = "" { didSet { self.setNeedsDisplay() } }
    @IBInspectable var fontSize: Float = 16 { didSet { self.setNeedsDisplay() } }
    @IBInspectable var cornerRadius:CGFloat = 6 {
        didSet(oldRadius) {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentMode = UIView.ContentMode.redraw
    }
    
    func drawWithRect(rect: CGRect, text:String, fontSize:Float){

        let style = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.alignment = NSTextAlignment.center
        
		guard let fontAttributeName = UIFont(name: "Helvetica", size: CGFloat(fontSize)) else {
			return
		}
			
		let rectangleFontAttributes: [String: Any] = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): fontAttributeName,
			convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white,
			convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): style]
		
		let rectOffset = rect.offsetBy(dx: 0, dy: ((rect.height - text.boundingRect(with: rect.size, options:.usesLineFragmentOrigin, attributes:convertToOptionalNSAttributedStringKeyDictionary(rectangleFontAttributes), context: nil).size.height)/2))
		
		NSString(string: text).draw(in: rectOffset, withAttributes: convertToOptionalNSAttributedStringKeyDictionary(rectangleFontAttributes))
    }
	
    override func draw(_ rect: CGRect) {
        self.drawWithRect(rect: self.bounds, text: self.title, fontSize: self.fontSize)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
