//
//  ConversationView.swift
//  zMessagesFrontEnd
//

import SwiftUI

struct ConversationView: View {
    let user1: User
    let user2: User
    @State private var conversation: [Message] = []
    @State private var messageContent: String = ""

    
    var body: some View {
        ScrollView {
            VStack(spacing: 5){
                Text(user2.username)
                    .padding()
                    ForEach(conversation, id: \.self) { conversation in //since in the DB the id for messages is not unique use hashable
                        //how can i make it different based on the person who sent it???
                        HStack {
                            if conversation.senderID == user1.id {
                            Spacer() //push to the right
                            Text(conversation.content)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            
                        }
                            else {
                                Text(conversation.content)
                                    .padding()
                                    .background(Color.white)
                                    .foregroundColor(.blue)
                                    .cornerRadius(10)
                                Spacer() //push to the left
                            }
                        }
                    }
                Spacer() //push as far up the screen as possible
            }.onAppear {
                fetchConversation(user1: user1.id, user2: user2.id) { result in
                        switch result { //the function returns nothing
                        case .success(let convo):
                            conversation = convo
                            for message in convo {
                                print(message.content) //zz we can just use the ID's
                            }
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                        }
                }
                
            }
            
            //other Vstack for the textField
            HStack {
                TextField("zMessage", text: $messageContent)
                Button("Send") {
                    sendMessage(content: messageContent, user1: user1.id, user2: user2.id) { result in
                        switch result {
                        case .success:
                            fetchConversation(user1: user1.id, user2: user2.id) { result in
                                    switch result { //the function returns nothing
                                    case .success(let convo):
                                        conversation = convo
                                        for message in convo {
                                            print(message.content) //zz we can just use the ID's
                                        }
                                    case .failure(let error):
                                        print("Error: \(error.localizedDescription)")
                                    }
                            }
                            print("message sent")
                            messageContent = ""
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                            
                            
                        }
                    }
                }
                
            }
            
        }
        }
        
    
    
}

#Preview {
//    ConversationView()
}
