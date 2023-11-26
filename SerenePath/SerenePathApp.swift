//
//  SerenePathApp.swift
//  SerenePath
//
//  Created by Kushal Pagolu on 4/6/23.
//

import SwiftUI

@main
struct SerenePathApp: App {
    let persistenceController = PersistenceController.shared
    @EnvironmentObject var viewModel: ViewModel
    @State private var showJokesView = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(ViewModel())
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { _ in
                            withAnimation {
                                showJokesView = false
                            }
                        }
                    }
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                if showJokesView {
                    JokesView(closeAction: {
                        showJokesView = false
                    })
                    .transition(.opacity)
                    .environmentObject(ViewModel())
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
        }
    }
}

