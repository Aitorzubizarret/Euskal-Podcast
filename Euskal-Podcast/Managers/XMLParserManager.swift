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
    
    var channelId: String = ""
    
    var XMLcontent : String = ""
    
    var newProgram: Program?
    var programTitle:               String = ""
    var programDescription:         String = ""
    var programCategory:            String = ""
    var programImageURL:            String = ""
    var programExplicit:            String = ""
    var programLanguage:            String = ""
    var programAuthor:              String = ""
    var programLink:                String = ""
    var programCopyright:           String = ""
    var programCopyrightOwnerName:  String = ""
    var programCopyrightOwnerEmail: String = ""
    
    var isItem:               Bool = false
    var episodeTitle:       String = ""
    var episodeDescription: String = ""
    var episodePubDate:       Date = Date()
    var episodeExplicit:    String = ""
    var episodeFileURL:     String = ""
    var episodeFileSize:    String = ""
    var episodeDuration:    String = ""
    var episodeLink:        String = ""
    
    var episodes: [Episode] = []
    
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
    
}

extension XMLParserManager: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        XMLcontent = ""
        
        newProgram = nil
        programTitle = ""
        programDescription = ""
        programCategory = ""
        programImageURL = ""
        programExplicit = ""
        programLanguage = ""
        programAuthor = ""
        programLink = ""
        programCopyright = ""
        programCopyrightOwnerName = ""
        programCopyrightOwnerEmail = ""
        
        isItem = false
        episodeTitle = ""
        episodeDescription = ""
        episodePubDate = Date()
        episodeExplicit = ""
        episodeFileURL = ""
        episodeFileSize = ""
        episodeDuration = ""
        episodeLink = ""
        
        episodes = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            isItem = true
            
            episodeTitle = ""
            episodeDescription = ""
            episodePubDate = Date()
            episodeExplicit = ""
            episodeFileURL = ""
            episodeFileSize = ""
            episodeDuration = ""
            episodeLink = ""
        }
        
        for (key, value) in attributeDict {
            if elementName == "itunes:image" {
                if key == "href" {
                    programImageURL = value
                }
            } else if elementName == "itunes:category" {
                if key == "text" {
                    programCategory = value
                }
            } else if elementName == "enclosure" {
                if key == "url" {
                    episodeFileURL = value
                } else if key == "length" {
                    episodeFileSize = value
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
                let newEpisode = Episode()
                newEpisode.title = episodeTitle
                newEpisode.descriptionText = episodeDescription
                newEpisode.pubDate = episodePubDate
                newEpisode.explicit = episodeExplicit
                newEpisode.audioFileURL = episodeFileURL
                newEpisode.audioFileSize = episodeFileSize
                newEpisode.duration = convertStringToInt(value: episodeDuration)
                newEpisode.link = episodeLink
                
                episodes.append(newEpisode)
                
                isItem = false
            case "title":
                episodeTitle = episodeTitle + XMLcontent
            case "description":
                episodeDescription = episodeDescription + XMLcontent
            case "pubDate":
                var cleanXMLContent = XMLcontent
                // Clean bad XML pubDate.
                // Mon, 04 Jul 2016 19:41:17 GMT +0200 -> Mon, 04 Jul 2016 19:41:17 +0200
                if cleanXMLContent.contains("GMT") {
                    cleanXMLContent = cleanXMLContent.replacingOccurrences(of: "GMT ", with: "")
                }
                
                let dateFormatter = DateFormatter() // Tue, 31 Jan 2023 23:00:00 GMT -> E, d MMM yyyy HH:mm:ss Z
                dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                let episodeDate: Date = dateFormatter.date(from: cleanXMLContent) ?? Date()
                
                episodePubDate = episodeDate
            case "itunes:explicit":
                episodeExplicit = episodeExplicit + XMLcontent
            case "itunes:duration":
                episodeDuration = episodeDuration + XMLcontent
            case "link":
                episodeLink = episodeLink + XMLcontent
            default:
                let a: Int = 0
            }
        } else {
            // Program data.
            switch elementName {
            case "channel":
                let program = Program()
                program.channelId = channelId
                program.title = programTitle
                program.descriptionText = programDescription
                program.category = programCategory
                program.imageURL = programImageURL
                program.explicit = programExplicit
                program.language = programLanguage
                program.author = programAuthor
                program.link = programLink
                program.copyright = programCopyright
                program.copyrightOwnerName = programCopyrightOwnerName
                program.copyrightOwnerEmail = programCopyrightOwnerEmail
                for episode in episodes {
                    program.episodes.append(episode)
                }
                newProgram = program
            case "title":
                if programTitle != XMLcontent {
                    programTitle = programTitle + XMLcontent
                }
            case "description":
                programDescription = programDescription + XMLcontent
            case "itunes:image":
                programImageURL = programImageURL + XMLcontent
            case "itunes:explicit":
                programExplicit = programExplicit + XMLcontent
            case "language":
                programLanguage = programLanguage + XMLcontent
            case "itunes:author":
                programAuthor = programAuthor + XMLcontent
            case "link":
                programLink = programLink + XMLcontent
            case "copyright":
                programCopyright = programCopyright + XMLcontent
            case "itunes:name":
                programCopyrightOwnerName = programCopyrightOwnerName + XMLcontent
            case "itunes:email":
                programCopyrightOwnerEmail = programCopyrightOwnerEmail + XMLcontent
            default:
                let a: Int = 0
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
