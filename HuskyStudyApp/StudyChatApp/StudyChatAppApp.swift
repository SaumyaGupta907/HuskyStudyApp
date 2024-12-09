//
//  StudyChatAppApp.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/6/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import UserNotifications



class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        
//        return true
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          FirebaseApp.configure()

          UNUserNotificationCenter.current().delegate = self
          UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
              if granted {
                  DispatchQueue.main.async {
                      application.registerForRemoteNotifications()
                  }
              } else {
                  print("Notification permission denied: \(String(describing: error))")
              }
          }

          return true
      }
    

}

@main
struct StudyChatAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var appState = AppState()
    @StateObject private var model = Model()
    
    var body: some Scene {
        WindowGroup {
            
            NavigationStack(path: $appState.routes) {
                
                ZStack {
                    if Auth.auth().currentUser != nil {
                        //SignUpView()
                        MainView()
                    } else{
                        LoginView()
                    }
                }.navigationDestination(for: Route.self) { route in
                    switch route {
                    case .main:
                        MainView()
                    case .login:
                        LoginView()
                    case .signUp:
                        SignUpView()
                    }
                }
            }
            .overlay(alignment: .top, content: {
                switch appState.loadingState {
                case .idle:
                    EmptyView()
                case .loading(let message):
                    LoadingView(message: message)
                }
            })
            
            .sheet(item: $appState.errorWrapper, content: { errorWrapper in
                ErrorView(errorWrapper: errorWrapper)
            })
            .environmentObject(appState)
            .environmentObject(model)
        }
    }
}
