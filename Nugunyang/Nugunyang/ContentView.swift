//
//  ContentView.swift
//  Nugunyang
//
//  Created by 원주연 on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NewCameraView()
                .tabItem {
                    Label("누구냥", systemImage: "camera.fill")
                }
            
            PoCatCatalogueView()
                .tabItem {
                    Label("포냥도감", systemImage: "books.vertical.fill")
                }
        }
        .preferredColorScheme(.dark)
    }
}
