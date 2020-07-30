//
//  ClockViewParts
//  Labels.swift
//
//  Created by Valeriano Della Longa on 28/07/2020.
//  Copyright © 2020 Valeriano Della Longa. All rights reserved.
//

import SwiftUI

public struct Labels<Content: View>: View {
    public init(
        labels: [Int],
        @ViewBuilder content: @escaping (Int, Text
        ) -> Content
    ) {
        self.labels = labels
        self.content = content
    }
    
    public var labels: [Int]
    
    public var content: (Int, Text) -> Content
    
    public var body: some View {
        GeometryReader { proxy in
            self.labelsBuild(in: proxy.size)
        }
    }
    
    // MARK: - Views
    private func labelsBuild(in containerSize: CGSize) -> some View {
        ZStack {
            getEachLabelView(in: containerSize)
            Color.clear
                .frame(
                    width: containerSize.width,
                    height: containerSize.height
            )
        }
    }
    
    private func getEachLabelView(in containerSize: CGSize) -> some View {
        
        ForEach(labels.indices, id: \.self) { idx in
            self.getContent(at: idx)
                .offset(
                    self.clockOffset(
                        in: containerSize,
                        at: idx
                    )
            )
                /*
                .clockAlignment(
                    with: self.clockOffset(
                        in: containerSize,
                        at: idx
                    )
            )
            */
        }
    }
    
    private func getContent(at idx: Int) -> Content {
        let text = Text("\(labels[idx])")
        
        return content(idx, text)
    }
    
    // MARK: - Helpers
    private func clockOffset(in size: CGSize, at idx: Int) -> CGSize
    {
        let angle = Angle.degrees(Double(idx) * 360 / Double(self.labels.count) - 90)
        let radius = min(size.width, size.height) / 2
        let width = CGFloat(cos(angle.radians)) * radius
        let height = CGFloat(sin(angle.radians)) * radius
        
        return CGSize(width: width, height: height)
    }
    
}

#if DEBUG
struct Labels_Previews: PreviewProvider {
    static var previews: some View {
        Labels(
            labels: [12] + stride(from: 1, through: 11, by: 1)
        ) { _, label in
            label
        }
            .padding()
    }
}
#endif

fileprivate extension View {
    func clockAlignment(with offset: CGSize) -> some View {
        self
            .alignmentGuide(
                HorizontalAlignment.center,
                computeValue: { $0[HorizontalAlignment.center] - offset.width }
        )
            .alignmentGuide(
                VerticalAlignment.center,
                computeValue: { $0[VerticalAlignment.center] - offset.height }
        )
    }
    
}
