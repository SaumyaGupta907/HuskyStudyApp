//
//  ChatMessageListView.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/7/24.
//

import SwiftUI
import FirebaseAuth

struct ChatMessageListView: View {
    let chatMessages: [ChatMessage]
    private func isChatMessageFromCurrentUser(_ chatMessage: ChatMessage) -> Bool {
        print(chatMessage)
        guard let currentUser = Auth.auth().currentUser else {
            return false
        }
        return currentUser.uid == chatMessage.uid
    }
    
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(chatMessages) { chatMessage in
                    VStack {
                        if let poll = chatMessage.poll {
                            // If the message contains a poll, display the PollView
                            PollView(poll: poll, isFromCurrentUser: isChatMessageFromCurrentUser(chatMessage))
                        } else {
    
                            if isChatMessageFromCurrentUser(chatMessage) {
                                HStack {
                                    Spacer()
                                    ChatMessageView(chatMessage: chatMessage, direction: .right, color: .blue)
                                }
                            } else {
                                HStack {
                                    ChatMessageView(chatMessage: chatMessage, direction: .left, color: .gray)
                                    Spacer()
                                }
                            }
                        }
                        Spacer().frame(height: 20)
                            .id(chatMessage.id)
                    }
                    .listRowSeparator(.hidden)
                }
            }
        }
        .padding([.bottom], 60)
    }
}

#Preview {
    ChatMessageListView(chatMessages: [])
}
