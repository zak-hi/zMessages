//
//  zMessagesFrontEndApp.swift
//  zMessagesFrontEnd
//
//  Created by Zak Lalani on 7/3/25.
//

import SwiftUI
import SwiftData

@main
struct zMessagesFrontEndApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MessageView()
        }
        .modelContainer(sharedModelContainer)
    }
}
