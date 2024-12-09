//
//  String+Extensions.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/6/24.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
