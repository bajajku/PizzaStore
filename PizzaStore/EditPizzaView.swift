import SwiftUI

struct EditPizzaView: View {
    let pizza: Pizza
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PizzaStoreViewModel()
    
    @State private var name: String
    @State private var image: String
    
    init(pizza: Pizza) {
        self.pizza = pizza
        _name = State(initialValue: pizza.name)
        _image = State(initialValue: pizza.image)
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Pizza Name", text: $name)
                TextField("Image URL", text: $image)
                
                Button("Save Changes") {
                    let updatedPizza = Pizza(id: pizza.id, name: name, image: image)
                    viewModel.updatePizza(id: pizza.id, updatedPizza: updatedPizza) { success in
                        if success {
                            dismiss()
                        }
                    }
                }
                .disabled(name.isEmpty || image.isEmpty)
            }
            .navigationTitle("Edit Pizza")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
} 