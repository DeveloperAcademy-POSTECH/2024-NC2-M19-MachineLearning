//
//  NugunyangApp.swift
//  Nugunyang
//
//  Created by 원주연 on 6/17/24.
//

import SwiftUI
import SwiftData

@main
struct NugunyangApp: App {
    var modelContainer: ModelContainer = {
        let schema = Schema([Cat.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            return container
        } catch {
            fatalError("ModelContainer 생성 실패: \(error)")
        }
    }()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
