//
//  ChannelModel.swift
//  Radio
//
//  Created by Keval Patel on 4/27/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import ObjectMapper
public class ChannelModel: Mappable{
    var id : String?
    var title : String?
    var description : String?
    var dj :String?
    var djmail : String?
    var genre : String?
    var image : String?
    var largeimage : String?
    var xlimage : String?
    var twitter : String?
    var updated : String?
    var listeners : String?
    var lastPlaying : String?
    var playlists : [PlaylistModel]?

    required public init?(map: Map) {

    }

    // Mappable
    public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        description <- map["description"]
        dj <- map["dj"]
        djmail <- map["djmail"]
        genre <- map["genre"]
        image <- map["image"]
        largeimage <- map["largeimage"]
        xlimage <- map["xlimage"]
        twitter <- map["twitter"]
        updated <- map["updated"]
        listeners <- map["listeners"]
        lastPlaying <- map["lastPlaying"]
        playlists <- map["playlists"]
    }
}
