//
//  NSBundleExtension.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/21.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

public extension Bundle {
    public class func refreshBunle() -> Bundle {
        
        let bundleName = "JRefresh_JRefresh"

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,
            
            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: JRefreshComponent.self).resourceURL,
            
            // For command-line tools.
            Bundle.main.bundleURL
        ]
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)),let mainBundle = bundle.path(forResource: "JRefresh", ofType: "bundle") {
                print("JR:1 \(mainBundle.bundleURL)")
                return mainBundle
            }
        }
        print("JR:2 \(Bundle.main.bundleURL)")
        return Bundle.main
    }
    
    public class func arrowImage() -> UIImage {
        return UIImage(contentsOfFile: refreshBunle().path(forResource: "arrow@2x", ofType: "png")!)!.withRenderingMode(.alwaysTemplate)
    }
    
    public class func localizedString(_ key: String) -> String {
        return localizedString(key, nil)
    }
    public class func localizedString(_ key: String, _ value: String?) -> String {
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        var language = NSLocale.preferredLanguages.first ?? ""
        if language.hasPrefix("en") {
            language = "en"
        } else if language.hasPrefix("zh") {
            if (language.range(of: "Hans") != nil) {
                language = "zh-Hans"
            } else {
                language = "zh-Hant"
            }
        } else {
            language = "en"
        }

        guard let path = refreshBunle().path(forResource: language, ofType: "lproj") else {
            print("JR:3")
            return ""
        }
        print("JR:4 \(path)")
        let bundle = Bundle(path: path)
        let value = bundle?.localizedString(forKey: key, value: nil, table: nil)
        return Bundle.main.localizedString(forKey: key, value: value, table: nil)
    }
}
