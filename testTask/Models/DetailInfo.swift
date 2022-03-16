//
//  DetailInfo.swift
//  testTask
//
//  Created by Алина Дьяченко on 15.03.2022.
//

import Foundation



// MARK: - PlacesResult1
struct DetailInfo: Decodable {
    let album: Album
    let artists: [Artist]
    let discNumber, durationMS: Int
    let explicit: Bool
    let href: String
    let id: String
    let isLocal: Bool
    let name: String
    let popularity: Int
    let previewURL: String
    let trackNumber: Int
    let type, uri: String

    enum CodingKeys: String, CodingKey {
        case album, artists
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case href, id
        case isLocal = "is_local"
        case name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type, uri
    }
}

// MARK: - Album
struct Album: Decodable {
    let albumType: String
    let artists: [Artist]
    let href: String
    let id: String
    let images: [Image]
    let name, releaseDate, releaseDatePrecision: String
    let totalTracks: Int
    let type, uri: String

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}

// MARK: - Artist
struct Artist: Codable {
    let href: String
    let id, name, type, uri: String

    enum CodingKeys: String, CodingKey {
        case href, id, name, type, uri
    }
}


// MARK: - Image
struct Image: Codable {
    let height: Int
    let url: String
    let width: Int
}

