//
//  Image+Extensions.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/7/24.
//

import Foundation
import SwiftUI


extension Image {
    
    func rounded(width: CGFloat = 100, height: CGFloat = 100) -> some View {
        return self.resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}
