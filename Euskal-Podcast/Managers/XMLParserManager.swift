//
//  XMLParserManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2/2/23.
//

import Foundation

final class XMLParserManager: NSObject {
    
    // MARK: - Properties
    
    var parser = XMLParser()
    
    var XMLcontent : String = ""
    
    var program: ProgramXML?
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
    var episodePubDate:     String = ""
    var episodeExplicit:    String = ""
    var episodeFileURL:     String = ""
    var episodeFileSize:    String = ""
    var episodeDuration:    String = ""
    var episodeLink:        String = ""
    
    var episodes: [EpisodeXML] = []
    
    // MARK: - Methods
    
    func parseURL(urlString: String) {
        guard let safeURL: URL = URL(string: urlString) else { return }
        
        let concurrentQueue = DispatchQueue(label: "XMLParser")
        concurrentQueue.async {
            self.parser = XMLParser(contentsOf: safeURL) ?? XMLParser()
            self.parser.delegate = self
            self.parser.parse()
        }
    }
    
}

extension XMLParserManager: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {}
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            isItem = true
            
            episodeTitle = ""
            episodeDescription = ""
            episodePubDate = ""
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
                episodePubDate = episodePubDate + XMLcontent
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
                let newProgram = ProgramXML(title: programTitle,
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
                program = newProgram
            case "title":
                programTitle = programTitle + XMLcontent
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
        if let program = program {
            print("\(program)")
        }
    }
    
}
