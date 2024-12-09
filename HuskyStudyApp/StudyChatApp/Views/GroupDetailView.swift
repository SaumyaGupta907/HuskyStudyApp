//
//  GroupDetailView.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/7/24.
//

import SwiftUI
import FirebaseAuth
import UserNotifications
import FirebaseStorage

struct GroupDetailView: View {
    
    
    let group: Group
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var appState: AppState
    @State private var groupDetailConfig = GroupDetailConfig()
    @FocusState private var isChatTextFieldFocused: Bool
    
    private func sendMessage() async throws {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        var chatMessage = ChatMessage(text: groupDetailConfig.chatText, uid: currentUser.uid, displayName: currentUser.displayName ?? "Guest", profilePhotoURL: currentUser.photoURL == nil ? "": currentUser.photoURL!.absoluteString)
        
        if let selectedImage = groupDetailConfig.selectedImage {
            // resize the image to fit in
            guard let resizedImage = selectedImage.resize(to: CGSize(width: 600, height: 600)),
                  let imageData = resizedImage.pngData()
            else {return}
            
            let url = try await Storage.storage().uploadData(for: UUID().uuidString, data: imageData, bucket: .attachments)
            chatMessage.attachmentPhotoURL = url.absoluteString
            
        }
        
        try await model.saveChatMessageToGroup(chatMessage: chatMessage, group: group)
        sendTestNotification()
    }
    
    private func sendNotification(title: String, body: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }

    private func sendTestNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Study App Notification"
        notificationContent.body = "New messege received."
        notificationContent.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            } else {
                print("Test notification sent successfully!")
            }
        }
    }

    private func clearFields() {
        groupDetailConfig.clearForm()
        appState.loadingState = .idle
            }
    
    private func createPoll(question: String, options: [String]) {
   
        guard let currentUser = Auth.auth().currentUser else { return }
        let poll = Poll(question: question, options: options)
        let pollMessage = ChatMessage(
            text: "Poll: \(question)",
            uid: currentUser.uid,
            displayName: currentUser.displayName ?? "Guest",
            profilePhotoURL: currentUser.photoURL?.absoluteString ?? "",
            poll: poll
        )

        Task {
            do {
                try await model.saveChatMessageToGroup(chatMessage: pollMessage, group: group)
                sendTestNotification()
                print("Poll sent successfully!")
            } catch {
                print("Error sending poll: \(error.localizedDescription)")
            }
        }
    }

    var body: some View {
        VStack {
            
            ScrollViewReader { proxy in
                ChatMessageListView(chatMessages: model.chatMessages)
                    .onChange(of: model.chatMessages) { value in
                        if !model.chatMessages.isEmpty {
                            let lastChatMessage = model.chatMessages[model.chatMessages.endIndex - 1]
                            withAnimation {
                                proxy.scrollTo(lastChatMessage.id, anchor: .bottom)
                            }
                        }
                    }
            }
            
            Spacer()
            
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .confirmationDialog("Options", isPresented: $groupDetailConfig.showOptions, actions: {
            Button("Camera"){
                groupDetailConfig.sourceType = .camera
            }
            Button("Photo Library"){
                groupDetailConfig.sourceType = .photoLibrary
            }
        })
        .sheet(item: $groupDetailConfig.sourceType, content: { sourceType in
            ImagePicker(image: $groupDetailConfig.selectedImage, sourceType: sourceType)
            
        })
        
        .overlay(alignment: .center, content: {
            if let selectedImage = groupDetailConfig.selectedImage {
                PreviewImageView(selectedImage: selectedImage) {
                    withAnimation {
                        groupDetailConfig.selectedImage = nil 
                    }
                }
            }
        })
        .overlay(alignment: .bottom, content: {
            ChatMessageInputView(
                groupDetailConfig: $groupDetailConfig,
                isChatTextFieldFocused: _isChatTextFieldFocused,
                onSendMessage: {
                    // Send message
                    Task {
                        do {
                            appState.loadingState = .loading("Sending...")
                            try await sendMessage()
                            clearFields()
                        } catch {
                            print(error.localizedDescription)
                            clearFields()
                        }
                    }
                },
                onCreatePoll: { question, options in
                    // Handle poll creation logic here
                    createPoll(question: question, options: options)
                }
            )
            .padding()
        })

            .onDisappear {
                model.detachFirebaseListener()
            }
            .onAppear {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Notification permission granted")
                    } else if let error = error {
                        print("Error requesting notification permission: \(error.localizedDescription)")
                    }
                }
                model.listenForChatMessage(in: group)
            }
    }
}

#Preview {
    GroupDetailView(group: Group(subject: "Algorithms"))
        .environmentObject(Model())
        .environmentObject(AppState())
}
