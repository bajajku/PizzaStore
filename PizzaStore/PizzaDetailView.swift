import SwiftUI

struct PizzaDetailView: View {
    let pizza: Pizza
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PizzaStoreViewModel()
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var quantity = ""
    
    var body: some View {
        VStack(spacing: 16) {
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
            
            HStack(spacing: 20) {
                TextField("Quantity", text: $quantity)
                Button("Add Pizza") {
                    
                    viewModel.addToCart(quantity: Int(quantity)!, pizzaId: pizza.id){ success in
                        if success {
                            dismiss()
                        } else {
                            let alertMessage = "Failed to create pizza"
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showingEditSheet) {
            EditPizzaView(pizza: pizza)
        }
        .alert("Delete Pizza", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deletePizzaById(id: pizza.id) { success in
                    if success {
                        dismiss()
                    }
                }
            }
        } message: {
            Text("Are you sure you want to delete this pizza?")
        }
    }
} 
