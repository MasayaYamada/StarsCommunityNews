//
//  ArticleDetailViewController.swift
//  StarsCommunityNews
//
//  Created by Yamada, Masaya on 8/9/19.
//  Copyright © 2019 Yamada, Masaya. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController {


    @IBOutlet weak var webView: WKWebView!
    
    var articleLink:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: self.articleLink) {
            let request = URLRequest(url: url)
            print("url on webView :\(request)")
            self.webView.load(request)
        }
    }
    
    
}
