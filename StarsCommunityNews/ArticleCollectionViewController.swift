//
//  ArticleCollectionViewController.swift
//  StarsCommunityNews
//
//  Created by Yamada, Masaya on 8/1/19.
//  Copyright © 2019 Yamada, Masaya. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ArticleCollectionViewController: UICollectionViewController, XMLParserDelegate {
    
    var parser:XMLParser!
    var articles = [Article]()
    var article:Article?
    var currentString = ""
    
    
    let JAPAN_URL = "https://japan.stripes.com/rss/flipboard"
    let ITEM_ELEMENT_NAME = "item"
    let TITLE_ELEMENT_NAME = "title"
    let LINK_ELEMENT_NAME = "link"
    //let ENCLOSURE_ELEMENT_NAME = "enclosure"
    let CONTENT_ELEMENT_NAME = "content:encoded"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.size.height/3)
        
        startDownload()
    }
    
    func startDownload(){
        self.articles = []
        if let url = URL(string: JAPAN_URL) {
            if let parser = XMLParser(contentsOf: url) {
                self.parser = parser
                self.parser.delegate = self
                self.parser.parse()
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentString = ""
        if elementName == ITEM_ELEMENT_NAME {
            self.article = Article()
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentString += string
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case TITLE_ELEMENT_NAME:
            self.article?.title = currentString
            print("element title name : \(currentString)")
        case LINK_ELEMENT_NAME:
            self.article?.articleUrl = currentString
            print("link element \(currentString)")
        case CONTENT_ELEMENT_NAME:
            let imageURL = detectLinks(str: currentString)
            self.article?.imageUrl = imageURL
            print("image url \(imageURL)")
        case ITEM_ELEMENT_NAME:
            self.articles.append(self.article!)
        default: break
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.collectionView.reloadData()
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
        print("\(articles[indexPath.row].imageUrl)がタップされたよ")
    }
    
    // find URL FROM <content:encoded>
    func detectLinks(str: String) -> String {
        
        var currentURL = ""
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: str, options: [], range: NSRange(location: 0, length: str.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: str) else { continue }
            let url = str[range]
            print(url)
            currentURL = String(url)
        }
        return currentURL
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


