//
//  ContentViewModel.swift
//  appsync_models_api
//
//  Created by Saultz, Ian on 11/3/23.
//

import Foundation
import Amplify

@MainActor
class ContentViewModel: ObservableObject {
    @Published var newTodoName: String = ""
    @Published var newTodoDescription: String = ""

    @Published var todos: [Todo] = []

    func createTodo() {
        let input = CreateTodoInput(
            name: newTodoName,
            description: newTodoDescription
        )

        let request = GraphQLRequest(
            document: CreateTodoMutation.operationString,
            variables: CreateTodoMutation(
                input: input
            ).variables?.jsonObject,
            responseType: CreateTodoMutation.Data.self
        )

        Task {
            do {
                let result = try await Amplify.API.mutate(request: request).get()
                print("Created Todo: \(result.createTodo as Any)")
                newTodoName = ""
                newTodoDescription = ""
            } catch let error as APIError {
                print("Failed to create todo: \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }

    var subscription: AmplifyAsyncThrowingSequence<
        GraphQLSubscriptionEvent<OnCreateTodoSubscription.Data>
    >!

    func subscribeToTodos() {
        let request = GraphQLRequest(
            document: OnCreateTodoSubscription.operationString,
            responseType: OnCreateTodoSubscription.Data.self
        )

        subscription = Amplify.API.subscribe(request: request)

        Task {
            do {
                for try await subscriptionEvent in subscription {
                    switch subscriptionEvent {
                    case .connection(let subscriptionConnectionState):
                        print("Subscription connection state is \(subscriptionConnectionState)")
                    case .data(let result):
                        switch result {
                        case .success(let selection):
                            print("Received todo from subscription: \(selection)")

                            guard let todo = selection.onCreateTodo else { return }
                            todos.removeAll(where: { $0.id == todo.id })
                            todos.append(.init(todo))
                        case .failure(let error):
                            print("Received failure event: \(error)")
                        }
                    }
                }
            } catch {
                print("Subscription has terminated with \(error)")
            }
        }
    }

    func cancelSubscription() {
        subscription.cancel()
    }
}
