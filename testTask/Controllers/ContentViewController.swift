//
//  ContentViewController.swift
//  testTask
//
//  Created by Алина Дьяченко on 16.03.2022.
//

import Foundation
import RxSwift

class ContentViewController: ObservableObject {
    let appServerClient = AFManager()
    
    @Published var tracks: [Item] = [] {
        didSet {
            saveItems()
        }
    }
    let disposeBag = DisposeBag()
    
    @Published var offset: Int = 0
    @Published var failedDownloading = false
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(tracks) {
            UserDefaults.standard.set(encodedData, forKey: "tracks")
        }
    }

}
