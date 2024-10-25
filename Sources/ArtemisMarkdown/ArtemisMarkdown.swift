import SwiftUI
import MarkdownUI
import UserStore
import DesignLibrary

public struct ArtemisMarkdownView: View {

    let string: String

    public init(string: String) {
        var input = string
        RegexReplacementVisitors.visitAll(input: &input)
        self.string = input
    }

    public var body: some View {
        Markdown(string,
                 baseURL: UserSessionFactory.shared.institution?.baseURL,
                 imageBaseURL: UserSessionFactory.shared.institution?.baseURL)
            .markdownTheme(.artemis)
            .markdownImageProvider(ArtemisImageProvider())
            .markdownInlineImageProvider(ArtemisInlineImageProvider())
    }
}

private extension Theme {
    /// A theme that mimics the Artmeis style ( very close to the Github style)
    ///
    /// Style | Preview
    /// --- | ---
    /// Inline text | ![](GitHubInlines)
    /// Headings | ![](GitHubHeading)
    /// Blockquote | ![](GitHubBlockquote)
    /// Code block | ![](GitHubCodeBlock)
    /// Image | ![](GitHubImage)
    /// Task list | ![](GitHubTaskList)
    /// Bulleted list | ![](GitHubNestedBulletedList)
    /// Numbered list | ![](GitHubNumberedList)
    /// Table | ![](GitHubTable)
    static let artemis = Theme.gitHub
        .text {
            FontSize(16)
        }
        .code {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.85))
            ForegroundColor(.red)
        }
        .link {
            ForegroundColor(Color.Artemis.artemisBlue)
        }
        .blockquote { configuration in
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.border)
                    .relativeFrame(width: .em(0.2))
                configuration.label
                    .markdownTextStyle { ForegroundColor(.secondaryText) }
                    .relativePadding(.horizontal, length: .em(1))
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .codeBlock { configuration in
            ScrollView(.horizontal) {
                configuration.label
                    .relativeLineSpacing(.em(0.225))
                    .markdownTextStyle {
                        FontFamilyVariant(.monospaced)
                        FontSize(.em(0.85))
                    }
                    .padding(16)
            }
            .background(Color.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .markdownMargin(top: 0, bottom: 16)
        }
}

fileprivate extension Color {
    static let secondaryText = Color(
        light: Color(rgba: 0x6b6e_7bff), dark: Color(rgba: 0x9294_a0ff)
    )
    static let secondaryBackground = Color(
        light: Color(rgba: 0xf7f7_f9ff), dark: Color(rgba: 0x2526_2aff)
    )
    static let border = Color(
        light: Color(rgba: 0xe4e4_e8ff), dark: Color(rgba: 0x4244_4eff)
    )
}
