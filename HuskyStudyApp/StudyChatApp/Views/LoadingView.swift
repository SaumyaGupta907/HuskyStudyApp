//
//  LoadingView.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/8/24.
//

import SwiftUI

struct LoadingView: View {
    
    let message: String
    
    var body: some View {
        HStack(spacing: 10) {
            ProgressView()
                .tint(.white)
            Text(message)
        }.padding(10)
        .background(.gray)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
    }
}

#Preview {
    LoadingView(message: "Sending....")
}
