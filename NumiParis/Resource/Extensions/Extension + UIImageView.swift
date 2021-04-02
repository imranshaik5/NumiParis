//
//  Extension + UIImageView.swift
//  NumiParis
//
//  Created by imran shaik on 01/04/21.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImage(with urlString : String?,placeHolder placeHolderImage : UIImage?) {
        let activity = UIActivityIndicatorView()
        activity.tag = 100
        let activityHeight = self.frame.height/3
        let activityWidth = self.frame.width/3
        activity.tintColor = .darkGray
        activity.frame = CGRect(x: self.frame.origin.x, y: (self.frame.height/2)-(activityHeight*0.5), width: activityWidth, height: activityHeight)
//        activity.center = self.center
        self.addSubview(activity)
        activity.startAnimating()
        guard urlString != nil, let imageUrl = URL(string: urlString!) else {
            self.image = placeHolderImage
            self.stopActivity(image: self)
            return
        }
        if let image = Cache.shared.object(forKey: urlString! as AnyObject) {
            self.stopActivity(image: self)
            self.image = image
        } else {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                guard data != nil, let imagePic = UIImage(data: data!), let responseUrl = response?.url?.absoluteString else {
                    DispatchQueue.main.async {
                        self.stopActivity(image: self)
                        self.image = placeHolderImage
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.stopActivity(image: self)
                    self.image = imagePic
                }
                Cache.shared.setObject(imagePic, forKey: responseUrl as AnyObject)
                }.resume()
        }
    }
    
    func stopActivity(image:UIImageView)  {
        for activity in image.subviews {
            if activity.tag == 100 {
                activity.removeFromSuperview()
            }
        }
    }
}
