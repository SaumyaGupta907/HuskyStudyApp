//
//  Poll.swift
//  StudyChatApp
//
//  Created by Sanjana Poojary on 08/12/24.
//

import Foundation

struct Poll: Codable, Identifiable, Equatable {
    let id: String = UUID().uuidString
    let question: String
    let options: [String]
}
