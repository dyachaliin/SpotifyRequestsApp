//
//  testTaskApp.swift
//  testTask
//
//  Created by Алина Дьяченко on 06.03.2022.
//

import SwiftUI

@main
struct Application: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ContentViewController())
        }
    }
}
