//
//  MessageView.swift
//  zMessagesFrontEnd
//

import SwiftUI

struct MessageView: View {
    @State private var userName: String = ""
    @State private var pWord: String = ""
    @State private var pNumber: String = ""


    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to zMessages")
                TextField("Enter Username: ", text: $userName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Enter Password: ", text: $pWord) //zz maybe add a way to make it priv and the eye icon thing
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Enter phoneNumber: ", text: $pNumber)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Create Account") {
                    createAccount(username: userName, password: pWord, phone: pNumber ) { result in
                        switch result {
                                case .success(let response):
                                    print("Account created: \(response)")
                                case .failure(let error):
                                    print("Error: \(error.localizedDescription)")
                                }
                    }
                }
                
                
                Button("Fetch all messages") {
                    fetchAllMessages { result in
                        switch result {
                            case .success(let messages):
                            for message in messages{
                                print(message.content)
                            }
                                print("Fetched \(messages.count) messages")
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                            }
                    }
                }
                
                NavigationLink("Fetch all users", destination: WhichUser())
                
                Button("Fetch all users") {
                    fetchAllUsers { result in
                        switch result { //the function returns nothing
                        case .success(let userProfiles):
                            for userProfile in userProfiles {
                                print(userProfile.username)
                            }
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
    MessageView()
}
