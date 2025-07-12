//
//  UservUser.swift
//  zMessagesFrontEnd
//

import SwiftUI

struct UservUser: View {
    let user: User // Current logged-in or selected user
    @State private var totalUsers: [User] = []

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Start a conversation with:")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)

                if totalUsers.isEmpty {
                    ProgressView("Loading users...")
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(totalUsers.filter { $0.id != user.id }) { userProfile in
                                NavigationLink(destination: ConversationView(user1: user, user2: userProfile)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(userProfile.username)
                                                .font(.headline)
                                            Text("\(userProfile.phone)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10)
                                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Logged in as \(user.username)")
            .padding(.top)
            .onAppear {
                fetchAllUsers { result in
                    switch result {
                    case .success(let userProfiles):
                        totalUsers = userProfiles
                    case .failure(let error):
                        print("Error fetching users: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

#Preview {
    UservUser(user: User(id: 1, username: "testuser", password: "12345", phone: "1234567890"))
}
