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
        VStack {
            // Header
            HStack {
                Text("Chat with \(user2.username)")
                    .font(.headline)
                    .padding()
                Spacer()
            }

            // Messages
            ScrollView {
                ScrollViewReader { scrollViewProxy in //used to anchor so when a text is sent it moves
                    LazyVStack(spacing: 8) {
                        ForEach(conversation, id: \.self) { message in
                            HStack {
                                if message.senderID == user1.id {
                                    Spacer()
                                    Text(message.content)
                                        .padding(10)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                        .frame(maxWidth: 250, alignment: .trailing)
                                } else {
                                    Text(message.content)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.2))
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                        .frame(maxWidth: 250, alignment: .leading)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                        // Invisible anchor for auto-scrolling
                        Color.clear //do it here bc then we are at the bottom of the messages
                            .frame(height: 1)
                            .id("bottom")
                    }
                    .onChange(of: conversation.count) { //when the convo changes we scroll to that indicated bottom
                        withAnimation {
                            scrollViewProxy.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                }
            } //end the scroll view and then add the Hstack after so that it always appears on screen
            
            HStack {
                TextField("Type a zMessage...", text: $messageContent)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                Button(action: sendCurrentMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .onAppear {
            loadConversation()
        }
    }

    private func loadConversation() {
        fetchConversation(user1: user1.id, user2: user2.id) { result in
            switch result {
            case .success(let convo):
                conversation = convo
            case .failure(let error):
                print("Error loading conversation: \(error.localizedDescription)")
            }
        }
    }

    private func sendCurrentMessage() {
        guard !messageContent.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        sendMessage(content: messageContent, user1: user1.id, user2: user2.id) { result in
            switch result {
            case .success:
                loadConversation()
                messageContent = ""
            case .failure(let error):
                print("Send failed: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ConversationView(
        user1: User(id: 1, username: "zak", password: "test", phone: "1234567890"),
        user2: User(id: 2, username: "hebe", password: "test", phone: "9876543210")
    )
}
