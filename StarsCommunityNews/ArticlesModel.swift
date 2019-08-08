//
//  ArticlesModel.swift
//  StarsCommunityNews
//
//  Created by Yamada, Masaya on 8/1/19.
//  Copyright © 2019 Yamada, Masaya. All rights reserved.
//

import Foundation

struct Article {
    var title: String
    var articleUrl: String
    //var imageUrl: String
    
    //init(title: String, articleUrl: String, imageUrl: String) {
    init(title: String, articleUrl: String) {
        self.title = title
        self.articleUrl = articleUrl
        //self.imageUrl = imageUrl
    }
    
}
