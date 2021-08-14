//
//  NetworkClient.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/7/21.
//

import Foundation


class NetworkClient{
    
    let session = URLSession.shared
    static let shared = NetworkClient()
    
    func methodForGET(_ httpURL: HTTPURL, completionHandlerForGET: @escaping (_ result:Data?, _ error:Error?) -> Void) -> URLSessionDataTask{
        
        let url = sessionURLFromParameters(httpURL: httpURL)
        print("URL IS: \(url)")
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else{
                print("There was an error in the get request: \(String(describing: error))")
                completionHandlerForGET(nil, error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , 200...299 ~= statusCode else{
                completionHandlerForGET(nil, error)
                return
            }
            
            guard let data = data else{
                completionHandlerForGET(nil, error)
                return
            }
            
            completionHandlerForGET(data, nil)
            
            self.convertDataWithCompletionHandler(data) { result, error in
                guard let result = result else{return}
                
                guard let format = result as? [String:Any] else {print("23")
                    return}
                print(result)
            }
            
            
        }
        task.resume()
        return task
    }
    
    
    func methodForPOST(_ method:String, request:URLRequest, completionHandlerForPOST: @escaping (_ result:Data?, _ error:Error?) -> Void) -> URLSessionDataTask?{
        
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
            
            completionHandlerForPOST(data, nil)

//            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            self.convertDataWithCompletionHandler(data) { result, error in
                guard let result = result else{return}
                
                print(result)
                guard let format = result as? [String:Any] else {print("22")
                    return}
                //print(format)
                
//                for (key,value) in format{
//                    print(key)
//                }
//                if let result2 = format["result"] as? [String:Any]{
//                    print("result222")
//                    //print(result2)
//                    for (key,value) in result2{
//                        print(key)
//                        if key == "musicbrainz"{
//                            //print(value)
//                            if let inside = value as? [[String:Any]]{
//                                for ins in inside{
//                                    
//                                    for ins2 in ins{
//                                        print("-\(ins2.key)")
//                                        if let inside2 = ins2.value as? [[String:Any]]{
//                                            for inq in inside2{
//                                                for inq2 in inq{
//                                                    print("--\(inq2.key)")
//                                                }
//                                                
//                                            }
//                                        }
//                                    }
//                                    //print(ins)
//                                }
//                            }
//                        }
//                    }
//                }
                //print(result)
            }
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
    
    private func sessionURLFromParameters(httpURL: HTTPURL, withPathExtension: String? = nil) -> URL {
                
        var components = URLComponents()
        components.scheme = httpURL.scheme
        components.host = httpURL.host
        components.path = httpURL.path + (httpURL.method ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in httpURL.parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    
    
    
}
