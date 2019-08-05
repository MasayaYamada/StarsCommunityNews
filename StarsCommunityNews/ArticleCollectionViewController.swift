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
    var currentParsedElement = ""
    var img:  [AnyObject] = []
    var weAreInsideAnItem = false
    
    var entryTitle = ""
    var entryURL = ""
    var entryImg = ""
    
    
    let JAPAN_URL = "https://japan.stripes.com/rss/flipboard"
    let ITEM_ELEMENT_NAME = "item"
    let TITLE_ELEMENT_NAME = "title"
    let LINK_ELEMENT_NAME = "link"
    let ENCLOSURE_ELEMENT_NAME = "enclosure"
    
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
    
    // セルが選択されたときの処理
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(articles[indexPath.row].title)がtapされたよ")
    }
    
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
        if let url = URL(string: JAPAN_URL) {
            if let parser = XMLParser(contentsOf: url) {
                self.parser = parser
                self.parser.delegate = self
                self.parser.parse()
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == ITEM_ELEMENT_NAME // finds the beginning of an item - that is the  tag
        {
            weAreInsideAnItem = true
            self.article = Article()
        }
        
        if weAreInsideAnItem {
            switch elementName {
                case TITLE_ELEMENT_NAME:
                    currentParsedElement = elementName
                    entryTitle = ""
                case LINK_ELEMENT_NAME:
                    currentParsedElement = elementName
                    entryURL = ""
                case ENCLOSURE_ELEMENT_NAME:
                    currentParsedElement = elementName
                    entryImg = attributeDict["url"]!
            default:
                break
            }
        }
        
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if weAreInsideAnItem {
            switch currentParsedElement {
            case TITLE_ELEMENT_NAME:
                entryTitle = entryTitle + string
            case LINK_ELEMENT_NAME:
                entryURL = entryURL + string
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if weAreInsideAnItem {
            switch elementName {
            case TITLE_ELEMENT_NAME:
                currentParsedElement = ""
            case LINK_ELEMENT_NAME:
                currentParsedElement = ""
            default:
                break
            }
        }
        
        if elementName == ITEM_ELEMENT_NAME {
            self.article?.title = entryTitle
            print("title :\(entryTitle)")
            self.article?.articleUrl = entryURL
            print("url \(entryURL)")
            self.article?.imageUrl = entryImg
            print("image \(entryImg)")
            self.articles.append(article!)
            weAreInsideAnItem = false
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
