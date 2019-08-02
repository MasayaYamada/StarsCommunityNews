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
    let ENCLOSURE_ELEMENT_NAME = "enclosure"
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel
        label.text = articles[indexPath.row].title
        print("label : \(label)")
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startDownload()
    }
    
    func startDownload() {
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
        case ITEM_ELEMENT_NAME:
            self.articles.append(self.article!)
        default: break
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
