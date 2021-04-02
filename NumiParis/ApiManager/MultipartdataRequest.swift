//
//  MultipartdataRequest.swift
//  NumiParis
//
//  Created by imran shaik on 01/04/21.
//

import Foundation
import UIKit

let ApiMultipartRequest = MultipartdataRequest.sharedInstance
typealias imageParamArray = [(key:String,image:Data)]

class MultipartdataRequest:NSObject{
    
//    var cryptLib = CryptLib()

    static let sharedInstance:MultipartdataRequest = {
        let instance = MultipartdataRequest()
        return instance
    }()
    
    var result = String()

    func apiRequest<T:Decodable>(baseUrl:String,url:String,method:HTTPMethod,parameter:Any,type:String ,multipartData:imageParamArray,completion:@escaping(Result<T>) ->())
    {

        
        guard let urlString = URL(string: Endpoints.baseUrl + url) else { return }
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(KeychainManager.getToken() as? String ?? "", forHTTPHeaderField: "Authorization")
        request.addValue("3", forHTTPHeaderField: "User-Type")

        debugPrint("Headers",request.allHTTPHeaderFields)
        debugPrint("URL",urlString)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let data  = createBody(url:url,parameters: parameter as! [String : Any],boundary: boundary,images: multipartData,mimeType: type)
        let session:URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        let task: URLSessionUploadTask = session.uploadTask(with: request, from: data){ (data,response,error) in
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
            
//            let apiData = (data:responseData, response:response)

            let apiData = (data:data, response:response)
            let model = responseDecode(response: apiData, modelType: T.self) //Get response of respective model class
            completion(model)
            //completion(responsee(response:(data:data, response:response)))
        }
        task.resume()
    }
    
    
    //----------------------------------------------------------------------------
    //  @@@@@@@@@@ MARK:- Binding Multipart Data with parameters @@@@@@@@@@@@@@@@@
    //----------------------------------------------------------------------------
    
    func createBody(url:String,parameters: [String: Any],boundary: String,images:imageParamArray,mimeType: String) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        for (key, value) in parameters
        {
            
            if let arrayObj = value as? [String]{
                let count : Int  = arrayObj.count
                for i in 0  ..< count
                {
                    let valueObj = arrayObj[i]
                    
                    let keyObj = key + "[" + String(i) + "]"
                    body.appendString(string: boundaryPrefix)
                    body.appendString(string:  "Content-Disposition: form-data; name=\"\(keyObj)\"\r\n\r\n")
                    body.appendString(string: "\(valueObj)\r\n")
                    
                }
            }else{
                body.appendString(string: boundaryPrefix)
                body.appendString(string:  "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                
                body.appendString(string: "\(value)\r\n")
            }
        }
        //DispatchQueue.concurrentPerform(iterations: images.count) { index in
        for value in images
        {
//            if let imageData = value.image.jpegData(compressionQuality: 0.5)
//            {
                let keyName = value.key
//            if mimeType == "pdf"{
//                let filename = keyName + ".pdf"
//            } else {
//                let filename = keyName + ".jpeg"
//
//            }
                let filename = mimeType == "pdf" ? keyName + ".pdf" : keyName + ".jpeg"
                body.appendString(string: boundaryPrefix)
                body.appendString(string: "Content-Disposition: form-data; name=\"\(keyName)\"; filename=\"\(filename)\"\r\n")
                body.appendString(string: "Content-Type: \(mimeType)\r\n\r\n")
                body.append(value.image)
                body.appendString(string: "\r\n")
//            }
        }
        body.appendString(string: "--".appending(boundary.appending("--")).appending("\r\n"))
        return body as Data
    }
}

//--------------------------------------------------------------------------------------
//  @@@@@@@@@@ MARK:- URLSESSION DELEGATE (UPLOAD & DOWNLOAD PROGRESS) @@@@@@@@@@@@@@@@@
//--------------------------------------------------------------------------------------

extension MultipartdataRequest:URLSessionDelegate,URLSessionDataDelegate,URLSessionTaskDelegate{
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        print("didCompleteWithError")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    {
        print("didSendBodyData")
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        let progressPercent = Int(uploadProgress*100)  // Progress Shown Here
        print(progressPercent)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        print("didReceiveResponse")
        print(response)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    {
        print("didReceiveData")
    }
    
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        completionHandler(.performDefaultHandling, .none)
//
//    }
    
//    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
//        completionHandler(NSURLSessionResponseDisposition.Allow)
//    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, .none)
    }
//     func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveResponse response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
//        completionHandler(.allow)
//    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

func convertIntoJSONString(arrayObject: [String]) -> String? {
    
    do {
        let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
        if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
            return jsonString as String
        }
        
    } catch let error as NSError {
        print("Array convertIntoJSON - \(error.description)")
    }
    return nil
}
