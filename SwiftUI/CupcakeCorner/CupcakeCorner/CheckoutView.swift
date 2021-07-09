//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Shae Willes on 6/3/21.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var orderCompletionTitle = ""
    @State private var orderCompletionMessage = ""
    @State private var showingOrderCompletion = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingOrderCompletion) {
            Alert(title: Text(orderCompletionTitle), message: Text(orderCompletionMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else {
            self.orderCompletionTitle = "Failed to place order!"
            self.orderCompletionMessage = "Failed to encode order"
            self.showingOrderCompletion = true
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.orderCompletionTitle = "Failed to place order!"
                self.orderCompletionMessage = "No data in response: \(error?.localizedDescription ?? "Unknown error.")"
                self.showingOrderCompletion = true
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.orderCompletionTitle = "Your order has been placed!"
                self.orderCompletionMessage = "Your order for \(decodedOrder.quantity) \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way."
                self.showingOrderCompletion = true
            } else {
                self.orderCompletionTitle = "Your order may not have been placed correctly!"
                self.orderCompletionMessage = "Invalid response from server."
                self.showingOrderCompletion = true
            }
            
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
