
import Foundation

/**
 The product's information should be presented as the json encoded or
 serialized associated array in base64-encoding
 
 For the simple payment form there can be only one product at one time, so the encoding
 should looks like in following PHP example:
 ````
 base64_encode(
 json_encode(
 array(
 'amount'=>'1.99',
 'currency'=>'USD',
 'description'=>' Description of PlatonProduct', 'recurring')
 ));
 ````
 For the complex payment form there should be the list of products instead.
 Below is the PHP example of the products list encoding:
 ````
 base64_encode(
 json_encode(
 array(
 'p1' => array('amount'=> '1.99',
 'currency'=>'USD',
 'description'=> 'Description of PlatonProduct 1',
 'recurring'),
 'p2' => array('amount'=>'20.05',
 'description'=>' Description of PlatonProduct 2',
 'selected') ,
 'p3' => array('amount'=>'35.45',
 'currency'=>'EUR',
 'description'=>' Description of PlatonProduct 3')
 )));
 ````
 
 p1, p2, p3 are the identifiers of products
 
 Example illustrates the use of the properties of 'recurring' on a single product, namely the
 identifier p1. The remaining products p2, p3 do not have this property.
 The Client defines the PlatonProduct ID by himself. The main requirement is only a unique
 identifier in the list of products.
 
 The property ‘currency’ is not necessarily. By default the ‘USD’ is being used. The Client
 can specify the transaction currency by himself according to the currencies allowed and
 supported for his account.
 
 The property ‘recurring’ is not necessarily and only used if the Client’s account supports
 the recurring operations and the Client will continue to use the recurring payments for the
 certain products.
 
 The property ‘selected’ is defined to make the product already selected in the payment
 form when the Buyer is redirected to it.
 */

final class PlatonBase64Utils {
    
    static func encode(product: PlatonProductSale) -> String? {
        return encode(products: [product])
    }
    
    static func encode(products: [PlatonProductSale]?) -> String? {
        guard let unwProducrs = products, unwProducrs.count > 0 else {
            return nil
        }
        
        if unwProducrs.count == 1 {
            let params = unwProducrs[0].anyParams
            let strParams = params.platonStringValue
            let encodedParams = strParams?.base64Encoded()
            
            return encodedParams
            
        } else {
            var jsonProducts = [String: AnyParams]()
            
            for i in 0..<unwProducrs.count {
                jsonProducts["p\(i + 1)"] = unwProducrs[i].anyParams
            }
            
            let strParams = jsonProducts.platonStringValue
            let encodedParams = strParams?.base64Encoded()
            print(strParams!)
            return encodedParams
        }
        
    }
    
    static func encodeToken(products: [PlatonProductSale]?) -> String? {
        guard let unwProducrs = products, unwProducrs.count > 0 else {
            return nil
        }
        
        if unwProducrs.count == 1 {
            let params = unwProducrs[0].anyParams
            let strParams = params.platonStringValue
            let encodedParams = strParams?.base64Encoded()
            
            return encodedParams
            
        } else {
            var jsonProducts = [AnyParams]()
            
            for i in 0..<unwProducrs.count {
                jsonProducts.append(unwProducrs[i].anyParams)
            }
            
            let strParams = jsonProducts.platonStringValue
            let encodedParams = strParams?.base64Encoded()
            print(strParams!)
            return encodedParams
        }
        
    }
    
}

extension String {
    
    func base64Encoded() -> String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        return data.base64EncodedString()
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String.init(data: data, encoding: .utf8)
    }
}

extension Collection {
    var platonStringValue: String? {
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        
        return String(data: jsonData, encoding: .utf8)
    }
    
    var platonJsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
}

