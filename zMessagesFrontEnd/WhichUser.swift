//
//  WhichUser.swift
//  zMessagesFrontEnd
//

import SwiftUI

struct WhichUser: View {
    @State private var totalUsers: [User] = []
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Select a User")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                if totalUsers.isEmpty {
                    ProgressView("Loading users...")
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(totalUsers) { user in
                                NavigationLink(destination: UservUser(user: user)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(user.username)
                                                .font(.headline)
                                            Text("Phone Number: \(user.phone)")
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
    WhichUser()
}
