//
//  appsync_models_apiApp.swift
//  appsync_models_api
//
//  Created by Saultz, Ian on 11/3/23.
//

import SwiftUI
import Amplify
import AWSAPIPlugin

@main
struct appsync_models_apiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    init() {
        do {
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("🚀 Amplify configured")
        } catch {
            print("🙀 Error configuring Amplify: \(error)")
        }
    }
}
