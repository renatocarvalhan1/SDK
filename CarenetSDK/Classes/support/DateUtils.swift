//
//  DateUtils.swift
//  RemoteCare
//
//  Created by Renato Carvalhan on 05/10/17.
//

import Foundation

@objc public class DateUtils : NSObject {
    
    static func stringAsUtcIso()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        
        let str = dateFormatter.string(from: Date())

        return str
    }
    
    static func isoDateFormatter()->DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        return dateFormatter
    }
    
    static func friendlyIsoDateFormatter()->DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy' 'HH:mm"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "BRT")! as TimeZone
        return dateFormatter
    }
    
    static func friendlyIsoNoTimeFormatter()->DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyy"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "BRT")! as TimeZone
        return dateFormatter
    }
    
    static func stringAsIso()->String{
        return stringAsIso(date: Date())
    }
    
    static func stringAsIso(date: Date)->String{
        let strDate = isoDateFormatter().string(from: date)
        return strDate
    }
    
    static func stringAsFriendlyIso(dateStr: String)->String{
        let strDate = friendlyIsoDateFormatter().string(from: parseIsoDate(dateStr: dateStr))
        return strDate
    }
    
    static func stringAsFriendlyIsoNoTime(dateStr: String)->String{
        let strDate = friendlyIsoNoTimeFormatter().string(from: parseIsoDate(dateStr: dateStr))
        return strDate
    }
    
    static func parseIsoDate(dateStr: String)->Date{
        let date = isoDateFormatter().date(from: dateStr)
        return date!
    }
    
    static func parseIsoBrtDate(dateStr: String)->Date{
        let date = isoDateBrtFormatter().date(from: dateStr)
        return date!
    }
    
    static func isoDateBrtFormatter()->DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //dateFormatter.timeZone = NSTimeZone(abbreviation: "BRT")! as TimeZone
        return dateFormatter
    }
}
