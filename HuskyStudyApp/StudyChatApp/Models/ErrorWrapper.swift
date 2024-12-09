//
//  ErrorWrapper.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/8/24.
//

import Foundation


struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    var guidance: String = ""
}

