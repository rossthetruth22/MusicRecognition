//
//  NetworkClient.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/7/21.
//

import Foundation


class NetworkClient{
    
    let session = URLSession.shared
    
    func methodForGET(_ method:String?, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result:AnyObject?, _ error:Error?) -> Void){
        
 
        
        
    }
    
    
    func methodForPOST(_ method:String, request:URLRequest, completionHandlerForPOST: @escaping (_ result:AnyObject?, _ error:Error?) -> Void) -> URLSessionDataTask?{
        
        guard let url = URL(string: method) else {print("nope")
            return nil
        }
        
        //let multiPartRequest = MultiPartRequest(url: url)
        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
//        request.httpBody = formData
        
        let task = session.dataTask(with: request) { (data, response, error) in

            let statusCode = (response as? HTTPURLResponse)?.statusCode
            print("status code is \(statusCode)")

            guard error == nil else {
                completionHandlerForPOST(nil, error)
                return}


            guard let data = data else {
                completionHandlerForPOST(nil, error)
                return
            }

            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
//        let task = session.uploadTask(with: request, from: formData) { (data, response, error) in
//
//            let statusCode = (response as? HTTPURLResponse)?.statusCode
//            print("status code is \(statusCode)")
//
//            guard error == nil else {
//                completionHandlerForPOST(nil, error)
//                return}
//
//
//            guard let data = data else {
//                completionHandlerForPOST(nil, error)
//                return
//            }
//
//            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
//
//        }
        
        task.resume()
    
        return task
    }
    
    func methodForDELETE(_ method:String?, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result:AnyObject?, _ error:Error?) -> Void){
        
    }
    
    func methodForPUT(_ method:String?, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result:AnyObject?, _ error:Error?) -> Void){
        
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: Error?)  -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completionHandlerForConvertData(nil, error)
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    
    
}
