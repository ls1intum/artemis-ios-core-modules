//
//  Chip.swift
//  
//
//  Created by Sven Andabaka on 20.03.23.
//

import SwiftUI

public struct Chip: View {

    var text: String
    var backgroundColor: Color
    var padding: CGFloat

    public init(text: String, backgroundColor: Color, padding: CGFloat = .m) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.padding = padding
    }

    public var body: some View {
        Text(text)
            .bold()
            .lineLimit(1)
            .foregroundColor(.white)
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}
