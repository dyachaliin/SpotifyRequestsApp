//
//  DetailViewController.swift
//  testTask
//
//  Created by Алина Дьяченко on 16.03.2022.
//

import Foundation

class DetailViewController: ObservableObject {
    let appServerClient = AFManager()
    
    init(detailUrl: String) {
        self.detailUrl = detailUrl
    }
    @Published var detailUrl: String
    @Published var albumtype: String = ""
    @Published var artistName: String = ""
    @Published var releaseDate: String = ""
    @Published var albumName: String = ""
    @Published var imageURL: String = ""
    @Published var failedDownloading = false
    
}
