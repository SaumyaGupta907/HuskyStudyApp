//
//  AppState.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/6/24.
//

import Foundation

enum LoadingState: Hashable, Identifiable {
    case idle
    case loading(String)
    
    var id: Self {
        return self 
    }
    
}

enum Route: Hashable {
    case main
    case login
    case signUp
}

class AppState: ObservableObject {
    
    @Published var loadingState: LoadingState = .idle 
    @Published var routes: [Route] = []
    @Published var errorWrapper: ErrorWrapper? 
}
