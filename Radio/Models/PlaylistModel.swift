//
//  PlaylistModel.swift
//  Radio
//
//  Created by Keval Patel on 4/27/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import ObjectMapper
public class PlaylistModel: Mappable{
    var url : String?
    var format : String?
    var quality : String?
    
    required public init?(map: Map) {
        
    }

    // Mappable
    public func mapping(map: Map) {
        url <- map["url"]
        format <- map["format"]
        quality <- map["quality"]
    }
}
