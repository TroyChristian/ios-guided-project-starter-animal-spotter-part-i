//
//  APIController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class APIController {
    var bearer:Bearer? 
    
    private let baseURL = URL(string: "https://lambdaanimalspotter.vapor.cloud/api")!
    
    // create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url:signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with:request) { _, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response  as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            DispatchQueue.main.async{
            completion(nil)
            
        }
        }.resume()
    
    // create function for sign in
        func signIn(with user: User, completion: @escaping (Error?) -> ()) {
            let signInURL = baseURL.appendingPathComponent("users/login")
            
            var request = URLRequest(url:signInURL)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            
            let jsonEncoder = JSONEncoder()
            do {
                let jsonData = try jsonEncoder.encode(user)
                request.httpBody = jsonData
            } catch {
                print("Error encoding user object: \(error)")
                completion(error)
                return
            }
            URLSession.shared.dataTask(with:request) { data, response, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                if let response = response  as? HTTPURLResponse,
                    response.statusCode != 200 {
                    completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                    return
                }
                
                guard let data = data else {
                    completion(NSError())
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                   self.bearer = decoder.decode(Bearer.self, from: data)
                } catch {
                    print("Error \(error)")
                    completion(error)
                    return
                    
                    
                }
                }
                DispatchQueue.main.async{
                completion(nil)
                
            }
            }.resume()
    
    // create function for fetching all animal names
    
    // create function to fetch image
}
}
