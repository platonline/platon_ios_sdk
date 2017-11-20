import Foundation

/// Request model that is used to store payer data
public struct PlatonPayer: PlatonParametersProtocol {
    
    /// Customer’s first name
    /// - Requires: String up to 32 characters
    public var firstName: String
    
    /// Customer’s surname
    /// - Requires: String up to 32 characters
    public var lastName: String
    
    /// Customer’s address
    /// - Requires: String up to 255 characters
    public var address: String
    
    /// Customer’s country
    /// - Requires: country 2-letter code (ISO 3166-1 alpha-2)
    public var countryCode: String
    
    /// Customer’s state
    /// - Requires: 2-letter code (or {@link State#NA} for countries without states)
    public var state: String
    
    /// Customer’s city
    /// - Requires: String up to 32 characters
    public var city: String
    
    /// ZIP-code of the Customer
    /// - Requires: String up to 32 characters
    public var zip: String
    
    /// Customer’s email
    /// - Requires: String up to 256 characters
    public var email: String
    
    /// Customer’s phone
    /// - Requires: String up to 32 characters
    public var phone: String
    
    /// IP-address of the Customer
    /// - Requires: Format XXX.XXX.XXX.XXX
    /// - Requires: min 1.0.0.0, max = 123.123.123.123
    public var ipAddress: String
    
    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.payerFirstName: firstName,
            PlatonMethodProperty.payerLastName: lastName,
            PlatonMethodProperty.payerAddress: address,
            PlatonMethodProperty.payerCountry: countryCode,
            PlatonMethodProperty.payerState: state,
            PlatonMethodProperty.payerCity: city,
            PlatonMethodProperty.payerZip: zip,
            PlatonMethodProperty.payerEmail: email,
            PlatonMethodProperty.payerPhone: phone,
            PlatonMethodProperty.payerIp: ipAddress,
        ]
    }
    
    public init(firstName: String, lastName: String, address: String, countryCode: String, state: String, city: String, zip: String, email: String, phone: String, ipAddress: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.countryCode = countryCode
        self.state = state
        self.city = city
        self.zip = zip
        self.email = email
        self.phone = phone
        self.ipAddress = ipAddress
    }

}

/// Request model that is used to store payer data
public struct PlatonPayerWebSale: PlatonParametersProtocol {
    
    /// Customer’s first name
    /// - Requires: String up to 32 characters
    public var firstName: String?
    
    /// Customer’s surname
    /// - Requires: String up to 32 characters
    public var lastName: String?
    
    /// Customer’s address
    /// - Requires: String up to 255 characters
    public var address: String?
    
    /// Customer’s country
    /// - Requires: country 2-letter code (ISO 3166-1 alpha-2)
    public var countryCode: String?
    
    /// Customer’s state
    /// - Requires: 2-letter code (or {@link State#NA} for countries without states)
    public var state: String?
    
    /// Customer’s city
    /// - Requires: String up to 32 characters
    public var city: String?
    
    /// ZIP-code of the Customer
    /// - Requires: String up to 32 characters
    public var zip: String?
    
    /// Customer’s email
    /// - Requires: String up to 256 characters
    public var email: String?
    
    /// Customer’s phone
    /// - Requires: String up to 32 characters
    public var phone: String?
    
    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.firstName: firstName,
            PlatonMethodProperty.lastName: lastName,
            PlatonMethodProperty.address: address,
            PlatonMethodProperty.country: countryCode,
            PlatonMethodProperty.state: state,
            PlatonMethodProperty.city: city,
            PlatonMethodProperty.zip: zip,
            PlatonMethodProperty.email: email,
            PlatonMethodProperty.phone: phone,
        ]
    }
    
    public init(firstName: String? = nil, lastName: String? = nil, address: String? = nil, countryCode: String? = nil, state: String? = nil, city: String? = nil, zip: String? = nil, email: String? = nil, phone: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.countryCode = countryCode
        self.state = state
        self.city = city
        self.zip = zip
        self.email = email
        self.phone = phone
    }
}
