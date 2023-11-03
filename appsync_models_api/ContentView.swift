//
//  ContentView.swift
//  appsync_models_api
//
//  Created by Saultz, Ian on 11/3/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            TextField(
                text: $viewModel.newTodoName,
                label: { Text("Name") }
            )
            .textFieldStyle(.roundedBorder)
            
            TextField(
                text: $viewModel.newTodoDescription,
                label: { Text("Description") }
            )
            .textFieldStyle(.roundedBorder)

            Button(
                action: { viewModel.createTodo() },
                label: { Text("Add Todo") }
            )

            List {
                ForEach(viewModel.todos) { todo in
                    VStack {
                        Text(todo.name).font(.title)
                        Text(todo.description ?? "").font(.caption)
                    }
                }
            }

            Button(
                action: { viewModel.cancelSubscription() },
                label: { Text("Cancel Subscription") }
            )
        }
        .padding()
        .onAppear(perform: viewModel.subscribeToTodos)
    }
}

#Preview {
    ContentView()
}
