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
    var program = PassthroughSubject<ProgramXML, Error>()
    
    var parser = XMLParser()
    
    var channelId: String = ""
    
    var XMLcontent : String = ""
    
    var newProgram: ProgramXML?
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
    
    var episodes: [EpisodeXML] = []
    
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
                let newEpisode = EpisodeXML(title: episodeTitle,
                                            description: episodeDescription,
                                            pubDate: episodePubDate,
                                            explicit: episodeExplicit,
                                            audioFileURL: episodeFileURL,
                                            audioFileSize: episodeFileSize,
                                            duration: episodeDuration,
                                            link: episodeLink)
                episodes.append(newEpisode)
                
                isItem = false
            case "title":
                episodeTitle = episodeTitle + XMLcontent
            case "description":
                episodeDescription = episodeDescription + XMLcontent
            case "pubDate":
                let dateFormatter = DateFormatter() // Tue, 31 Jan 2023 23:00:00 GMT -> E, d MMM yyyy HH:mm:ss Z
                dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                let episodeDate: Date = dateFormatter.date(from: XMLcontent) ?? Date()
                
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
                let program = ProgramXML(channelId: channelId,
                                         title: programTitle,
                                         description: programDescription,
                                         category: programCategory,
                                         imageURL: programImageURL,
                                         explicit: programExplicit,
                                         language: programLanguage,
                                         author: programAuthor,
                                         link: programLink,
                                         copyright: programCopyright,
                                         copyrightOwnerName: programCopyrightOwnerName,
                                         copyrightOwnerEmail: programCopyrightOwnerEmail,
                                         episodes: episodes)
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
