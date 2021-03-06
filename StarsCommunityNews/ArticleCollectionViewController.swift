//
//  ArticleCollectionViewController.swift
//  StarsCommunityNews
//
//  Created by Yamada, Masaya on 8/1/19.
//  Copyright © 2019 Yamada, Masaya. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVGKit
import ViewAnimator


private let reuseIdentifier = "Cell"

class ArticleCollectionViewController: UICollectionViewController, XMLParserDelegate {
    
    var parser:XMLParser!
    var articles = [Article]()
    var article:Article?
    var currentString = ""
    
    var tappedArticleURL = ""
    var tappedArticleTitle = ""
    var tappedImageURL = ""
    
    let starImg = UIImage(named: "star")
    let starFillImg = UIImage(named: "filledstar")
    
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    var url:URL!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.size.height/3)
        
        let identifiy: String = self.restorationIdentifier!
        
        if identifiy == "Japan"  {
            self.url = URL(string: GlobalContents.RSS_URL.JAPAN_URL.rawValue)!
        }
        if identifiy == "Okinawa" {
            self.url = URL(string: GlobalContents.RSS_URL.OKINAWA_URL.rawValue)!
        }
        if identifiy == "Korea" {
            self.url = URL(string: GlobalContents.RSS_URL.KOREA_URL.rawValue)!
        }
        
        
        startDownload(currentUrl: url)
        
    }
    
     
    func startDownload(currentUrl:URL) {
        self.articles = []
            if let parser = XMLParser(contentsOf: currentUrl) {
                self.parser = parser
                self.parser.delegate = self
                self.parser.parse()
            }
    }
        
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentString = ""
        if elementName == GlobalContents.ITEM_ELEMENT_NAME {
            self.article = Article()
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentString += string
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case GlobalContents.TITLE_ELEMENT_NAME:
            self.article?.title = currentString
            print("element title name : \(currentString)")
        case GlobalContents.LINK_ELEMENT_NAME:
            self.article?.articleUrl = currentString
            print("link element \(currentString)")
        case GlobalContents.CONTENT_ELEMENT_NAME:
            let imageURL = detectLinks(str: currentString)
            self.article?.imageUrl = imageURL
            print("image url \(imageURL)")
        case GlobalContents.ITEM_ELEMENT_NAME:
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
        
        let imageUrl = URL(string: articles[indexPath.row].imageUrl)
        
        do {
            let cellImage = cell.contentView.viewWithTag(1) as! UIImageView

            Alamofire.request(imageUrl!).responseImage { response in
                debugPrint(response.result)
                if let currentImage = response.result.value {
                    DispatchQueue.main.async {
                        cellImage.image = currentImage
                    }
                }
            }
        } catch {
            print("error だよ")
        }
        
        let cellLabel = cell.contentView.viewWithTag(2) as! UILabel
        cellLabel.text = self.articles[indexPath.row].title
        cellLabel.numberOfLines = 4;
        cellLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
       
        return cell
            
    }
    
    // セルが選択されたときの処理
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(articles[indexPath.row].title)がtapされたよ")
        print("\(articles[indexPath.row].articleUrl)がtapされたよ")
        print("\(articles[indexPath.row].imageUrl)がタップされたよ")
        
        tappedArticleTitle = articles[indexPath.row].title
        tappedArticleURL = articles[indexPath.row].articleUrl
        tappedImageURL = articles[indexPath.row].imageUrl
        
        self.performSegue(withIdentifier: "toArticleDetailVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArticleDetailVC" {
            let nextVC = segue.destination as! ArticleDetailViewController
            nextVC.articleLink = tappedArticleURL
        }
        
    }
    
    
    // find URL FROM <content:encoded>
    func detectLinks(str: String) -> String {
        
        var currentURL = ""
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: str, options: [], range: NSRange(location: 0, length: str.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: str) else { continue }
            let url = str[range]
            currentURL = String(url)
        }
        return currentURL
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    


    
}


