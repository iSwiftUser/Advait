//
//  AdvaitApp.swift
//  Advait
//
//  Created by Gaurav Sharma on 09/05/24.
//

import SwiftUI

@main
struct AdvaitApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
