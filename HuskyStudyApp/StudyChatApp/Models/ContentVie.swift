//
//  ContentView.swift
//  StudyChatApp
//
//  Created by Sanjana Poojary on 08/12/24.
//

import SwiftUI
import UserNotifications

struct ContentVie: View {
    @State private var permissionGranted = false

    private func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                permissionGranted = true
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    private func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Hello world!"
        notificationContent.subtitle = "Send a notification"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let req = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)

        UNUserNotificationCenter.current().add(req)
    }

    var body: some View {
        VStack {
            if !permissionGranted {
                Button("Request Permission") {
                    requestPermissions()
                }
            }

            if permissionGranted {
                Button("Send Notification") {
                    sendNotification()
                }
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    permissionGranted = true
                }
            }
        }
        .padding()
    }
}
