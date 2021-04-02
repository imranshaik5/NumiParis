//
//  ValidateResponse.swift
//  NumiParis
//
//  Created by imran shaik on 01/04/21.
//

import Foundation

typealias DictionaryType = [String:Any]


//----------------------------------------------------------------------------
//  @@@@@@@@@@ MARK:- VALIDATE RESPONSE DATA @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//----------------------------------------------------------------------------



 func responseDecode<T:Decodable>(response:ApiData,modelType:T.Type)-> Result<T>{
    //Decode the response to respective model class
    var dict = DictionaryType()
    if let httpResponse = response.1 as? HTTPURLResponse
    {
       
        let code:Int = httpResponse.statusCode
        let status = StatusCode(rawValue: code) ?? .bad
        let jsonValue = try? JSONSerialization.jsonObject(with: response.data, options: []) as! [String: AnyObject]
        print(jsonValue)
        switch status{
        case .success:
            do{
            let model = try JSONDecoder().decode(modelType.self, from: response.data)
               return Result<T>.success(data: model)
            }catch (let error){
               print(error)
            }
        case .accepted,.validation:
            do {
                let json = try JSONSerialization.jsonObject(with: response.data, options: []) as! [String: AnyObject]
                 return Result<T>.failure(message: json["message"] as? String ?? "")
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        case .error:
            return Result<T>.error(message: "Connection error, please try again")
//        case .notFound:
//            return Result<T>.failure(message: "Data not found")
        case .badRequest, .notFound:
            do {
                let json = try JSONSerialization.jsonObject(with: response.data, options: []) as! [String: AnyObject]
                return Result<T>.failure(message: json["message"] as? String ?? "")
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        case .bad:
            do {
                let json = try JSONSerialization.jsonObject(with: response.data, options: []) as! [String: AnyObject]
                return Result<T>.failure(message: json["message"] as? String ?? "")
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        case .logout:
            break
//            Constant.appDelegate.setLoginAsRootViewController()
            //return Result<T>.failure(message: "Unauthorized Logout")
        case .noInternet:
            return Result<T>.failure(message: "No internet")
        case .internalServerError:
            return Result<T>.failure(message: "Connection error, please try again")
        }
    }
    return Result<T>.failure(message: "Connection error, please try again")
}


