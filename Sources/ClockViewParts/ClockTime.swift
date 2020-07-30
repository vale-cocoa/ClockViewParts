//  ClockViewParts
//  ClockTime.swift
//  
//  Created by Valeriano Della Longa on 28/07/2020.
//  Copyright © 2020 Valeriano Della Longa. All rights reserved.
//

import SwiftUI

public struct ClockTime {
    public var seconds: Double
    
    public var wallTime: (hour: Double, minute: Double, second: Double) {
        return Self.wallTime(seconds: self.seconds)
    }
    
    public var hour: Double { self.wallTime.hour }
    public var minute: Double { self.wallTime.minute }
    public var second: Double { self.wallTime.second }
    
    private static func wallTime(seconds: Double) -> (hour: Double, minute: Double, second: Double) {
        let h = Int(seconds) / 3600
        let m = (Int(seconds) - (h * 3600)) / 60
        let s = seconds - Double((h * 3600) + (m * 60))
        
        let second = s
        let minute = Double(m) + (s / 60)
        let hour = Double(h) + (minute / 60)
        
        return (hour, minute, second)
    }
    
    public init(_ seconds: Double) {
        self.seconds = seconds
    }
    
    public init(h: Int, m: Int, s: Int) {
        let seconds = h * 3600 + m * 60 + s
        self.init(Double(seconds))
    }
    
}

// MARK: - VectorArithmetic conformance
extension ClockTime: VectorArithmetic {
    public static var zero: ClockTime { return ClockTime(h: 0, m: 0, s: 0) }
    
    public var magnitudeSquared: Double { return seconds * seconds }
    
    public static func -(lhs: ClockTime, rhs: ClockTime) -> ClockTime {
        ClockTime(lhs.seconds - rhs.seconds)
    }
    
    public static func -=(lhs: inout ClockTime, rhs: ClockTime) {
        lhs = lhs - rhs
    }
    
    public static func +(lhs: ClockTime, rhs: ClockTime) -> ClockTime {
        ClockTime(lhs.seconds + rhs.seconds)
    }
    
    public static func +=(lhs: inout ClockTime, rhs: ClockTime) {
        lhs = lhs + rhs
    }
    
    public mutating func scale(by rhs: Double) {
        self.seconds.scale(by: rhs)
    }
    
}
