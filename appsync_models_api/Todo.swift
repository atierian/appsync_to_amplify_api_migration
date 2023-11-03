//
//  Todo.swift
//  appsync_models_api
//
//  Created by Saultz, Ian on 11/3/23.
//

import Foundation

struct Todo: Identifiable, Hashable {
    let id: String
    var name: String
    let description: String?

    init(_ onCreateTodo: OnCreateTodoSubscription.Data.OnCreateTodo) {
        self.id = onCreateTodo.id
        self.name = onCreateTodo.name
        self.description = onCreateTodo.description
    }
}
