//
//  TopRatedMoviesViewModel.swift
//  NumiParis
//
//  Created by imran shaik on 01/04/21.
//

import UIKit

class TopRatedMoviesViewModel: NSObject {
    var errorMessage = String()
    //MARK:- Function For Api handeling
    func apiForGetTopRating(_ params:DictionaryType, _ completion:@escaping(_ status : ApiStatus,_ data: [Results]?) -> ()){
        ApiRequest.sharedInstance.apiRequest(baseUrl: Endpoints.baseUrl, url: Endpoints.topRatedMovie.rawValue, parameter: params, method: .get) { (status:Result<TopRatedData>) in
            switch status {
            case .success(let data):
//                                self.errorMessage = "\(data.results)"
                completion(.Success,data.results)
            case .failure(let message):
                self.errorMessage = message
                completion(.Failure,nil)
            case .error(let message):
                self.errorMessage = message
                completion(.Error,nil)
            }
        }
    }
    
}
