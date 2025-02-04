//
//  PizzaStoreView.swift
//  PizzaStore
//
//  Created by Kunal Bajaj on 2025-01-28.
//

import SwiftUI

struct PizzaListView: View {
    @StateObject private var viewModel = PizzaStoreViewModel()
    @State private var selectedPizza: Pizza?
    @State private var pizzaIdToFetch: String = "" // To store the ID for fetching pizza by ID

    var body: some View {
        NavigationView {
            VStack {
                // Button to fetch pizza by ID
                HStack {
                    TextField("Enter Pizza ID", text: $pizzaIdToFetch)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.numberPad)

                    Button("Get Pizza by ID") {
                        if let id = Int(pizzaIdToFetch) {
                            viewModel.getPizzaById(id: id) { fetchedPizza in
                                selectedPizza = fetchedPizza
                            }
                        }
                    }
                    .padding()
                    .disabled(pizzaIdToFetch.isEmpty) // Disable the button if the ID is empty
                }

                // List of all pizzas
                List(viewModel.pizzas, id: \.id) { pizza in
                    Button(action: {
                        viewModel.getPizzaById(id: pizza.id) { fetchedPizza in
                            selectedPizza = fetchedPizza
                        }
                    }) {
                        HStack {
                            // Display pizza image
                            AsyncImage(url: URL(string: pizza.image)) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            } placeholder: {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(width: 50, height: 50)
                            }
                            
                            // Display pizza name
                            Text(pizza.name)
                                .font(.headline)
                        }
                    }
                }
                .navigationTitle("Pizza Menu 🍕")
                .onAppear {
                    viewModel.getAllPizzas()
                }
                .sheet(item: $selectedPizza) { pizza in
                    PizzaDetailView(pizza: pizza)
                }
            }
        }
    }
}

struct PizzaDetailView: View {
    let pizza: Pizza

    var body: some View {
        VStack(spacing: 16) {
            // Pizza image from URL
            AsyncImage(url: URL(string: pizza.image)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            } placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 250, height: 250)
            }

            Text(pizza.name)
                .font(.largeTitle)
                .bold()

            Text("ID: \(pizza.id)")
                .font(.title)

            Text("Description: \(pizza.name)") // Replace with more detailed description if available
                .font(.body)

            Spacer()
        }
        .padding()
    }
}
