//
//  StaticDataManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-20.
//

import Foundation

final class StaticDataManager {
    
    // MARK: - Properties
    
    private var channels: [Channel] = []
    private var realmManager: RealManagerProtocol
    
    // MARK: - Methods
    
    init(realmManager: RealManagerProtocol) {
        self.realmManager = realmManager
    }
    
    private func createStandardChannels() {
        let newChannel1 = Channel()
        newChannel1.name = "Uhin Ultramoreak - EITB"
        newChannel1.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/596735897/itunes/"
        channels.append(newChannel1)
        
        let newChannel2 = Channel()
        newChannel2.name = "Euskadi Irratia - Albisteak - EITB"
        newChannel2.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/590855897/itunes/"
        channels.append(newChannel2)
        
        let newChannel3 = Channel()
        newChannel3.name = "Eureka - EITB"
        newChannel3.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/328715897/itunes/"
        channels.append(newChannel3)
        
        let newChannel4 = Channel()
        newChannel4.name = "Zientzia gosaria - EITB"
        newChannel4.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/328775897/itunes/"
        channels.append(newChannel4)
        
        let newChannel5 = Channel()
        newChannel5.name = "Ingurusfera - EITB"
        newChannel5.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/332275897/itunes/"
        channels.append(newChannel5)
        
        let newChannel6 = Channel()
        newChannel6.name = "Berriztagarriak berritzen - EITB"
        newChannel6.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/445875897/itunes/"
        channels.append(newChannel6)
        
        let newChannel7 = Channel()
        newChannel7.name = "Astelehen poetikoak - Josu Goikoetxea - EITB"
        newChannel7.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/329795897/itunes/"
        channels.append(newChannel7)
        
        let newChannel8 = Channel()
        newChannel8.name = "Lokatza - EITB"
        newChannel8.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/355895897/itunes/"
        channels.append(newChannel8)
        
        let newChannel9 = Channel()
        newChannel9.name = "Gogoan - EITB"
        newChannel9.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/368015897/itunes/"
        channels.append(newChannel9)
        
        let newChannel10 = Channel()
        newChannel10.name = "Memoria eraikiz - EITB"
        newChannel10.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/464515897/itunes/"
        channels.append(newChannel10)
        
        let newChannel11 = Channel()
        newChannel11.name = "Tras la huella de ELKANOren Arrastoan - EITB"
        newChannel11.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/330455897/itunes/"
        channels.append(newChannel11)
        
        let newChannel12 = Channel()
        newChannel12.name = "Historia eta istorioak - EITB"
        newChannel12.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/456735897/itunes/"
        channels.append(newChannel12)
        
        let newChannel13 = Channel()
        newChannel13.name = "Digi-atala - EITB"
        newChannel13.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/329435897/itunes/"
        channels.append(newChannel13)
        
        let newChannel14 = Channel()
        newChannel14.name = "Zer ikusi? - EITB"
        newChannel14.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/330575897/itunes/"
        channels.append(newChannel14)
        
        let newChannel15 = Channel()
        newChannel15.name = "Opera prima,ABAOren podcasta - EITB"
        newChannel15.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/612735897/itunes/"
        channels.append(newChannel15)
        
        let newChannel16 = Channel()
        newChannel16.name = "Patrikako solfeoa - Ainara Ortega - EITB"
        newChannel16.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/329075897/itunes/"
        channels.append(newChannel16)
        
        let newChannel17 = Channel()
        newChannel17.name = "Barrutik - EITB"
        newChannel17.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/330215897/itunes/"
        channels.append(newChannel17)
        
        let newChannel18 = Channel()
        newChannel18.name = "Filosofia merkea - Markos Zapiain - EITB"
        newChannel18.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/331175897/itunes/"
        channels.append(newChannel18)
        
        let newChannel19 = Channel()
        newChannel19.name = "Doana jasoz - EITB"
        newChannel19.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/339995897/itunes/"
        channels.append(newChannel19)
        
        let newChannel20 = Channel()
        newChannel20.name = "Perlak - EITB"
        newChannel20.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/367955897/itunes/"
        channels.append(newChannel20)
        
        let newChannel21 = Channel()
        newChannel21.name = "Hitza jolas - EITB"
        newChannel21.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/396335897/itunes/"
        channels.append(newChannel21)
        
        let newChannel22 = Channel()
        newChannel22.name = "Yoko Ona - EITB"
        newChannel22.urlAddress = "https://api.eitb.eus/api/eitbpodkast/getRss/438635897/itunes/"
        channels.append(newChannel22)
        
        let newChannel23 = Channel()
        newChannel23.name = "gazteON - Eta Kitto..."
        newChannel23.urlAddress = "https://www.ivoox.com/gazteon_fg_f1766426_filtro_1.xml"
        channels.append(newChannel23)
        
        let newChannel24 = Channel()
        newChannel24.name = "GazteON - Bizkaia Irratia"
        newChannel24.urlAddress = "https://www.ivoox.com/gazteon_fg_f1795727_filtro_1.xml"
        channels.append(newChannel24)
        
        let newChannel25 = Channel()
        newChannel25.name = "Kabala - Klak"
        newChannel25.urlAddress = "https://www.ivoox.com/feed_fg_f11381606_filtro_1.xml"
        channels.append(newChannel25)
        
        let newChannel26 = Channel()
        newChannel26.name = "Solas Enea - Cristina Enea Fundazioa"
        newChannel26.urlAddress = "https://www.ivoox.com/feed_fg_f11397658_filtro_1.xml"
        channels.append(newChannel26)
        
        let newChannel27 = Channel()
        newChannel27.name = "Zorionagurrak - Bizkaia Irratia"
        newChannel27.urlAddress = "https://bizkaiairratia.eus/xml/zorionagurrak"
        channels.append(newChannel27)
        
        let newChannel28 = Channel()
        newChannel28.name = "Goizeko izarretan - Bizkaia Irratia"
        newChannel28.urlAddress = "https://bizkaiairratia.eus/xml/goizeko-izarretan"
        channels.append(newChannel28)
        
        let newChannel29 = Channel()
        newChannel29.name = "Lau haizetara - Bizkaia Irratia"
        newChannel29.urlAddress = "https://bizkaiairratia.eus/xml/lau-haizetara"
        channels.append(newChannel29)
        
        let newChannel30 = Channel()
        newChannel30.name = "Jirabiran - Bizkaia Irratia"
        newChannel30.urlAddress = "https://bizkaiairratia.eus/xml/jirabiran"
        channels.append(newChannel30)
        
        let newChannel31 = Channel()
        newChannel31.name = "Jokoan - Bizkaia Irratia"
        newChannel31.urlAddress = "https://bizkaiairratia.eus/xml/jokoan"
        channels.append(newChannel31)
        
        let newChannel32 = Channel()
        newChannel32.name = "Herriz herri - Bizkaia Irratia"
        newChannel32.urlAddress = "https://bizkaiairratia.eus/xml/herriz-herri"
        channels.append(newChannel32)
        
        let newChannel33 = Channel()
        newChannel33.name = "Irakurrieran - Bizkaia Irratia"
        newChannel33.urlAddress = "https://bizkaiairratia.eus/xml/irakurrieran"
        channels.append(newChannel33)
        
        let newChannel34 = Channel()
        newChannel34.name = "Albistekia - Asier Errasti"
        newChannel34.urlAddress = "https://baleafunk.eus/api/v1/channels/albistekia/rss"
        channels.append(newChannel34)
        
        let newChannel35 = Channel()
        newChannel35.name = "Lehen LH Etxepare Lizeoa"
        newChannel35.urlAddress = "https://baleafunk.eus/api/v1/channels/lehenlhetxeparelizeoa20222023/rss"
        channels.append(newChannel35)
        
        let newChannel36 = Channel()
        newChannel36.name = "BTN"
        newChannel36.urlAddress = "https://baleafunk.eus/api/v1/channels/btn/rss"
        channels.append(newChannel36)
        
        let newChannel37 = Channel()
        newChannel37.name = "Oinherri"
        newChannel37.urlAddress = "https://baleafunk.eus/api/v1/channels/oinherripodkastak/rss"
        channels.append(newChannel37)
        
        let newChannel38 = Channel()
        newChannel38.name = "Borroka, maitasun eta traizio istorioak - Argia"
        newChannel38.urlAddress = "https://baleafunk.eus/api/v1/channels/borroka_maitasun_eta_traizio_istorioak/rss"
        channels.append(newChannel38)
        
        let newChannel39 = Channel()
        newChannel39.name = "Linuxtarrak garelako"
        newChannel39.urlAddress = "https://baleafunk.eus/api/v1/channels/linuxtarrakgarelakopodcast/rss"
        channels.append(newChannel39)
        
        let newChannel40 = Channel()
        newChannel40.name = "Solasak"
        newChannel40.urlAddress = "https://baleafunk.eus/api/v1/channels/solasak/rss"
        channels.append(newChannel40)
        
        let newChannel41 = Channel()
        newChannel41.name = "Eskilarapeko irratia - Ermuko Irrati Askea"
        newChannel41.urlAddress = "https://baleafunk.eus/api/v1/channels/eskilarapeko_irratia/rss"
        channels.append(newChannel41)
        
        let newChannel42 = Channel()
        newChannel42.name = "Hezitzaile bat sarean"
        newChannel42.urlAddress = "https://baleafunk.eus/api/v1/channels/hezitzailebatsarean/rss"
        channels.append(newChannel42)
        
        let newChannel43 = Channel()
        newChannel43.name = "Guraso.eus"
        newChannel43.urlAddress = "https://baleafunk.eus/api/v1/channels/gurasoeus/rss"
        channels.append(newChannel43)
        
        let newChannel44 = Channel()
        newChannel44.name = "Gonagorri haur eta gazte literatura - Gonagorri Galtzagorri Elkartea"
        newChannel44.urlAddress = "https://baleafunk.eus/api/v1/channels/gonagorri/rss"
        channels.append(newChannel44)
        
        let newChannel45 = Channel()
        newChannel45.name = "Ama(t)Asunak"
        newChannel45.urlAddress = "https://baleafunk.eus/api/v1/channels/sabeletikmundura/rss"
        channels.append(newChannel45)
        
        let newChannel46 = Channel()
        newChannel46.name = "Podcastak.eus"
        newChannel46.urlAddress = "https://baleafunk.eus/api/v1/channels/podcastakeus/rss"
        channels.append(newChannel46)
        
        let newChannel47 = Channel()
        newChannel47.name = "Xabildua"
        newChannel47.urlAddress = "https://baleafunk.eus/api/v1/channels/xabilduapodcast/rss"
        channels.append(newChannel47)
        
        let newChannel48 = Channel()
        newChannel48.name = "Bestelakoak - Argia"
        newChannel48.urlAddress = "https://baleafunk.eus/api/v1/channels/bestelakoak/rss"
        channels.append(newChannel48)
        
        let newChannel49 = Channel()
        newChannel49.name = "Puska dezagun izotza - Argia"
        newChannel49.urlAddress = "https://baleafunk.eus/api/v1/channels/puskadezagunizotza/rss"
        channels.append(newChannel49)
        
        let newChannel50 = Channel()
        newChannel50.name = "Oasiko kronikak - Argia"
        newChannel50.urlAddress = "https://baleafunk.eus/api/v1/channels/oasikokronikak/rss"
        channels.append(newChannel50)
        
        let newChannel51 = Channel()
        newChannel51.name = "ARGIAren podcastak - Argia"
        newChannel51.urlAddress = "https://baleafunk.eus/api/v1/channels/argiarenpodcastak/rss"
        channels.append(newChannel51)
        
        let newChannel52 = Channel()
        newChannel52.name = "Beranduegi - Argia"
        newChannel52.urlAddress = "https://baleafunk.eus/api/v1/channels/beranduegi/rss"
        channels.append(newChannel52)
        
        let newChannel53 = Channel()
        newChannel53.name = "Hodeia ez da existitzen"
        newChannel53.urlAddress = "https://baleafunk.eus/api/v1/channels/hodeiaezdaexistitzen/rss"
        channels.append(newChannel53)
        
        let newChannel54 = Channel()
        newChannel54.name = "Akabo bakea"
        newChannel54.urlAddress = "https://www.eitb.eus/multimedia/podcast/950929.xml"
        channels.append(newChannel54)
        
        let newChannel55 = Channel()
        newChannel55.name = "Xerezaderen Artxiboa"
        newChannel55.urlAddress = "http://www.xerezade.org/media-rss"
        channels.append(newChannel55)
        
        /*
         let newChannel = Channel()
         newChannel.name = ""
         newChannel.urlAddress = ""
         channels.append(newChannel)
         */
    }
    
    private func saveChannelsInRealm() {
        realmManager.saveChannels(channels)
    }
    
    func start() {
        createStandardChannels()
        saveChannelsInRealm()
    }
    
}
