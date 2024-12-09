//
//  GroupListView.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/7/24.
//

import SwiftUI

struct GroupListView: View {
    
    let groups: [Group]
    
    var body: some View {
        List(groups) { group in
            NavigationLink {
                GroupDetailView(group: group)
            } label: {
                HStack {
                    Image(systemName: "person.2")
                    Text(group.subject)
                }
            }
        }
    }
}

#Preview {
    GroupListView(groups: [])
}
