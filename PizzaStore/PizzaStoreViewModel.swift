//
//  PizzaStoreViewModel.swift
//  PizzaStore
//
//  Created by Kunal Bajaj on 2025-01-28.
//

//
//  PizzaStoreViewModel.swift
//  PizzaStore
//
//  Created by Kunal Bajaj on 2025-01-28.
//

import Foundation

class PizzaStoreViewModel: ObservableObject {
    
    @Published var pizzas = [Pizza]()  // Added @Published to update views dynamically
    let baseUrl = "https://silver-adventure-w64wv5w44963xq7-5148.app.github.dev"
    
    func getAllPizzas() {
        let endpoint = "/pizzas"
        guard let url = URL(string: baseUrl + endpoint) else {
            print("Invalid URL for fetching all pizzas.")
            return
        }
        
        print("Fetching all pizzas from: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching all pizzas: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received when fetching all pizzas.")
                return
            }

            // Print raw JSON data for debugging
            if let dataString = String(data: data, encoding: .utf8) {
                print("Raw JSON Data for all pizzas: \(dataString)")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode([Pizza].self, from: data)
                DispatchQueue.main.async {
                    print("Successfully fetched all pizzas: \(decodedResponse)")
                    self.pizzas = decodedResponse
                }
            } catch {
                print("Decoding error for all pizzas: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func getPizzaById(id: Int, completion: @escaping (Pizza?) -> Void) {
        let endpoint = "/pizzas/\(id)"
        guard let url = URL(string: baseUrl + endpoint) else {
            print("Invalid URL for fetching pizza with ID: \(id)")
            completion(nil)
            return
        }
        
        print("Fetching pizza with ID: \(id) from: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching pizza with ID \(id): \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received for pizza with ID \(id).")
                completion(nil)
                return
            }

            // Print raw JSON data for debugging
            if let dataString = String(data: data, encoding: .utf8) {
                print("Raw JSON Data for pizza with ID \(id): \(dataString)")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(Pizza.self, from: data)
                DispatchQueue.main.async {
                    print("Successfully fetched pizza: \(decodedResponse)")
                    completion(decodedResponse)
                }
            } catch {
                print("Decoding error for pizza with ID \(id): \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func deletePizzaById(id: Int, completion: @escaping (Bool) -> Void) {
        let endpoint = "/pizzas/\(id)"
        guard let url = URL(string: baseUrl + endpoint) else {
            print("Invalid URL for deleting pizza with ID: \(id)")
            completion(false)
            return
        }

        print("Deleting pizza with ID: \(id) at: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error deleting pizza with ID \(id): \(error.localizedDescription)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Successfully deleted pizza with ID: \(id)")
                    completion(true)
                } else {
                    print("Failed to delete pizza with ID: \(id), status code: \(httpResponse.statusCode)")
                    completion(false)
                }
            } else {
                print("Invalid response for deleting pizza with ID: \(id)")
                completion(false)
            }
        }

        task.resume()
    }
}
