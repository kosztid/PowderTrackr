//
// Message.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct Message: Codable, JSONEncodable, Hashable {
    public var id: String
    public var sender: String
    public var date: String
    public var text: String
    public var isPhoto: Bool
    public var isSeen: Bool

    public init(id: String, sender: String, date: String, text: String, isPhoto: Bool, isSeen: Bool) {
        self.id = id
        self.sender = sender
        self.date = date
        self.text = text
        self.isPhoto = isPhoto
        self.isSeen = isSeen
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case sender
        case date
        case text
        case isPhoto
        case isSeen
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(sender, forKey: .sender)
        try container.encode(date, forKey: .date)
        try container.encode(text, forKey: .text)
        try container.encode(isPhoto, forKey: .isPhoto)
        try container.encode(isSeen, forKey: .isSeen)
    }
}
