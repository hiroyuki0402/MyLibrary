//
//  ContentType.swift
//
//
//  Created by SHIRAISHI HIROYUKI on 2024/03/23.
//

import Foundation

enum ContentType: String {
    case json = "application/json"
    case formURLEncoded = "application/x-www-form-urlencoded"
    case formData = "multipart/form-data"
    case plainText = "text/plain"
    case html = "text/html"
    case xml = "application/xml"
}
