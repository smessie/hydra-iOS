//
//  NewsItem.swift
//
//  Created by Feliciaan De Palmenaer on 28/02/2016
//  Copyright (c) . All rights reserved.
//

import Foundation

@objc class NewsItem: NSObject, Codable {

    // MARK: Properties
	var title: String
	var content: String
	var association: Association
	var internalIdentifier: Int
    private var _highlighted: Int
    var highlighted: Bool {
        set {
            _highlighted = highlighted ? 1 : 0
        }
        get {
            return _highlighted == 1
        }
    }
	var date: Date
    private var _read: Int?
    var read: Bool {
        set {
            _read = read ? 1 : 0
        }
        get {
            return _read == 1
        }
    }
    override var description: String {
        get {
            return "NewsItem: \(self.title)"
        }
    }

    init(title: String, content: String, association: Association, internalIdentifier: Int, highlighted: Bool, date: Date, read: Bool = false) {
        self.title = title
        self.content = content
        self.association = association
        self.internalIdentifier = internalIdentifier
        self.date = date
        self._read = read ? 1 : 0
        self._highlighted = highlighted ? 1 : 0
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, content, association, date
        case _read = "read"
        case _highlighted = "highlighted"
        case internalIdentifier = "id"
    }
}
