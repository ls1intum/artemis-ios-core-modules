//
//  AttachmentVideoUnit.swift
//  
//
//  Created by Sven Andabaka on 02.05.23.
//

import Foundation
import SwiftUI

public struct AttachmentVideoUnit: BaseLectureUnit {
    public static var type: String {
        "attachment"
    }

    public var id: Int64
    public var name: String?
    public var releaseDate: Date?
    public var lecture: Lecture?

    public var visibleToStudents: Bool?
    public var completed: Bool?

    public var description: String?
    public var attachment: Attachment?
    public var slides: [Slide]?

    public var videoSource: String?

    /**
     * Returns the matching icon for the file extension of the attachment
     */
    public var image: Image {
        guard let path = attachment?.pathExtension else {
            if let videoSource {
                return Image("video-solid", bundle: .module)
            }
            return Image("file-solid", bundle: .module)
        }
        switch path {
        case "png", "jpg", "jpeg", "gif", "svg":
            return Image("file-image-solid", bundle: .module)
        case "pdf":
            return Image("file-pdf-solid", bundle: .module)
        case "zip", "tar":
            return Image("file-zipper-solid", bundle: .module)
        case "txt", "rtf", "md":
            return Image("file-lines-solid", bundle: .module)
        case "htm", "html", "json":
            return Image("file-code-solid", bundle: .module)
        case "doc", "docx", "pages", "pages-tef", "odt":
            return Image("file-word-solid", bundle: .module)
        case "csv":
            return Image("file-scv-solid", bundle: .module)
        case "xls", "xlsx", "numbers", "ods":
            return Image("file-excel-solid", bundle: .module)
        case "ppt", "pptx", "key", "odp":
            return Image("file-powerpoint-solid", bundle: .module)
        case "odg", "odc", "odi", "odf":
            return Image("file-pen-solid", bundle: .module)
        default:
            return Image("file-solid", bundle: .module)
        }
    }
}
