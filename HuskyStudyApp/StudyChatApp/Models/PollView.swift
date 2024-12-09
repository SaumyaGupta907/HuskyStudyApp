//
//  PollView.swift
//  StudyChatApp
//
//  Created by Sanjana Poojary on 08/12/24.
//

import SwiftUI

struct PollView: View {
    let poll: Poll
    let isFromCurrentUser: Bool
    @State private var selectedOption: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(poll.question)
                .font(.headline)
                .padding(.bottom, 5)
                .foregroundColor(isFromCurrentUser ? .white : .black)

            ForEach(poll.options, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                }) {
                    HStack {
                        Text(option)
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if selectedOption == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(isFromCurrentUser ? Color.blue : Color.gray.opacity(0.2))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}
