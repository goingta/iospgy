//
//  PGYNetwork.swift
//  iospgy
//
//  Created by goingta on 2018/6/1.
//  Copyright © 2018 goingta. All rights reserved.
//

import Alamofire
import ObjectMapper

class PGYNetwork {
    
    func getPGYList(callback: ((_ model: PGYListModel?)->Void)? = nil) {
        request(.post, URL(string: "https://www.pgyer.com/apiv2/app/builds")!, parameters: ["_api_key": pgyerApiKey, "appKey": pgyerAppKey], type: PGYListModel.self) { (model) in
            callback?(model as? PGYListModel)
        }
    }
    
    func jenkinsBuild(jenkinsUrlString: String,callback: (()->())?) {
        let headers = [ "Authorization": "Basic " + jenkinsAuthorization ]
        Alamofire.request(jenkinsUrlString, method: .post, parameters: nil,encoding: URLEncoding.default, headers: headers) .responseJSON { response in
            callback?()
        }
    }
    
    func request <T: BaseMappable> (_ method: Alamofire.HTTPMethod,
                                    _ url: URLConvertible,
                                    parameters: [String: Any]? = nil,
                                    type: T.Type? = nil,
                                    encoding: ParameterEncoding = URLEncoding.default,
                                    headers: [String: String]? = nil,
                                    callback: ((_ result: Any?)->Void)? = nil) {
        var encode:ParameterEncoding  = URLEncoding.default
        if method == .post {
            encode = URLEncoding.default
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encode, headers: nil).validate().responseJSON { (response) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard response.result.isSuccess else {
                callback?(nil)
                return
            }
            guard let jsonDic = response.result.value as? [String: Any],
                let data = jsonDic["data"] as? [String: Any] else {
                    callback?(nil)
                    return
            }
            
            if let object = Mapper<T>().map(JSON: data) {
                callback?(object)
            }
        }
        
    }

}
