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
        newChannel21.name = "Hitza Jolas - EITB"
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
        newChannel25.name = "KABALA - Klak"
        newChannel25.urlAddress = "https://www.ivoox.com/feed_fg_f11381606_filtro_1.xml"
        channels.append(newChannel25)
        
        let newChannel26 = Channel()
        newChannel26.name = "Solas Enea - Cristina Enea Fundazioa"
        newChannel26.urlAddress = "https://www.ivoox.com/feed_fg_f11397658_filtro_1.xml"
        channels.append(newChannel26)
    }
    
    private func saveChannelsInRealm() {
        realmManager.saveChannels(channels: channels)
    }
    
    func start() {
        createStandardChannels()
        saveChannelsInRealm()
    }
    
}
