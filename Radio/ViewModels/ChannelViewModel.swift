//
//  ChannelViewModel.swift
//  Radio
//
//  Created by Keval Patel on 4/27/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
public class ChannelViewModel{
    private let channel : ChannelModel
    let id : String
    let title : String
    let description : String
    let dj :String
    let djmail : String
    let genre : String
    let image : String
    let largeimage : String
    let xlimage : String
    let twitter : String
    let updated : String
    let listeners : String
    let lastPlaying : String
    let playlists : [PlaylistModel]
    
    public init(_ channel: ChannelModel) {
        self.channel = channel
        self.id  = channel.id ?? ""
        self.title = channel.title ?? ""
        self.description = channel.description ?? ""
        self.dj = channel.dj ?? ""
        self.djmail = channel.djmail ?? ""
        self.genre = channel.genre ?? ""
        self.image = channel.image ?? ""
        self.largeimage = channel.largeimage ?? ""
        self.xlimage = channel.xlimage ?? ""
        self.twitter = channel.twitter ?? ""
        self.updated = channel.updated ?? ""
        self.lastPlaying = channel.lastPlaying ?? ""
        self.listeners = channel.listeners ?? ""
        self.playlists = channel.playlists!
    }
}
