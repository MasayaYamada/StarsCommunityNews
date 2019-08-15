//
//  GlobalContents.swift
//  StarsCommunityNews
//
//  Created by Yamada, Masaya on 8/13/19.
//  Copyright © 2019 Yamada, Masaya. All rights reserved.
//

import Foundation

struct GlobalContents {
   
   // static let JAPAN_URL = "https://japan.stripes.com/rss/flipboard"
    
    enum RSS_URL: String {
        case JAPAN_URL = "https://japan.stripes.com/rss/flipboard"
        case OKINAWA_URL = "https://okinawa.stripes.com/rss/flipboard"
        case KOREA_URL = "https://korea.stripes.com/rss/flipboard"
    }
    
    enum URLITEMS: CaseIterable {
        case JAPAN
        case OKINAWA
        case KOREA
    }
    
    static let ITEM_ELEMENT_NAME = "item"
    static let TITLE_ELEMENT_NAME = "title"
    static let LINK_ELEMENT_NAME = "link"
    static let CONTENT_ELEMENT_NAME = "content:encoded"
    
    
}
