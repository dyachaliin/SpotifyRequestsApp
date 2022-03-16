//
//  TracksResult.swift
//  testTask
//
//  Created by Алина Дьяченко on 09.03.2022.
//

import Foundation

class TracksResp {
    let thread: String
    let offset: Int
    let tracks: Tracks
    
    init(thread: String, offset: Int, tracks: Tracks){
        self.thread = thread
        self.offset =  offset
        self.tracks = tracks
    }
}
// MARK: - TracksResult
struct TracksResult: Codable {
    let tracks: Tracks
}
// MARK: - Tracks
struct Tracks: Codable {
    let href: String?
    let items: [Item]?
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int

}

// MARK: - Item
struct Item: Codable, Identifiable {
    var thread: Int?
    let artists: [Artist?]?
    let id = UUID()
    let availableMarkets: [String?]?
    let discNumber, durationMS: Int?
    let explicit: Bool?
    let href: String?
    let isLocal: Bool?
    var name: String
    let popularity: Int?
    let previewURL: String?
    let trackNumber: Int?
    let type: String?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case href
        case isLocal = "is_local"
        case name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type, uri
        case thread
    }
}



// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String
}



enum ReleaseDatePrecision: String, Codable {
    case day = "day"
}

// MARK: - ExternalIDS
struct ExternalIDS: Codable {
    let isrc: String
}

enum ItemType: String, Codable {
    case track = "track"
}
