//
//  GroupListContainerView.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/6/24.
//

import SwiftUI

struct GroupListContainerView: View {
    
    @State private var isPresented: Bool = false
    @EnvironmentObject private var model: Model
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("New Group") {
                    isPresented = true
                }
            }
            
            GroupListView(groups: model.groups)
            
            Spacer()
        }
        .task {
            do {
                try await model.populateGroups()
            } catch {
                print(error)
            }
        }
        .padding()
            .sheet(isPresented: $isPresented) {
                AddNewGroupView()
            }
    }
}

#Preview {
    GroupListContainerView()
        .environmentObject(Model())
}
