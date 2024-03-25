//
//  ProgressBar.swift
//  
//
//  Created by Sven Andabaka on 15.03.23.
//

import Charts
import SwiftUI

public struct ProgressBar: View {
    let value: Int
    let total: Int
    let backgroundColor: Color
    let ringColor: Color

    public init(
        value: Int,
        total: Int,
        backgroundColor: Color = Color.Artemis.courseScoreProgressBackgroundColor,
        ringColor: Color = Color.Artemis.courseScoreProgressRingColor
    ) {
        self.value = value
        self.total = total
        self.backgroundColor = backgroundColor
        self.ringColor = ringColor
    }

    public var body: some View {
        Chart(data) { score in
            SectorMark(
                angle: PlottableValue.value("Score", score.value),
                innerRadius: MarkDimension.ratio(2.0 / 3),
                angularInset: .xxs
            )
            .foregroundStyle(score.id.color)
            .cornerRadius(.l)
        }
        .chartBackground { _ in
            VStack {
                Text(value.formatted() + " / " + total.formatted())
                Text("Pts")
            }
        }
    }
}

private extension ProgressBar {
    struct Fraction: Identifiable {
        // swiftlint:disable:next type_name
        enum ID {
            case success
            case failure
            case placeholder

            var color: Color {
                switch self {
                case .success:
                    return Color.Artemis.courseScoreProgressRingColor
                case .failure:
                    return Color.Artemis.courseScoreProgressBackgroundColor
                case .placeholder:
                    return Color.Artemis.courseScoreProgressPlaceholderColor
                }
            }
        }

        var id: ID
        var value: Int
    }

    var data: [Fraction] {
        if total == 0 {
            return [Fraction(id: .placeholder, value: 1)]
        } else {
            let remainder = total - value
            return [Fraction(id: .success, value: value), Fraction(id: .failure, value: remainder)]
        }
    }
}
