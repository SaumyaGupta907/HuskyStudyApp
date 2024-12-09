//
//  GroupDetailConfig.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/7/24.
//

import Foundation
import SwiftUI

struct GroupDetailConfig {
    var chatText: String = ""
    var sourceType: UIImagePickerController.SourceType?
    var selectedImage: UIImage?
    var showOptions: Bool = false
    
    mutating func clearForm() {
        chatText = ""
        selectedImage = nil
    }
    
    var isValid: Bool {
        !chatText.isEmptyOrWhiteSpace || selectedImage != nil
    }
}
