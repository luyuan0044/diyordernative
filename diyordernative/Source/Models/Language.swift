//
//  Language.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-14.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation

struct Language {
    var key: String
    var serverKey: String
    var description: String
    
    init(key: String, serverKey: String, description: String) {
        self.key = key
        self.serverKey = serverKey
        self.description = description
    }
}
