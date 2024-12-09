//
//  ChatMessageInputView.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/7/24.
//


import SwiftUI

struct ChatMessageInputView: View {
    
    @Binding var groupDetailConfig: GroupDetailConfig
    @FocusState var isChatTextFieldFocused: Bool
    var onSendMessage: () -> Void
    var onCreatePoll: (String, [String]) -> Void
    
    @State private var showingPollCreation = false
    @State private var pollQuestion = ""
    @State private var pollOption1 = ""
    @State private var pollOption2 = ""

    var body: some View {
        HStack {
            Button {
                groupDetailConfig.showOptions = true
            } label: {
                Image(systemName: "plus")
                    .font(.title)
            }
            
            Button {
                showingPollCreation = true
            } label: {
                Image(systemName: "chart.bar.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            
            TextField("Enter text here", text: $groupDetailConfig.chatText)
                .textFieldStyle(.roundedBorder)
                .focused($isChatTextFieldFocused)
            
            Button {
                if groupDetailConfig.isValid {
                    ContentVie()
                    onSendMessage()
                }
            } label: {
                Image(systemName: "paperplane.circle.fill")
                    .font(.largeTitle)
                    .rotationEffect(Angle(degrees: 44))
            }
            .disabled(!groupDetailConfig.isValid)
        }
        .padding()
        .sheet(isPresented: $showingPollCreation) {
            createPollView
        }
    }

    var createPollView: some View {
        NavigationView {
            Form {
                Section(header: Text("Poll Question")) {
                    TextField("Enter poll question", text: $pollQuestion)
                }
                Section(header: Text("Poll Options")) {
                    TextField("Option 1", text: $pollOption1)
                    TextField("Option 2", text: $pollOption2)
                }
            }
            .navigationTitle("Create Poll")
            .navigationBarItems(
                leading: Button("Cancel") {
                    showingPollCreation = false
                },
                trailing: Button("Create") {
                    if !pollQuestion.isEmpty && !pollOption1.isEmpty && !pollOption2.isEmpty {
                        onCreatePoll(pollQuestion, [pollOption1, pollOption2])
                        clearPollFields()
                        showingPollCreation = false
                    }
                }
                .disabled(pollQuestion.isEmpty || pollOption1.isEmpty || pollOption2.isEmpty)
            )
        }
    }

    private func clearPollFields() {
        pollQuestion = ""
        pollOption1 = ""
        pollOption2 = ""
    }
}

#Preview {
    ChatMessageInputView(
        groupDetailConfig: .constant(GroupDetailConfig(chatText: "Hello World")),
        onSendMessage: {},
        onCreatePoll: { question, options in
            print("Poll Question: \(question)")
            print("Options: \(options)")
        }
    )
}
