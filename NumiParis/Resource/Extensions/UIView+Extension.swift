//
//  UIView+Extension.swift
//  NumiParis
//
//  Created by imran shaik on 02/04/21.
//

import UIKit

enum VerticalLocation: String {
    case bottom
    case top
}

private enum Axis: StringLiteralType {
    case x = "x"
    case y = "y"
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat { //Corner radius in storyboard
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderwidth: CGFloat { //borderwidth in storyboard
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var bordercolor: UIColor { //bordercolor in storyboard
        get {
            return self.bordercolor
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    func setBottomBorder(blackColor:Bool) { //border in storyboard
        if blackColor == true{
            self.layer.backgroundColor = UIColor.black.cgColor
        } else{
            self.layer.backgroundColor = UIColor.white.cgColor
        }
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    class func loadFromNibNamed(nibNamed: String, bundle: Bundle? = nil,index: Int) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[index] as? UIView
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addShadow(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor  =  UIColor.clear.cgColor
        self.layer.borderWidth = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor =  UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width:5, height: 5)
        self.layer.masksToBounds = false
    }
    
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    
    func flipTransition (with view1: UIView, view2: UIView, isReverse: Bool = false) {
        var transitionOptions = UIView.AnimationOptions()
        transitionOptions = isReverse ? [.transitionFlipFromLeft] : [.transitionFlipFromRight] // options for transition
        
        // animation durations are equal so while first will finish, second will start
        // below example could be done also using completion block.
        
        UIView.transition(with: view1, duration: 1.0, options: transitionOptions, animations: {
            view1.isHidden = true
        })
        
        UIView.transition(with: view2, duration: 1.0, options: transitionOptions, animations: {
            view2.isHidden = false
        })
    }
    
    func image() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
//            print("no action")
        }
    }
   
    func setGradientBackground() {
        let layer = CAGradientLayer()
        layer.colors = [
          UIColor(red: 0.05, green: 0.2, blue: 0.59, alpha: 1).cgColor,
          UIColor(red: 0.16, green: 0.33, blue: 0.79, alpha: 1).cgColor
        ]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        layer.bounds = self.bounds.insetBy(dx: -0.5*self.bounds.size.width, dy: -0.5*self.bounds.size.height)
        layer.position = self.center
        self.layer.insertSublayer(layer, at: 0)
//        self.layer.addSublayer(layer)
    }
    
    private func shake(on axis: Axis) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.\(axis.rawValue)")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        layer.add(animation, forKey: "shake")
    }
    func shakeOnXAxis() {
        self.shake(on: .x)
    }
    func shakeOnYAxis() {
        self.shake(on: .y)
    }
}
