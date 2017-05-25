//
//  TimeChank.swift
//  Assignments
//
//  Created by Andrey Sak on 5/25/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation

public struct TimeChunk {
    
    public var seconds = 0
    public var minutes = 0
    public var hours = 0
    public var days = 0
    public var weeks = 0
    public var months = 0
    public var years = 0
    
    public init() {}
    
    public init(minutes: Int) {
        self.minutes = minutes
    }
    
    public init(hours: Int) {
        self.hours = hours
    }
    
    public init(days: Int) {
        self.days = days
    }
    
    public init(weeks: Int) {
        self.weeks = weeks
    }
    
    public init(months: Int) {
        self.months = months
    }
    
    public init(seconds: Int, minutes: Int, hours: Int, days: Int, weeks: Int, months: Int, years: Int) {
        self.seconds = seconds
        self.hours = hours
        self.days = days
        self.weeks = weeks
        self.months = months
        self.years = years
    }
    
}

public extension Date {
    
    public func add(_ chunk: TimeChunk) -> Date {
        let calendar = Calendar.autoupdatingCurrent
        var components = DateComponents()
        components.year = chunk.years
        components.month = chunk.months
        components.day = chunk.days + (chunk.weeks * 7)
        components.hour = chunk.hours
        components.minute = chunk.minutes
        components.second = chunk.seconds
        
        return calendar.date(byAdding: components, to: self)!
    }
    
    public func subtract(_ chunk: TimeChunk) -> Date {
        let calendar = Calendar.autoupdatingCurrent
        var components = DateComponents()
        components.year = -chunk.years
        components.month = -chunk.months
        components.day = -(chunk.days + (chunk.weeks * 7))
        components.hour = -chunk.hours
        components.minute = -chunk.minutes
        components.second = -chunk.seconds
        
        return calendar.date(byAdding: components, to: self)!
    }
    
    public func bySettingCurrentTime() -> Date? {
        let calendar: Calendar = .current
        let currentDate = Date()
        let hourMinuteComponents = Set<Calendar.Component>(arrayLiteral: .hour, .minute)
        let currentDateHourMinuteComponents = calendar.dateComponents(hourMinuteComponents, from: currentDate)
        
        return calendar.date(byAdding: currentDateHourMinuteComponents, to: self)
    }
    
}
