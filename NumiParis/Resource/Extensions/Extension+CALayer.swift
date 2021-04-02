//
//  Extension+CALayer.swift
//  NumiParis
//
//  Created by imran shaik on 02/04/21.
//

import UIKit

extension CALayer {
    //Can apply shadow to the layer - Include all UIElement
    func applySketchShadow(color: UIColor = .black,alpha: Float = 0.7,x: CGFloat = 0,y: CGFloat = 5,blur: CGFloat = 12,spread: CGFloat = 6){ //All params are optional, if the param is not passed, it will take the default value
        shadowColor = color.cgColor
        masksToBounds = false
        shadowOpacity = alpha
        shadowOffset = CGSize.zero
        shadowRadius = blur
    }
    
    func setGradientEffect(colorTop: UIColor, colorBottom: UIColor,location: [NSNumber]){
        //Give gradient effect to the view
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = [colorTop.cgColor, //Color from top tp bottom(Increase step by step)
                                colorBottom.withAlphaComponent(0.3).cgColor,
                                colorBottom.withAlphaComponent(0.5).cgColor,
                                colorBottom.withAlphaComponent(0.7).cgColor]
        gradientLayer.locations = location //Location for setting that colors array to the view
        self.addSublayer(gradientLayer) //Add as sublayer
    }
}
