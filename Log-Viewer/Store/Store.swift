/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/


import StoreKit

protocol StoreDelegate{
    func storeChanged()
}

class Store {
    
    static var productIdentifiers = ["logviewerCoffeeTip", "logviewerLargeCoffeeTip", "logviewerLunchTip", "logviewerDinnerTip"]
    
    static var shared = Store()
    
    var productInfos = Array<ProductInfo>()
    var loaded = false
    
    var purchasedProduct: ProductInfo? = nil
    
    var delegate: StoreDelegate? = nil
    
    var productDescriptions: Array<String>{
        var values = Array<String>()
        for productInfo in productInfos{
            values.append("\(productInfo.product.displayName) (\(productInfo.product.displayPrice))")
        }
        return values
    }
    
    func load() async{
        do{
            var products = try await Product.products(for: Store.productIdentifiers)
            products = products.sorted{
                $0.price < $1.price
            }
            for product in products{
                let productInfo = ProductInfo(product: product)
                productInfo.delegate = self
                self.productInfos.append(productInfo)
                await productInfo.verify()
            }
            print("product count is \(products.count)")
        }
        catch (let err){
            print(err)
            return
        }
        loaded = true
        startObservingTransactions()
    }
    
    func startObservingTransactions() {
        Task{
            for await result in Transaction.updates {
                print("Transaction update")
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    print("transaction verified")
                }
            }
        }
    }
    
}

extension Store: ProductInfoDelegate{
    
    func productPurchased(productInfo: ProductInfo) {
        purchasedProduct = productInfo
        delegate?.storeChanged()
    }
    
}

protocol ProductInfoDelegate{
    func productPurchased(productInfo: ProductInfo)
}

class ProductInfo{
    
    var product: Product
    var purchased: Bool = false
    var transactionID = UUID()
    
    var delegate: ProductInfoDelegate? = nil
    
    init(product: Product){
        self.product = product
    }
    
    func verify() async{
        do{
            guard let verificationResult = await product.currentEntitlement else {
                purchased = false
                print("\(product.displayName) not purchased")
                return
            }
            switch verificationResult {
            case .verified(let transaction):
                purchased = transaction.productID == product.id
                print("\(product.displayName) is purchased: \(purchased)")
                delegate?.productPurchased(productInfo: self)
            case .unverified(_, _):
                print("\(product.displayName) not verified")
            }
        }
    }
    
    func purchase(){
        let accountToken = UUID()
        print(product.price)
        Task{
            let tokenOption = Product.PurchaseOption.appAccountToken(accountToken)
            let quantityOption = Product.PurchaseOption.quantity(1)
            do{
                let result = try await product.purchase(options: [tokenOption, quantityOption])
                switch result {
                case let .success(.verified(transaction)):
                    if transaction.appAccountToken == accountToken{
                        print("purchase successful")
                        await transaction.finish()
                        purchased = true
                        delegate?.productPurchased(productInfo: self)
                    }
                    else{
                        print("bad token")
                    }
                    break
                case let .success(.unverified(_, error)):
                    print("not verified")
                    print(error)
                    break
                case .pending:
                    print("pending")
                    break
                case .userCancelled:
                    print("cancelled")
                    break
                @unknown default:
                    break
                }
            }
            catch(let err){
                print(err)
            }
        }
    }
    
}
