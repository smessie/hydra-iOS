//
//  SchamperArticle.swift
//  OAuthTest
//
//  Created by Feliciaan De Palmenaer on 28/02/2016.
//  Copyright © 2016 Zeus WPI. All rights reserved.
//

import Foundation

class SchamperArticle: NSObject, NSCoding {

    // MARK: Properties
    var title: String
    var link: String
    var date: NSDate
    var author: String?
    var body: String
    var read: Bool = false

    convenience override init() {
        self.init(title: "", link: "", date: NSDate(), author: nil, body: "")
    }

    init(title: String, link: String, date: NSDate, author: String?, body: String, read: Bool = false) {
        self.title = title
        self.link = link
        self.date = date
        self.author = author
        self.body = body
        self.read = read
    }

    override var description: String {
        get {
            return "SchamperArticle: \(self.title)"
        }
    }

    // MARK: NSCoding Protocol
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        link = aDecoder.decodeObjectForKey(PropertyKey.linkKey) as! String
        date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        author = aDecoder.decodeObjectForKey(PropertyKey.authorKey) as? String
        body = aDecoder.decodeObjectForKey(PropertyKey.bodyKey) as! String
        read = aDecoder.decodeObjectForKey(PropertyKey.readKey) as! Bool
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(link, forKey: PropertyKey.linkKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(author, forKey: PropertyKey.authorKey)
        aCoder.encodeObject(body, forKey: PropertyKey.bodyKey)
        aCoder.encodeObject(read, forKey: PropertyKey.readKey)
    }

    struct PropertyKey {
        static let titleKey = "title"
        static let linkKey = "link"
        static let dateKey = "date"
        static let authorKey = "author"
        static let bodyKey = "body"
        static let readKey = "read"
    }
}