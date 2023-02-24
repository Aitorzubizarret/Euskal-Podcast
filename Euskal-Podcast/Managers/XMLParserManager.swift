//
//  XMLParserManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2/2/23.
//

import Foundation
import Combine

class XMLParserManager: NSObject {
    
    // MARK: - Properties
    
    let serialQueue = DispatchQueue.init(label: "serialQueue")
    
    // Observable subjets.
    var program = PassthroughSubject<Program, Error>()
    
    var parser = XMLParser()
    
    var XMLcontent : String = ""
    
    var newProgram: Program?
    var newEpisode: Episode?
    var channelId: String = ""
    var isItem: Bool = false
    
    var nothing: String = ""
    
    // MARK: - Methods
    
    func parseChannel(urlAddress: String, id: String) {
        guard let safeURL: URL = URL(string: urlAddress) else { return }
        
        serialQueue.async {
            self.channelId = id
            
            self.parser = XMLParser(contentsOf: safeURL) ?? XMLParser()
            self.parser.delegate = self
            self.parser.parse()
        }
    }
    
    private func convertStringToInt(value: String) -> Int {
        var result: Int = 0
        var seconds: Int = 0
        var minutes: Int = 0
        var hours: Int = 0
        
        let valueComponents = value.components(separatedBy: ":")
        
        switch valueComponents.count {
        case 1:
            seconds = Int(valueComponents[0]) ?? 0
        case 2:
            minutes = Int(valueComponents[0]) ?? 0
            seconds = Int(valueComponents[1]) ?? 0
            if let minutes = Int(valueComponents[0]),
               let seconds = Int(valueComponents[1]) {
                result = (minutes * 60) + seconds
            }
        case 3:
            hours = Int(valueComponents[0]) ?? 0
            minutes = Int(valueComponents[1]) ?? 0
            seconds = Int(valueComponents[2]) ?? 0
        default:
            result = 0
        }
        
        result = (hours * 3600) + (minutes * 60) + seconds
        
        return result
    }
    
    private func formatPudDate(stringDate: String) -> Date {
        var cleanXMLContent = stringDate
        
        // Clean bad XML pubDate.
        // Mon, 04 Jul 2016 19:41:17 GMT +0200 -> Mon, 04 Jul 2016 19:41:17 +0200
        if cleanXMLContent.contains("GMT") {
            cleanXMLContent = cleanXMLContent.replacingOccurrences(of: "GMT ", with: "")
        }
        
        let dateFormatter = DateFormatter() // Tue, 31 Jan 2023 23:00:00 GMT -> E, d MMM yyyy HH:mm:ss Z
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        return dateFormatter.date(from: cleanXMLContent) ?? Date()
    }
    
}

extension XMLParserManager: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        newProgram = Program()
        
        XMLcontent = ""
        isItem = false
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            newEpisode = Episode()
            
            isItem = true
        }
        
        for (key, value) in attributeDict {
            if elementName == "itunes:image" {
                if key == "href" {
                    newProgram?.imageURL = value
                }
            } else if elementName == "itunes:category" {
                if key == "text" {
                    newProgram?.category = value
                }
            } else if elementName == "enclosure" {
                if key == "url" {
                    newEpisode?.audioFileURL = value
                } else if key == "length" {
                    newEpisode?.audioFileSize = value
                }
            }
        }
        
        XMLcontent = ""
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if isItem {
            // Episode data.
            switch elementName {
            case "item":
                guard let newProgram = newProgram,
                      let newEpisode = newEpisode else { return }
                
                newProgram.episodes.append(newEpisode)
                isItem = false
            case "title":
                guard let newEpisode = newEpisode else { return }
                
                newEpisode.title = newEpisode.title + XMLcontent
            case "description":
                guard let newEpisode = newEpisode else { return }
                
                newEpisode.descriptionText = newEpisode.descriptionText + XMLcontent
            case "pubDate":
                guard let newEpisode = newEpisode else { return }
                
                newEpisode.pubDate = formatPudDate(stringDate: XMLcontent)
            case "itunes:explicit":
                guard let newEpisode = newEpisode else { return }
                
                newEpisode.explicit = newEpisode.explicit + XMLcontent
            case "itunes:duration":
                newEpisode?.duration  = convertStringToInt(value: XMLcontent)
            case "link":
                guard let newEpisode = newEpisode else { return }
                
                newEpisode.link = newEpisode.link + XMLcontent
            default:
                nothing = ""
            }
        } else {
            // Program data.
            switch elementName {
            case "channel":
                nothing = ""
            case "title":
                guard let newProgram = newProgram else { return }
                
                if newProgram.title != XMLcontent {
                    newProgram.title = newProgram.title + XMLcontent
                }
            case "description":
                guard let newProgram = newProgram else { return }
                
                newProgram.descriptionText = newProgram.descriptionText + XMLcontent
            case "itunes:image":
                guard let newProgram = newProgram else { return }
                newProgram.imageURL = newProgram.imageURL + XMLcontent
            case "itunes:explicit":
                guard let newProgram = newProgram else { return }
                
                newProgram.explicit = newProgram.explicit + XMLcontent
            case "language":
                guard let newProgram = newProgram else { return }
                
                newProgram.language = newProgram.language + XMLcontent
            case "itunes:author":
                guard let newProgram = newProgram else { return }
                
                newProgram.author = newProgram.author + XMLcontent
            case "link":
                guard let newProgram = newProgram else { return }
                
                newProgram.link = newProgram.link + XMLcontent
            case "copyright":
                guard let newProgram = newProgram else { return }
                
                newProgram.copyright = newProgram.copyright + XMLcontent
            case "itunes:name":
                guard let newProgram = newProgram else { return }
                
                newProgram.copyrightOwnerName = newProgram.copyrightOwnerName + XMLcontent
            case "itunes:email":
                guard let newProgram = newProgram else { return }
                
                newProgram.copyrightOwnerEmail = newProgram.copyrightOwnerEmail + XMLcontent
            default:
                nothing = ""
            }
        }
        
        XMLcontent = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        XMLcontent = XMLcontent + string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if let newProgram = newProgram {
            program.send(newProgram)
        }
    }
    
}
