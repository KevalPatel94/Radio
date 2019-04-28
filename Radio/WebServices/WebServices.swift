//
//  WebServices.swift
//  Radio
//
//  Created by Keval Patel on 4/27/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import ObjectMapper
class WebService: NSObject {
    static let shared = WebService()
    func fetchArticles(_ urlString: String,_ runQueue: DispatchQueue,_ completionQueue: DispatchQueue,completion: @escaping ([ChannelModel]?, Error?) -> ()) {
        runQueue.async {
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, resp, error) in
                if let error = error {
                    completionQueue.async {
                        completion(nil, error)
                    }
                    return
                }
                guard let data = data else { return }
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: []) as! [String:AnyObject]
                    guard jsonResponse["channels"] != nil  else{
                        completionQueue.async {
                            completion(nil, error)
                        }
                        return
                    }
                    let channels = Mapper<ChannelModel>().mapArray(JSONObject: jsonResponse["channels"])
                    completionQueue.async {
                        completion(channels, nil)
                    }
                } catch let jsonErr {
                    completion(nil, jsonErr)
                }
                }.resume()
        }
    }
}
