//
// Race.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct Race: Codable, JSONEncodable, Hashable, Identifiable {
    public var id: String
    public var name: String
    public var date: String
    public var shortestTime: Double
    public var shortestDistance: Double
    public var xCoords: [Double]?
    public var yCoords: [Double]?
    public var tracks: [TrackedPath]?
    public var participants: [String]?

    public init(id: String = UUID().uuidString, name: String, date: String, shortestTime: Double, shortestDistance: Double, xCoords: [Double]? = nil, yCoords: [Double]? = nil, tracks: [TrackedPath]? = nil, participants: [String]? = nil) {
        self.id = id
        self.name = name
        self.date = date
        self.shortestTime = shortestTime
        self.shortestDistance = shortestDistance
        self.xCoords = xCoords
        self.yCoords = yCoords
        self.tracks = tracks
        self.participants = participants
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case date
        case shortestTime
        case shortestDistance
        case xCoords
        case yCoords
        case tracks
        case participants
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(date, forKey: .date)
        try container.encode(shortestTime, forKey: .shortestTime)
        try container.encode(shortestDistance, forKey: .shortestDistance)
        try container.encodeIfPresent(xCoords, forKey: .xCoords)
        try container.encodeIfPresent(yCoords, forKey: .yCoords)
        try container.encodeIfPresent(tracks, forKey: .tracks)
        try container.encodeIfPresent(participants, forKey: .participants)
    }
}
