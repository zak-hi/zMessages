//
//  MessageView.swift
//  zMessagesFrontEnd
//

import SwiftUI

struct MessageView: View {
    @State private var userName: String = ""
    @State private var pWord: String = ""
    @State private var pNumber: String = ""
    @State private var showCreateForm: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Text("zMessages")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top, 50)
                
                VStack(spacing: 16) {
                    Button("➕ Create User") {
                        showCreateForm.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    NavigationLink("👤 Select User", destination: WhichUser())
                        .buttonStyle(.bordered)
                }

                if showCreateForm {
                    VStack(spacing: 12) {
                        TextField("Username", text: $userName)
                            .textFieldStyle(.roundedBorder)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $pWord)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Phone Number", text: $pNumber)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.phonePad)
                        
                        Button("Create Account") {
                            createAccount(username: userName, password: pWord, phone: pNumber) { result in
                                switch result {
                                case .success(let response):
                                    print("✅ Account created: \(response)")
                                case .failure(let error):
                                    print("❌ Error: \(error.localizedDescription)")
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    MessageView()
}
