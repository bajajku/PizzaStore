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
    @State private var showingAddPizza = false

    var body: some View {
        NavigationView {
            VStack {
                // Button to fetch pizza by ID
                Button("Reload Pizzas") {
                    viewModel.getAllPizzas()
                }
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
                .navigationBarItems(trailing: Button(action: {
                    showingAddPizza = true
                }) {
                    Image(systemName: "plus")
                })
                .onAppear {
                    viewModel.getAllPizzas()
                }
                .sheet(isPresented: $showingAddPizza) {
                    AddPizzaView()
                }
                .sheet(item: $selectedPizza) { pizza in
                    PizzaDetailView(pizza: pizza)
                        .onDisappear {
                            viewModel.getAllPizzas() // Refresh the list when returning from detail view
                        }
                }
            }
        }
    }
}
