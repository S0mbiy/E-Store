//
//  PaymentView.swift
//  E-Store
//
//  Created by AccedoADM on 30/05/21.
//

import SwiftUI

struct PaymentView: View {
    @StateObject var vm: PaymentViewModel
    @Environment(\.presentationMode) var present
    
    @State private var cardnumber: String = ""
    
    var body: some View {
            VStack{
                HStack(){
                    Button(action: {present.wrappedValue.dismiss()}){
                        Image(systemName: "chevron.left")
                            .font(.system(size: 25, weight: .heavy))
                            .foregroundColor(.black)
                    }
                    Text("Payment")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    
                }
                Form{
                    Section(header: Text("Card number"), footer: Text(vm.errorCardNumber)){
                        TextField("Number", text: $vm.cardNumber)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            .keyboardType(.decimalPad)
                    }
                    Section(header: Text("Card owner"), footer: Text(vm.errorName)){
                        TextField("Name", text: $vm.ownerName)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    }
                    Section(header: Text("Expiration Date"), footer: Text(vm.errorDate)){
                        TextField("Month", text: $vm.expirationMonth)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            .keyboardType(.decimalPad)
                        TextField("YEar", text: $vm.expirationYear)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            .keyboardType(.decimalPad)
                    }
                    Section(header: Text("CVV")){
                        TextField("CVV", text: $vm.cvv)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            .keyboardType(.decimalPad)
                    }
                }
                Button(action: {
                    if(vm.validateData()){
                        vm.makeOrder()
                        vm.clearCart()
                        present.wrappedValue.dismiss()
                    }
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0)
                            .frame(height: 60)
                        Text("Pay")
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .padding()
        

    }
}

