//
//  APIclient.swift
//  zMessagesFrontEnd
//

import Foundation


struct CreateAccountRequest: Codable {
    let username: String
    let password: String
    let phone: String
}
struct SendMessageRequest: Codable {
    let Content: String
    let sender_id: Int
    let receiver_id: Int
}
struct User: Codable, Identifiable {
    let id: Int
    let username: String
    let password: String
    let phone: String
    
    enum CodingKeys: String, CodingKey { //this is the return type of messages so the "" need to match exactly what is in the return from the API
        case id = "ID"
        case username = "Username"
        case password = "Password"
        case phone = "Phone"
    }
    
}

struct Message: Codable, Hashable{
    let id: Int //not sure i need the ID
    let content: String
    let sentAt: String
    let senderID: Int
    let receiverID: Int
    
    enum CodingKeys: String, CodingKey { //this is the return type of messages so the "" need to match exactly what is in the return from the API
        case id = "ID"
        case content = "Content"
        case sentAt = "SentAt"
        case senderID = "Sender_id"
        case receiverID = "Receiver_id"
    }
}

func sendMessage(content: String, user1: Int, user2: Int, completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: Endpoints.sendMessage) else {
        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    let requestData = SendMessageRequest(Content: content, sender_id: user1, receiver_id: user2) //zz this may be the issue
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let jsonData = try JSONEncoder().encode(requestData) //turns it into raw JSON
        request.httpBody = jsonData //http body is what gets sent over network
    } catch {
        completion(.failure(error))
        return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error)) //network error
            return
        }
        if let data = data {
            if let responseString = String(data: data, encoding: .utf8) { //data is the return from the apicall
                completion(.success(responseString))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"]))) //server fails
            }
        } else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"]))) //data doesnt return for some reason
        }
    }.resume() //resume when the network responds
}

func createAccount(username: String, password: String, phone: String, completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: Endpoints.createAccount) else {
        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    
    let requestData = CreateAccountRequest(username: username, password: password, phone: phone) //uses the model we made
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let jsonData = try JSONEncoder().encode(requestData) //turns it into raw JSON
        request.httpBody = jsonData //http body is what gets sent over network
    } catch {
        completion(.failure(error))
        return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error)) //network error
            return
        }
        
        if let data = data {
            if let responseString = String(data: data, encoding: .utf8) { //data is the return from the apicall
                completion(.success(responseString))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"]))) //server fails
            }
        } else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"]))) //data doesnt return for some reason
        }
    }.resume() //resume when the network responds
}

func fetchAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
    guard let url = URL(string: Endpoints.getUsers) else {
        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))) //checks to see if the url is ok
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET" //set type
    request.addValue("application/json", forHTTPHeaderField: "Content-Type") //set body type
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
            return
        }
        do {
            let messages = try JSONDecoder().decode([User].self, from: data)
            completion(.success(messages))
        } catch {
            completion(.failure(error))
        }
    }.resume()
    
    
    
}

func fetchConversation(user1: Int, user2: Int, completion: @escaping (Result<[Message], Error>) -> Void ) {
    var components = URLComponents(string: Endpoints.getConversation)!
    components.queryItems = [URLQueryItem(name: "user1", value: "\(user1)"),
                             URLQueryItem(name: "user2", value: "\(user2)")
    ] //adds the user params
    
    guard let url = components.url else {
        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    print(url)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else { //checks to see if data is in right format
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
            return
        }
        
        do {
            let messages = try JSONDecoder().decode([Message].self, from: data)
            completion(.success(messages))
        } catch {
            completion(.failure(error))
        }
    }.resume()
    
}

func fetchAllMessages(completion: @escaping (Result<[Message], Error>) -> Void) {
    guard let url = URL(string: Endpoints.getMessages) else {
        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))) //checks to see if the url is ok
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET" //set type
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
            return
        }
        do {
            let messages = try JSONDecoder().decode([Message].self, from: data)
            completion(.success(messages))
        } catch {
            completion(.failure(error))
        }
    }.resume()
    
}
