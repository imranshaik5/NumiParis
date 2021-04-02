//
//  ApiLists.swift
//  NumiParis
//
//  Created by imran shaik on 01/04/21.
//

import Foundation

// @@@@@@@@ MARK:- Typealias @@@@@@@@@@

typealias ApiResponse = (status:Status,data:Any,message:String)
typealias ApiData = (data:Data, response:URLResponse?)

enum Result<T:Decodable> {
    case success(data:T) //Success response
    case failure(message:String)//APi call error
    case error(message:String) //Network error
}

enum ApiStatus {
    case NoData
    case NetworkError
    case Success
    case Error
    case Failure
}



// @@@@@@@@ MARK:- Enum @@@@@@@@@@

public enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum Status{
    case success,failure
}


enum Endpoints:String {
    case topRatedMovie = "top_rated?api_key=6baeb7bf25efbc6faab82b09cdd51fb9"
    case upComingMovie = "upcoming?api_key=6baeb7bf25efbc6faab82b09cdd51fb9"

    static var baseUrl =  "https://api.themoviedb.org/3/movie/"
//    https://api.themoviedb.org/3/movie/top_rated?api_key=6baeb7bf25efbc6faab82b09cdd51fb9
//    https://api.themoviedb.org/3/movie/upcoming?api_key=6baeb7bf25efbc6faab82b09cdd51fb9

}




enum StatusCode:Int {
    case success = 200
    case accepted = 202
    case error = 204
    case validation = 422
    case notFound = 404
    case badRequest = 400
    case bad = 503
    case logout = 401
    case noInternet = 0
    case internalServerError = 500
}

protocol APIResponseDelegate {
    func onSuccess()
    func onFailure(message:String)
}





