//
//  ChatMessage.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/7/24.
//

import Foundation
import FirebaseFirestore

struct ChatMessage: Codable, Identifiable, Equatable {
    var documentId: String?
    let text: String
    let uid: String
    var dateCreated = Date()
    let displayName: String
    var profilePhotoURL: String = ""
    var attachmentPhotoURL: String = ""
    var poll: Poll?
    
    var id: String {
        documentId ?? UUID().uuidString
    }
    
    var displayAttachmentPhotoURL: URL? {
        attachmentPhotoURL.isEmpty ? nil: URL(string: attachmentPhotoURL)
    }
    
    var displayProfilePhotoURL: URL? {
        profilePhotoURL.isEmpty ? nil: URL(string: profilePhotoURL)
    }
    
}

extension ChatMessage {
    func toDictionary() -> [String: Any]
    {
    
    var dict: [String: Any] = [
             "text": text,
             "uid": uid,
             "dateCreated": dateCreated,
             "displayName": displayName,
             "profilePhotoURL": profilePhotoURL,
             "attachmentPhotoURL": attachmentPhotoURL
         ]
         
         if let poll = poll {
             dict["poll"] = [
                 "question": poll.question,
                 "options": poll.options
             ]
         }
         
         return dict
     }
    
    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> ChatMessage? {
        let dictionary = snapshot.data()
        guard let text = dictionary["text"] as? String,
              let uid = dictionary["uid"] as? String,
              let dateCreated = (dictionary["dateCreated"] as? Timestamp)?.dateValue(),
              let displayName = dictionary["displayName"] as? String,
              let profilePhotoURL = dictionary["profilePhotoURL"] as? String,
              let attachmentPhotoURL = dictionary["attachmentPhotoURL"] as? String
                
        
        else {
            return nil
        }
        var poll: Poll? = nil
          if let pollData = dictionary["poll"] as? [String: Any] {
              if let question = pollData["question"] as? String,
                 let options = pollData["options"] as? [String] {
                  poll = Poll(question: question, options: options)
              }
          }

          return ChatMessage(documentId: snapshot.documentID, text: text, uid: uid, dateCreated: dateCreated, displayName: displayName, profilePhotoURL: profilePhotoURL, attachmentPhotoURL: attachmentPhotoURL, poll: poll)
    }
    
}
