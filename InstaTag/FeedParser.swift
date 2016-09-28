//
//  FeedParser.swift
//  InstaTag
//
//  Created by Эрик Вильданов on 26.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class FeedParser {
    var imageUrl = Image()
    
    private var parserCompletionHandler:((Image) -> Void)?
    
    
    func parseFeed (feedUrl: String, completionHandler: ((Image) -> Void)?) -> Void {
        self.parserCompletionHandler = completionHandler
        
        let request = NSURLRequest(url: NSURL(string: feedUrl)! as URL)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler:{
            (data, respouse, error) -> Void in
            
            if error != nil {
                print("\(error?.localizedDescription)")
            }
            self.parser(data: data!)
        })
        task.resume()
    }
    
    func parser(data: Data){
        let stringUrl = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let sharedData = listMatches(pattern: "sharedData\\ =\\ .*\\}", inString: stringUrl as String)
        let jsonString = replaceMatches(pattern: "sharedData\\ =\\ ", inString: sharedData, withString: "")
        
        let json = try! JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: .mutableContainers) as! NSDictionary
        if let entryData = json.object(forKey: "entry_data") as? NSDictionary {
                    if let tagPage = entryData.object(forKey: "TagPage") as? NSArray
                    {
                        for tagPage in tagPage{
                            let tag = (tagPage as AnyObject).object(forKey: "tag") as! NSDictionary
                            let topPost = tag.object(forKey: "top_posts") as! NSDictionary
                            let nodesTop = topPost.object(forKey: "nodes") as? NSArray
                            for nodesTop in nodesTop! {
                                imageUrl.url.append(URL(string: (nodesTop as AnyObject).object(forKey: "display_src") as! String)!)
                                imageUrl.comment.append((nodesTop as AnyObject).object(forKey: "caption") as? String ?? "")
                            }
                            let media = tag.object(forKey: "media") as! NSDictionary
                            let nodesMedia = media.object(forKey: "nodes") as? NSArray
                            let pageInfo = media.object(forKey: "page_info") as! NSDictionary
                            imageUrl.nextPage = pageInfo.object(forKey: "end_cursor") as? String ?? ""
                            
                            for nodesMedia in nodesMedia! {
                                imageUrl.url.append(URL(string: (nodesMedia as AnyObject).object(forKey: "display_src") as! String)!)
                                imageUrl.comment.append((nodesMedia as AnyObject).object(forKey: "caption") as? String ?? "")
                            }
                        }
                    }
                }
        parserCompletionHandler?(imageUrl)
    }
    
    func listMatches(pattern: String, inString string: String) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: .allowCommentsAndWhitespace)
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.firstMatch(in: string, options: .reportCompletion, range: range)
        if matches != nil {
            return matches.map {
                let range = $0.range
                return (string as NSString).substring(with: range)
                }!
        } else { return string }
    }
    
    func replaceMatches(pattern: String, inString string: String, withString replacementString: String) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: .allowCommentsAndWhitespace)
        let range = NSMakeRange(0, string.characters.count)
        
        return regex.stringByReplacingMatches(in: string, options: .reportCompletion, range: range, withTemplate: replacementString)
    }
    
    
}



