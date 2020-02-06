//
//  ApiManager.swift
//  contact
//
//  Created by Pinkesh Gjr on 04/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import Foundation
import Alamofire

class ApiManager{
    
    static let sharedInstance = ApiManager()
    var alamoFireManager = Alamofire.SessionManager.default
    var resObjects:AnyObject!
    
    init() {
        alamoFireManager.session.configuration.timeoutIntervalForRequest = 120 //seconds
    }
    
    func getRequest(endpointURL: String, responseData:@escaping (_ responseObject: AnyObject?,_ error: Error?,_ message: String?, _ responseData: Any?) -> Void){
        
        alamoFireManager.request(endpointURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response:DataResponse<Any>) in
                
                if let responseError = response.result.error{
                    responseData(nil, responseError, responseError.localizedDescription, response.data)
                }else{
                    switch (response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            self.resObjects = data as AnyObject
                            responseData(self.resObjects, nil, "success message", response.data)
                        }
                    case .failure(_):
                        responseData(nil, response.result.error as NSError?, response.result.error?.localizedDescription, response.data)
                    }
                }
        }
    }
    
    func putRequest(endpointURL: String, parameters: Parameters, responseData: @escaping(_ responseObject: AnyObject?,_ error: Error?,_ message: String?,_ responseData: Any?) -> Void){
        
        alamoFireManager.request(endpointURL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response:DataResponse<Any>) in
                
                if let responseError = response.result.error{
                    responseData(nil, responseError, responseError.localizedDescription, response.data)
                }else{
                    switch (response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            self.resObjects = data as AnyObject
                            responseData(self.resObjects, nil, "success message", response.data)
                        }
                    case .failure(_):
                        responseData(nil, response.result.error as NSError?, response.result.error?.localizedDescription, response.data)
                    }
                }
        }
    }
    
    func postRequest(endpointURL: String, parameters: Parameters, responseData: @escaping(_ responseObject: AnyObject?,_ error: Error?,_ message: String?,_ responseData: Any?) -> Void){
        
        alamoFireManager.request(endpointURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response:DataResponse<Any>) in
                
                if let responseError = response.result.error{
                    responseData(nil, responseError, responseError.localizedDescription, response.data)
                }else{
                    switch (response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            self.resObjects = data as AnyObject
                            responseData(self.resObjects, nil, "success message", response.data)
                        }
                    case .failure(_):
                        responseData(nil, response.result.error as NSError?, response.result.error?.localizedDescription, response.data)
                    }
                }
        }
    }
    
    func deleteRequest(endpointURL: String, responseData: @escaping(_ responseObject: AnyObject?,_ error: Error?,_ message: String?,_ responseData: Any?) -> Void){
        
        alamoFireManager.request(endpointURL, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response:DataResponse<Any>) in
                
                if let responseError = response.result.error{
                    responseData(nil, responseError, responseError.localizedDescription, response.data)
                }else{
                    switch (response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            self.resObjects = data as AnyObject
                            responseData(self.resObjects, nil, "success message", response.data)
                        }
                    case .failure(_):
                        responseData(nil, response.result.error as NSError?, response.result.error?.localizedDescription, response.data)
                    }
                }
        }
    }
}

