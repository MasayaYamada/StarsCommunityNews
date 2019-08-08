//
//  ArticleCollectionViewController.swift
//  StarsCommunityNews
//
//  Created by Yamada, Masaya on 8/1/19.
//  Copyright © 2019 Yamada, Masaya. All rights reserved.
//

import UIKit
import SWXMLHash
import Alamofire

private let reuseIdentifier = "Cell"

class ArticleCollectionViewController: UICollectionViewController {

    var articles: Array = [Article]()
    var article:Article?
    
    let JAPAN_URL = "https://japan.stripes.com/rss/flipboard"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.size.height/3)
        
        startDownload()
    }
    
   func startDownload() {
        
        self.articles = []
        
        Alamofire.request(JAPAN_URL).response { response in
            let xml = SWXMLHash.parse(response.data!)
            let items = xml["rss"]["channel"]["item"]
            for element in items.all {
                if let titleElement = element["title"].element {
                    if let urlElement = element["link"].element {
                    self.articles.append(Article(title: titleElement.text, articleUrl: urlElement.text))
                    print("test title : \(self.articles)")
                    }
                }
            }
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count : \(articles.count)")
        return articles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel
        label.text = articles[indexPath.row].title
        print("index path row : \(articles[indexPath.row])")
        return cell
    }
    
    // セルが選択されたときの処理
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(articles[indexPath.row].title)がtapされたよ")
        print("\(articles[indexPath.row].articleUrl)がtapされたよ")
        //print("\(articles[indexPath.row].imageUrl)がタップされたよ")
    }
    
    // find URL FROM <content:encoded>
    func detectLinks(_ str: String) -> [NSTextCheckingResult] {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let d = detector {
            return d.matches(in: str, range: NSMakeRange(0, str.count))
        } else {
            return []
        }
    }
    
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
