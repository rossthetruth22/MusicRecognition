//
//  MultiPartRequest.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/12/21.
//

import Foundation

struct MultiPartRequest{
    
    private let boundary: String = UUID().uuidString
    private var httpBody = NSMutableData()
    private var url:URL
    
    
    func addStringToBody(fieldName:String, value:String){
        httpBody.appendString(convertStringToFormData(fieldName: fieldName, value: value))
    }
    
    func addFileToBody(fieldName:String, data: Data, fileType:String, mimeType:String){
        httpBody.append(convertFileToFormData(fieldName: fieldName, data: data, fileType: fileType, mimeType: mimeType))
    }
    
    private func convertStringToFormData(fieldName: String, value: String) -> String{
        
        var boundaryPrefix = "--\(boundary)\r\n"
        boundaryPrefix += "Content-Disposition: form-data; name=\"\(fieldName)\"\r\n"
        boundaryPrefix += "\r\n"
        boundaryPrefix += "\(value)\r\n"
        
        //print(boundaryPrefix)
        return boundaryPrefix
        
    }
    
    private func convertFileToFormData(fieldName:String, data: Data, fileType:String, mimeType:String) -> Data{
        
        let mutableData = NSMutableData()
        
        mutableData.appendString("--\(boundary)\r\n")
        mutableData.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"sean.mp3\"\r\n")
        mutableData.appendString("Content-Type: \(mimeType)\r\n")
        mutableData.appendString("\r\n")
        mutableData.append(data)
        mutableData.appendString("\r\n")
        
        return mutableData as Data
    }
    
    func loadRequest() -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        httpBody.appendString("--\(boundary)--")
        httpBody.appendString("\r\n")
        request.httpBody = httpBody as Data
        return request
    }
    
    init(url: URL){
        self.url = url
    }
    
    
}


extension NSMutableData{
    func appendString(_ text:String){
        if let newText = text.data(using: .utf8){
            self.append(newText)
        }
    }
}
