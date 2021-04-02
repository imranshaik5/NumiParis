//
//  ApiRequest.swift
//  NumiParis
//
//  Created by imran shaik on 01/04/21.
//

import Foundation
import UIKit


let APIREQUEST = ApiRequest.sharedInstance

class ApiRequest{
    
//    var cryptLib = CryptLib()

    static let sharedInstance:ApiRequest = {
        let instance = ApiRequest()
        return instance
    }()
    
    var result = String()

    //----------------------------------------------------------------------------
    // @@@@@@@@@@@@@@@@@@@@@@@@@@@ MARK:- ApiRequest @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    //----------------------------------------------------------------------------
    
    func apiRequest<T:Decodable>(baseUrl:String,url:String,parameter: DictionaryType,method:HTTPMethod,completion: @escaping (Result<T>) -> ())
    {
         Internet.isAvailable(completion: { (status, message) in
            if status{
            print("Passed Parameter : \(parameter)")
                self.configRequest(baseUrl:baseUrl ,url: url, method: method,parameter:parameter, completion: { (response) in
                DispatchQueue.main.async {
                    completion(response)
                }
            })
            }
            else{
                DispatchQueue.main.async {
                    completion(Result<T>.failure(message: message))
                }
            }
        })
    }
    
    
    //----------------------------------------------------------------------------
    // @@@@@@@@@@@@@@@@@@@@ MARK:- ApiRequest Multipart Data @@@@@@@@@@@@@@@@@@@@
    //----------------------------------------------------------------------------
    
    func ApiRequestWithMultipartData<T:Decodable>(baseUrl:String,url:String,type:String = "image/jpeg",images:imageParamArray,parameter: [String:Any],method:HTTPMethod,completion: @escaping (Result<T>) -> ())
    {
        Internet.isAvailable(completion: { (status, message) in
            if status{
                let req = MultipartdataRequest()
                req.apiRequest(baseUrl: baseUrl, url: url, method: .post, parameter: parameter, type: type, multipartData: images, completion: {(response) in
                    completion(response)
                })
            }
            else{
                completion(Result<T>.failure(message: message))
            }
        })
    }
    
    
    //-----------------------------------------------------------------------------------
    //@@@@@@@@@@@@@@@@@@@@ MARK:- Configure Request Based on ApiType @@@@@@@@@@@@@@@@@@@@
    //-----------------------------------------------------------------------------------
    
    func configRequest<T:Decodable>(baseUrl:String,url:String,method:HTTPMethod,parameter:Any,completion: @escaping (Result<T>) -> ())
    {
        
        guard let urlString = URL(string: baseUrl + url) else { return }
        var request = URLRequest(url: urlString)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(KeychainManager.getToken() as String? ?? "", forHTTPHeaderField: "Authorization")
        
        debugPrint("Headers",request.allHTTPHeaderFields)
        
        debugPrint("Base URL : \(request.url)")



        if method == .post || method == .put || method == .delete || method == .patch
        {
            request.httpBody  = try! JSONSerialization.data(withJSONObject: parameter as! DictionaryType, options:[])
        }
        URLSession.shared.dataTask(with:request ) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                completion(Result<T>.error(message: "Please try again later"))
                return
            }
//            let stringData = String(data: data, encoding: .utf8)
//
//            guard let decryptResponse = self.cryptLib.decryptCipherTextRandomIV(withCipherText: stringData, key: Constant.sharedInstance.secret) else { return }
//
//            let responseData = Data(decryptResponse.utf8)
            
            let apiData = (data:data, response:response)
            
            let model = responseDecode(response: apiData, modelType: T.self) //Get response of respective model class
            completion(model)
            }.resume()
        
    }
    
}




