//
//  ClockViewParts
//  Ticks.swift
//
//  Created by Valeriano Della Longa on 28/07/2020.
//  Copyright © 2020 Valeriano Della Longa. All rights reserved.
//

import SwiftUI

public struct Ticks: View {
    public init(
        majorTicks: Int,
        subdivisions: Int,
        lenght: CGFloat,
        width: CGFloat = 2.0,
        baseColor: Color = .secondary,
        highlightedColor: Color = .primary
    ) {
        self.majorTicks = majorTicks
        self.subdivisions = subdivisions
        self.lenght = lenght
        self.width = width
        self.baseColor = baseColor
        self.highlightedColor = highlightedColor
    }
    
    public var majorTicks: Int
    
    public var subdivisions: Int
    
    public var lenght: CGFloat
    
    public var width: CGFloat
    
    public var highlightedColor: Color
    
    public var baseColor: Color
    
    private var totalTicks: Int {
        majorTicks * subdivisions
    }
    
    private var highlitedTicks: Int {
        majorTicks / 5
    }
    
    public var body: some View {
        ZStack {
            _Ticks(
                numberOfTicks: totalTicks,
                lenght: lenght/2,
                skipEvery: subdivisions
            )
                .stroke(
                    baseColor,
                    lineWidth: width
            )
            
            _Ticks(
                numberOfTicks: majorTicks,
                lenght: lenght,
                skipEvery: 5
            )
                .stroke(
                    baseColor,
                    lineWidth: width
            )
            
            _Ticks(
                numberOfTicks: highlitedTicks,
                lenght: lenght
            )
                .stroke(
                    highlightedColor,
                    lineWidth: width
            )
            
            Color.clear
        }
        .aspectRatio(
            1,
            contentMode: .fit
        )
    }
    
}

#if DEBUG
struct TicksView_Previews: PreviewProvider {
    static var previews: some View {
        Ticks(
            majorTicks: 60,
            subdivisions: 4,
            lenght: 15
        )
            .padding()
    }
}
#endif

fileprivate struct _Ticks: Shape {
    var numberOfTicks: Int
    
    var lenght: CGFloat
    
    var skipEvery: Int = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let radius = min(rect.midX, rect.midY)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startDistance = radius - lenght
        let degreesFactor = 360 / Double(numberOfTicks)
        
        for tick in 0..<numberOfTicks
            where (skipEvery <= 0 || tick % skipEvery != 0)
        {
            let angle = Angle.degrees(Double(tick) * degreesFactor - 90)
            let xFactor: CGFloat = CGFloat(cos(angle.radians))
            let yFactor: CGFloat = CGFloat(sin(angle.radians))
            
            let startPointX = center.x + startDistance * xFactor
            let startPointY = center.y - startDistance * yFactor
            let startPoint = CGPoint(x: startPointX, y: startPointY)
            
            let endPointX = startPointX + lenght * xFactor
            let endPointY = startPointY - lenght * yFactor
            let endPoint = CGPoint(x: endPointX, y: endPointY)
            
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }
        
        return path
    }
    
}
