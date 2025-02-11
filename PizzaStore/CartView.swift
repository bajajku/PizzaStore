import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = PizzaStoreViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.cartItems.isEmpty {
                    Text("Your cart is empty!")
                        .font(.headline)
                        .padding()
                } else {
                    List(viewModel.cartItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.pizza?.name ?? "Unknown Pizza")
                                    .font(.headline)
                                Text("Quantity: \(item.quantity)")
                                    .font(.subheadline)
                            }
                            Spacer()
                            NavigationLink(destination: PizzaDetailView(pizza: item.pizza!, cartItem: item)) {
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchCartItems { cartItems in
                    if let cartItems = cartItems {
                        print("Cart items fetched successfully: \(cartItems)")
                        viewModel.cartItems = cartItems // Important to trigger UI update
                    } else {
                        print("Failed to fetch cart items")
                    }
                }
            }
            .navigationTitle("Cart")
            .toolbar {
                EditButton()
            }
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
