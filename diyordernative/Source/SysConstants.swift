//
//  SysConstants.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-12.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation

struct SysConstants
{
    // MARK: - API URL
    
    private static let BASE_URL         = "https://api.goopter.com"
    
    static let REST_PATH_BANNER_ITEM    = BASE_URL + "/api/v6/hlst"
    
    static let REST_PATH_HOT_ITEM       = BASE_URL + "/api/v6/hsearch"
    
    // MARK: - Language
    
    // [system language key, server language key, display title]
    static let LANGUAGE_MAPPING_ARR : [[String]] = [
        ["en", "en", "English"],
        ["zh-Hans", "zh", "简体中文"],
        ["zh-Hant", "zh-Hant", "繁体中文"],
        ["es", "es", "Español"],
        ["fr", "fr", "Français"],
        ["ja", "ja", "日本語"],
        ["ko", "ko", "한국어"],
        ["pt", "pt", "Português"],
        ["hi", "hi", "हिंदी"],
        ["nl", "nl", "Nederlands"],
        ["de", "de", "Deutsche"],
        ["ru", "ru", "Русский"],
        ["it", "it", "Italiano"],
        ["ar", "ar", "العربية"],
    ]
    
    static let AVALIABEL_APP_LANGUAGE_INDEX : [Int] = [0, 1, 2]
    
    static let DEFAULT_APP_LANGUAGE_INDEX : Int = 0
}