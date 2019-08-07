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

class ArticleCollectionViewController: UICollectionViewController, XMLParserDelegate {

    var parser:XMLParser!
    var articles = [Article]()
    var article:Article?
    var currentParsedElement = ""
    //var currentArticle:[AnyObject] = []
    
    
    
    let JAPAN_URL = "https://japan.stripes.com/rss/flipboard"
//    let ITEM_ELEMENT_NAME = "item"
//    let TITLE_ELEMENT_NAME = "title"
//    let LINK_ELEMENT_NAME = "link"
//    let CONTENT_ELEMENT_NAME = "content:encoded"
//    let FIGURE_ELEMENT_NAME = "figure"
//    let ENCLOSURE_ELEMENT_NAME = "enclosure"
//
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel
        label.text = articles[indexPath.row].title
        return cell
    }
    
    // セルが選択されたときの処理
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(articles[indexPath.row].title)がtapされたよ")
        print("\(articles[indexPath.row].articleUrl)がtapされたよ")
        print("\(articles[indexPath.row].imageUrl)がタップされたよ")
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
        
        self.article = Article()
        self.articles = []
        
        Alamofire.request(JAPAN_URL).response { response in
            let xml = SWXMLHash.parse(response.data!)
            
                for elem in xml["rss"]["channel"]["item"].all {
                    let currentArticle = elem["title"].element!.text
                    self.article?.title = currentArticle
                    print("title : \(elem["title"].element!.text)")

                    
                    self.article?.articleUrl = elem["link"].element!.text
                    print("URL : \(elem["link"].element!.text)")

                    
                    let contentData = elem["content:encoded"].element!.text
                    let getURL = String(describing:self.detectLinks(contentData))
                    self.article?.imageUrl = getURL
                    print("url : \(getURL)")
                    self.articles.append(self.article!)
                }
            
            }
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
    
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict:[String : String] = [:]){
//
//        if elementName == ITEM_ELEMENT_NAME {
//            weAreInsideAnItem = true
//            self.article = Article()
//        }
//
//        if weAreInsideAnItem {
//            switch elementName {
//                case TITLE_ELEMENT_NAME:
//                    currentParsedElement = elementName
//                    entryTitle = ""
//                case LINK_ELEMENT_NAME:
//                    currentParsedElement = elementName
//                    entryURL = ""
//                case CONTENT_ELEMENT_NAME:
//                    currentParsedElement = elementName
//                    entryContent = ""
//            default:
//                break
//            }
//        }
//
//
//    }
    
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        if weAreInsideAnItem {
//            switch currentParsedElement {
//            case TITLE_ELEMENT_NAME:
//                entryTitle = entryTitle + string
//            case LINK_ELEMENT_NAME:
//                entryURL = entryURL + string
//            case CONTENT_ELEMENT_NAME:
//                entryContent = entryContent + string
//            default:
//                break
//            }
//        }
//    }
//
//    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        if weAreInsideAnItem {
//            switch elementName {
//            case TITLE_ELEMENT_NAME:
//                currentParsedElement = ""
//            case LINK_ELEMENT_NAME:
//                currentParsedElement = ""
//            default:
//                break
//            }
//        }
//
//        if elementName == ITEM_ELEMENT_NAME {
//            self.article?.title = entryTitle
//            print("title :\(entryTitle)")
//            self.article?.articleUrl = entryURL
//            print("url \(entryURL)")
//            self.article?.imageUrl = entryContent
//            print("content \(entryContent)")
//            self.articles.append(article!)
//            weAreInsideAnItem = false
//        }
//    }
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
