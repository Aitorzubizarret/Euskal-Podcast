//
//  RSSParser.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 1/7/22.
//

import Foundation

final class RSSParser: NSObject {
    
    // MARK: - TAGs
    
    var rss: String = ""
    var channel: String = ""
    var link: String = ""
    var language: String = ""
    var copyright: String = ""
    var itunesAuthor: String = ""
    var description2: String = ""
    var itunesType: String = ""
    var itunesOwner: String = ""
    var itunesName: String = ""
    var itunesEmail: String = ""
    var itunesCategory: String = ""
    var itunesExplicit: String = ""
    var itunesImage: String = ""
    var itunesDuration: String = ""
    var item: String = ""
    var title: String = ""
    var enclosure: String = ""
    var guid: String = ""
    var pubDate: String = ""
    
    private struct SerializationKeys {
        static let rss = "rss"
        static let channel = "channel"
        static let link = "link"
        static let language = "language"
        static let copyright = "copyright"
        static let itunesAuthor = "itunes:author"
        static let description2 = "description"
        static let itunesType = "itunes:type"
        static let itunesOwner = "itunes:owner"
        static let itunesName = "itunes:name"
        static let itunesEmail = "itunes:email"
        static let itunesCategory = "itunes:category"
        static let itunesExplicit = "itunes:explicit"
        static let itunesDuration = "itunes:duration"
        static let itunesImage = "itunes:image"
        static let item = "item"
        static let title = "title"
        static let enclosure = "enclosure"
        static let guid = "guid"
        static let pubDate = "pubDate"
    }
    
    // MARK: - XML Parser
    
    private var parser: XMLParser
    private var actualElement: String
    
    internal private(set) var items: [RSSItem]
    
    public init(data: Data) {
        actualElement = ""
        items = []
        parser = XMLParser(data: data)
        
        super.init()
        
        parser.delegate = self
        parser.parse()
    }
    
}

// MARK: - XMLParser Delegate

extension RSSParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "item" {
            title = ""
            description2 = ""
            link = ""
            enclosure = ""
            pubDate = ""
            itunesDuration = ""
            itunesExplicit = ""
        }
        
        actualElement = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            print("New Item : \(title)")
            let newItem = RSSItem(title: title,
                                  description: description2,
                                  link: link,
                                  enclosure: enclosure,
                                  pubDate: pubDate,
                                  duration: itunesDuration,
                                  explicit: itunesExplicit)
            items.append(newItem)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !data.isEmpty else { return }
        
        print("Character : \(data) - actualElement: \(actualElement)")
        switch actualElement {
        case SerializationKeys.rss:
            rss = data
        case SerializationKeys.channel:
            channel = data
        case SerializationKeys.link:
            link = data
        case SerializationKeys.language:
            language = data
        case SerializationKeys.copyright:
            copyright = data
        case SerializationKeys.itunesAuthor:
            itunesAuthor = data
        case SerializationKeys.description2:
            description2 = data
        case SerializationKeys.itunesType:
            itunesType = data
        case SerializationKeys.itunesOwner:
            itunesOwner = data
        case SerializationKeys.itunesName:
            itunesName = data
        case SerializationKeys.itunesEmail:
            itunesEmail = data
        case SerializationKeys.itunesCategory:
            itunesCategory = data
        case SerializationKeys.itunesExplicit:
            itunesExplicit = data
        case SerializationKeys.item:
            item = data
        case SerializationKeys.title:
            title = data
        case SerializationKeys.enclosure:
            enclosure = data
        case SerializationKeys.guid:
            guid = data
        case SerializationKeys.pubDate:
            pubDate = data
        case SerializationKeys.itunesDuration:
            itunesDuration = data
        case SerializationKeys.itunesImage:
            itunesImage = data
        default:
            print("XMLParser: Switch foundCharacter -> default. \(actualElement) : \(data)")
        }
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        guard let stringValue = String(data: CDATABlock, encoding: .utf8) else { return }
        
        switch actualElement {
        case SerializationKeys.rss:
            rss = stringValue
        case SerializationKeys.channel:
            channel = stringValue
        case SerializationKeys.link:
            link = stringValue
        case SerializationKeys.language:
            language = stringValue
        case SerializationKeys.copyright:
            copyright = stringValue
        case SerializationKeys.itunesAuthor:
            itunesAuthor = stringValue
        case SerializationKeys.description2:
            description2 = stringValue
        case SerializationKeys.itunesType:
            itunesType = stringValue
        case SerializationKeys.itunesOwner:
            itunesOwner = stringValue
        case SerializationKeys.itunesName:
            itunesName = stringValue
        case SerializationKeys.itunesEmail:
            itunesEmail = stringValue
        case SerializationKeys.itunesCategory:
            itunesCategory = stringValue
        case SerializationKeys.itunesExplicit:
            itunesExplicit = stringValue
        case SerializationKeys.item:
            item = stringValue
        case SerializationKeys.title:
            title = stringValue
        case SerializationKeys.enclosure:
            enclosure = stringValue
        case SerializationKeys.guid:
            guid = stringValue
        case SerializationKeys.pubDate:
            pubDate = stringValue
        case SerializationKeys.itunesDuration:
            itunesDuration = stringValue
        case SerializationKeys.itunesImage:
            itunesImage = stringValue
        default:
            print("XMLParser: Switch foundCDATA -> default. \(actualElement) : \(stringValue)")
        }
    }
    
}
