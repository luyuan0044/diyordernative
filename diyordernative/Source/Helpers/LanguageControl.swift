//
//  LanguageControl.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-14.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation

class LanguageControl {
    
    static let shared = LanguageControl()
    
    // MARK: - App Language Implementation
    
    private let APP_LANGUAGE_ARCHIVE_KEY = "APP_LANGUAGE_ARCHIVE_KEY"
    
    private var avaliableAppLanguages: [Language] = []
    
    private var appLanguage: Language!
    
    private var appBundle: Bundle?
    
    /**
     Initialize application language and avaliable application languages
     */
    func initAppLanguage () {
        for idx in SysConstants.AVALIABEL_APP_LANGUAGE_INDEX {
            let languageMap = SysConstants.LANGUAGE_MAPPING_ARR[idx]
            let language = Language (key: languageMap[0], serverKey: languageMap[1], description: languageMap[2])
            avaliableAppLanguages.append(language)
        }
        
        if let language = readAppLanguage() {
            appLanguage = language
        }
        else {
            let systemLanguageKey = Locale.preferredLanguages[0]
            var language = getLanguage(of: systemLanguageKey, by: .serverKey)
            
            if language == nil {
                let languageMap = SysConstants.LANGUAGE_MAPPING_ARR[SysConstants.DEFAULT_APP_LANGUAGE_INDEX]
                language = Language (key: languageMap[0], serverKey: languageMap[1], description: languageMap[2])
            }
            
            setAppLanguage(language!)
        }
    }
    
    /**
     Get avalible application languages
     
     - returns: Array of avaliable 'Language'
     */
    func getAvaliableAppLanguages () -> [Language] {
        return avaliableAppLanguages
    }
    
    /**
     Get application language.
     
     - returns: 'Language'
     */
    func getAppLanguage () -> Language {
        return appLanguage
    }
    
    /**
     Set application language and archive for further use.
     
     - parameter language: 'Language'
     */
    func setAppLanguage (_ language: Language) {
        appLanguage = language
        archiveAppLanguage ()
        
        let path = Bundle.main.path(forResource: appLanguage.key, ofType: "lproj")
        if path != nil {
            appBundle = Bundle (path: path!)
        } else {
            appBundle = Bundle.main
        }
    }
    
    /**
     Get language object by given key and the type of given key
     
     - parameter key: Langauge key provided to find 'Language' object
     - parameter type: Type of the language key provided
     
     - returns: 'Language' object. if key cannot be recognized will return nil
     */
    func getLanguage (of key: String, by type: languageType) -> Language? {
        if let languageMap = SysConstants.LANGUAGE_MAPPING_ARR.filter({$0[type.rawValue] == key}).first {
            return Language (key: languageMap[0], serverKey: languageMap[1], description: languageMap[2])
        }
        
        return nil
    }
    
    /**
     Archive application language to user preference
     */
    private func archiveAppLanguage () {
        UserDefaults.standard.set(appLanguage.key, forKey: APP_LANGUAGE_ARCHIVE_KEY)
    }
    
    /**
     Read application langauge from user preference
    
     - returns: 'Language' object. if cannot find key will return nil
     */
    private func readAppLanguage () -> Language? {
        if let archivedLanguageKey = UserDefaults.standard.string(forKey: APP_LANGUAGE_ARCHIVE_KEY), let language = getLanguage(of: archivedLanguageKey, by: .systemKey) {
            return language
        }
        
        return nil
    }
    
    func getLocalizeString(by key: String) -> String {
        return appBundle!.localizedString(forKey: key, value: "", table: nil)
    }
    
    func getLocalizeString(by key: String, with language: Language) -> String {
        let bundlePath = Bundle.main.path(forResource: language.key, ofType: "lproj")
        let bundle: Bundle?
        
        if bundlePath != nil {
            bundle = Bundle (path: bundlePath!)
        } else {
            bundle = Bundle.main
        }
        
        if bundle == nil {
            return ""
        } else {
            return bundle!.localizedString(forKey: key, value: "", table: nil)
        }
    }
}

enum languageType: Int
{
    case systemKey = 0
    case serverKey
    case description
}
