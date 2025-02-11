import SwiftUI

struct PizzaDetailView: View {
    let pizza: Pizza
    let cartItem: CartItem? // Optional cart item for when viewing from cart
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PizzaStoreViewModel()
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var quantity: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    init(pizza: Pizza, cartItem: CartItem? = nil) {
        self.pizza = pizza
        self.cartItem = cartItem
        _quantity = State(initialValue: cartItem?.quantity.description ?? "")
    }
    
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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 100)
                
                if let cartItem = cartItem {
                    // Update quantity button for cart items
                    Button("Update Quantity") {
                        guard let newQuantity = Int(quantity) else { return }
                        let updatedCartItem = CartItem(
                            id: cartItem.id,
                            pizzaId: pizza.id,
                            quantity: newQuantity,
                            pizza: pizza
                        )
                        viewModel.updateCartItem(id: cartItem.id, updatedCartItem: updatedCartItem) { success in
                            if success {
                                alertMessage = "Cart updated successfully!"
                                showAlert = true
                            } else {
                                alertMessage = "Failed to update cart. Please try again."
                                showAlert = true
                            }
                        }
                    }
                    .disabled(quantity.isEmpty || Int(quantity) == cartItem.quantity)
                    
                    Button("Remove from Cart") {
                        showingDeleteAlert = true
                    }
                    .foregroundColor(.red)
                } else {
                    // Add to cart button for regular pizza view
                    Button("Add to Cart") {
                        guard let quantityInt = Int(quantity) else { return }
                        viewModel.addToCart(quantity: quantityInt, pizzaId: pizza.id) { success in
                            if success {
                                alertMessage = "Added to cart successfully!"
                                showAlert = true
                            } else {
                                alertMessage = "Failed to add to cart. Please try again."
                                showAlert = true
                            }
                        }
                    }
                    .disabled(quantity.isEmpty)
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .alert("Remove Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let cartItem = cartItem {
                    viewModel.deleteCartItem(id: cartItem.id) { success in
                        if success {
                            alertMessage = "Item removed from cart!"
                            showingDeleteAlert = false
                            showAlert = true
                        } else {
                            alertMessage = "Failed to remove item. Please try again."
                            showingDeleteAlert = false
                            showAlert = true
                        }
                    }
                }
            }
        } message: {
            Text("Are you sure you want to remove this item from your cart?")
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("successfully") {
                    dismiss()
                }
            }
        }
    }
} 
