//
//  ClockViewParts
//  Hands.swift
//
//  Created by Valeriano Della Longa on 29/07/2020.
//  Copyright © 2020 Valeriano Della Longa. All rights reserved.
//

import SwiftUI

public struct Hands: Shape {
    public enum Hand: CaseIterable {
        case hour
        case minute
        case second
        
        var lenghtFactor: CGFloat {
            switch self {
            case .hour:
                return 0.65
            case .minute:
                return 0.87
            case .second:
                return 1.0
            }
        }
        
    }
    
    public var clockTime: ClockTime
    
    public var visibleHands: Set<Hand>
    
    @Binding public var isAM : Bool
    
    public var animatableData: ClockTime {
        get { clockTime }
        set { clockTime = newValue }
    }
    
    public init(clockTime: ClockTime, isAM: Binding<Bool>, visibleHands: Set<Hand> = Set(Hand.allCases)) {
        self.clockTime = clockTime
        self._isAM = isAM
        self.visibleHands = visibleHands
    }
    
    public func path(in rect: CGRect) -> Path {
        DispatchQueue.main.async {
            self.isAM = self.clockTime.hour < 12.0
        }
        let radius = min(rect.size.width, rect.size.height) / 2
        let center: CGPoint = CGPoint(x: rect.midX, y: rect.midY)
        
        var path = Path()
        
        if visibleHands.contains(.hour) {
            let hAngle: Angle = .degrees(clockTime.hour / 12 * 360)
            
            let hourHand = largeNeedle(center: center, radius: radius, lenghtFactor: Hand.hour.lenghtFactor)
            
            let t = rotationTransform(angle: hAngle, anchor: center)
            
            path.addPath(hourHand, transform: t)
        }
        
        if visibleHands.contains(.minute) {
            let mAngle: Angle = .degrees(clockTime.minute / 60 * 360)
            
            let minuteHand = largeNeedle(center: center, radius: radius, lenghtFactor: Hand.minute.lenghtFactor)
            
            let t = rotationTransform(angle: mAngle, anchor: center)
            
            path.addPath(minuteHand, transform: t)
        }
        
        if visibleHands.contains(.second) {
            let sAngle: Angle = .degrees(clockTime.second / 60 * 360)
            
            let secondHand = slimNeedle(center: center, radius: radius)
            
            let t = rotationTransform(angle: sAngle, anchor: center)
            
            path.addPath(secondHand, transform: t)
        }
        
        return path
    }
    
    private func largeNeedle(center: CGPoint, radius: CGFloat, lenghtFactor: CGFloat) -> Path {
        let anchorRadius = radius * 0.02
        let anchorRect: CGRect = CGRect(origin: CGPoint(x: center.x - anchorRadius, y: center.y - anchorRadius), size: CGSize(width: anchorRadius * 2, height: anchorRadius * 2))
        
        var path = Path()
        
        path.addEllipse(in: anchorRect)
        path.move(to: CGPoint(x: center.x, y: center.y - anchorRadius))
        path.addLine(to: CGPoint(x: center.x, y: center.y - radius * 0.1))
        path.addRoundedRect(in: CGRect(origin: CGPoint(x: center.x - anchorRadius, y: center.y - radius * 0.1), size: CGSize(width: anchorRadius * 2, height: -(radius - (radius * 0.1)) * lenghtFactor)), cornerSize: CGSize(width: anchorRadius, height: anchorRadius))
        
        path = path.strokedPath(StrokeStyle(lineWidth: 2.0))
        
        return path
    }
    
    private func slimNeedle(center: CGPoint, radius: CGFloat) -> Path {
        let anchorRadius = radius * 0.015
        let anchorRect: CGRect = CGRect(origin: CGPoint(x: center.x - anchorRadius, y: center.y - anchorRadius), size: CGSize(width: anchorRadius * 2, height: anchorRadius * 2))
        
        var path = Path()
        path.move(to: CGPoint(x: center.x, y: center.y - anchorRadius))
        path.addLine(to: CGPoint(x: center.x, y: center.y - radius))
        
        path.move(to: CGPoint(x: center.x, y: center.y + anchorRadius))
        path.addLine(to: CGPoint(x: center.x, y: center.y + anchorRadius + (radius * 0.1)))
        
        path = path.strokedPath(StrokeStyle(lineWidth: 1.0))
        
        path.addEllipse(in: anchorRect)
        
        return path
    }
    
    private func rotationTransform(angle: Angle, anchor: CGPoint) -> CGAffineTransform {
        var t = CGAffineTransform.identity
        t = t.concatenating(CGAffineTransform(translationX: -anchor.x, y: -anchor.y))
        t = t.concatenating(CGAffineTransform(rotationAngle: CGFloat(angle.radians)))
        t = t.concatenating(CGAffineTransform(translationX: anchor.x, y: anchor.y))
        
        return t
    }
    
}

#if DEBUG
struct Hands_Previews: PreviewProvider {
    struct _PreviewWrapper: View {
        @State private var clockTime: ClockTime = ClockTime(h: 10, m: 10, s: 0)
        @State private var isAM: Bool = true
        
        var body: some View {
            VStack {
                Hands(
                    clockTime: self.clockTime,
                    isAM: self.$isAM
                )
                    .aspectRatio(
                        1.0,
                        contentMode: .fit
                )
                
                Spacer()
                
                Button(
                    action: {
                        let h = self.isAM ? 12 : -12
                        withAnimation(
                            Animation.easeInOut(duration: 3.0),
                            {
                            self.clockTime += ClockTime(h: h, m: 0, s: 0)
                                
                        })
                },
                    label: { Text("Toggle isAM") }
                )
                
                
                Spacer()
                
                Text(self.isAM ? "AM" : "PM")
                    .animation(nil)
                
                Spacer()
            }
        }
    }
    
    static var previews: some View {
        _PreviewWrapper()
            .padding()
    }
}

#endif
