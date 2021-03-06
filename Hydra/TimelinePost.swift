//
//  TimelinePost.swift
//  Hydra
//
//  Created by Feliciaan De Palmenaer on 16/09/2016.
//  Copyright © 2016 Zeus WPI. All rights reserved.
//

class TimelinePost: NSObject, Codable {
    var title: String?
    var body: String?
    var link: String?
    var media: String?
    var date: Date?
    var origin: Origin = .NoneOrigin
    var postType: PostType = .NoneType
    var poster: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, body, link, media, poster
        case origin, postType = "post_type"
        case date = "created_at"
    }

    enum Origin: String, Codable {
        case Facebook = "facebook"
        case Instagram = "instagram"
        case Blog = "default"
        case NoneOrigin = "none"
    }

    enum PostType: String, Codable {
        case Photo = "photo"
        case Video = "video"
        case Text = "text"
        case Link = "link"
        case NoneType = "none"
    }
}
