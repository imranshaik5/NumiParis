//
//  UpComingMoviesViewModel.swift
//  NumiParis
//
//  Created by imran shaik on 02/04/21.
//

import UIKit

class UpComingMoviesViewModel: NSObject {
    var errorMessage = String()
    //MARK:- Function For Api handeling
    func apiForGetUpComingMovies(_ params:DictionaryType, _ completion:@escaping(_ status : ApiStatus,_ data: [UpcomingResults]?) -> ()){
        ApiRequest.sharedInstance.apiRequest(baseUrl: Endpoints.baseUrl, url: Endpoints.upComingMovie.rawValue, parameter: params, method: .get) { (status:Result<UpComingData>) in
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
