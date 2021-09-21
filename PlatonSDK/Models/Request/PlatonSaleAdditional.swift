
import Foundation

protocol PlatoExtAdditionalProtocol {
    var ext1: String? { get set }
    var ext2: String? { get set }
    var ext3: String? { get set }
    var ext4: String? { get set }
    var ext5: String? { get set }
    var ext6: String? { get set }
    var ext7: String? { get set }
    var ext8: String? { get set }
    var ext9: String? { get set }
    var ext10: String? { get set }
}

protocol PlatonWebAdditionalProtocol {
    var ext1: String? { get set }
    var ext2: String? { get set }
    var ext3: String? { get set }
    var ext4: String? { get set }
}

protocol PlatonWebTokenAdditionalProtocol {
    var cardToken: String? { get set }
    var ext2: String? { get set }
    var ext3: String? { get set }
    var ext4: String? { get set }
}

protocol PlatonWebVerificationProtocol {
    var bankId: String? { get set }
    var payerId: String? { get set }
}

/// Sale options for Single Message System (SMS) or Dual Message System (DMS) (*PlatonMethodAction.sale*)
public struct PlatonSaleAdditional: PlatonParametersProtocol {
    
    /// Asynchronous (*PlatonOption.yes*) or synchronous (default) mode (*PlatonOption.no)
    public var async: PlatonOption?
    
    /// Payment channel (Sub-account)
    ///
    /// If you want to send a payment for the specific sub-account (channel), you need to use channel ID that specified in your Payment Platform account settings
    public var channelId: String?
    
    /// Initialization of the transaction with possible following recurring
    ///
    /// See *PlatonOption* for possible values. Default *PlatonOption.no*
    public var recurringInit: PlatonOption?
    public let termsUrl3ds = PlatonSDK.shared.credentials?.termUrl3Ds
    
    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.async: async?.rawValue,
            PlatonMethodProperty.channelId: channelId,
            PlatonMethodProperty.reccuringInit: recurringInit?.rawValue,
            PlatonMethodProperty.termsUrl3ds: termsUrl3ds
            ]
    }
    
    public init(async: PlatonOption? = nil, channelId: String? = nil, recurringInit: PlatonOption? = nil) {
        self.async = async
        self.channelId = channelId
        self.recurringInit = recurringInit
    }
    
}

/// This class extends *PlatonSaleOptions* and provide some new fields which handle representation of requests from *PlatonSaleAdapter*
public struct PlatonExtAdditional: PlatonParametersProtocol, PlatoExtAdditionalProtocol {
    
    /// Client Parameter 1
    var ext1: String?

    /// Client Parameter 2
    var ext2: String?
    
    /// Client Parameter 3
    var ext3: String?
    
    /// Client Parameter 4
    var ext4: String?
    
    /// Client Parameter 5
    var ext5: String?
    
    /// Client Parameter 6
    var ext6: String?
    
    /// Client Parameter 7
    var ext7: String?
    
    /// Client Parameter 8
    var ext8: String?
    
    /// Client Parameter 9
    var ext9: String?
    
    /// Client Parameter 10
    var ext10: String?

    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.ext1: ext1,
            PlatonMethodProperty.ext2: ext2,
            PlatonMethodProperty.ext3: ext3,
            PlatonMethodProperty.ext4: ext4,
            PlatonMethodProperty.ext5: ext5,
            PlatonMethodProperty.ext6: ext6,
            PlatonMethodProperty.ext7: ext7,
            PlatonMethodProperty.ext8: ext8,
            PlatonMethodProperty.ext9: ext9,
            PlatonMethodProperty.ext10: ext10,
        ]
    }
    
    public init(ext1: String? = nil, ext2: String?, ext3: String?, ext4: String?,
                ext5: String? = nil, ext6: String? = nil, ext7: String? = nil, ext8: String? = nil, ext9: String? = nil, ext10: String? = nil) {
        self.ext1 = ext1
        self.ext2 = ext2
        self.ext3 = ext3
        self.ext4 = ext4
        self.ext5 = ext5
        self.ext6 = ext6
        self.ext7 = ext7
        self.ext8 = ext8
        self.ext9 = ext9
        self.ext10 = ext10
    }
}
/// Web options provides fields by which developer can customize displayed web form in web SALE, RECURRING_SALE request
///
/// See *PlatonWebSaleAdapter* and *PlatonWebRecurringAdapter* for its usages
public struct PlatonWebAdditional: PlatonParametersProtocol, PlatonWebAdditionalProtocol {
    
    /// Client Parameter 1
    var ext1: String?
    
    /// Client Parameter 2
    var ext2: String?
    
    /// Client Parameter 3
    var ext3: String?
    
    /// Client Parameter 4
    var ext4: String?
    
    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.ext1: ext1,
            PlatonMethodProperty.ext2: ext2,
            PlatonMethodProperty.ext3: ext3,
            PlatonMethodProperty.ext4: ext4,
        ]
    }
    
    public init(ext1: String?, ext2: String?, ext3: String?, ext4: String?) {
        self.ext1 = ext1
        self.ext2 = ext2
        self.ext3 = ext3
        self.ext4 = ext4
    }
    
}

/// This class extends *PlatonWebOptions* and provide some new fields which handle representation of requests from *PlatonWebSaleAdapter*
public struct PlatonWebSaleAdditional: PlatonParametersProtocol, PlatonWebAdditionalProtocol {
    
    /// Localization language to be selected on the payment page by default
    var language: String?
    
    /// Optional URL to which the Buyer will be returned after three unsuccessful purchase attempts
    var errorUrl: String?
    
    /// Specific payment page identifier for web payments
    ///
    /// (In case the Client's account has multiple payment pages configured)
    var formId: String?
    
    /// Client Parameter 1
    var ext1: String?
    
    /// Client Parameter 2
    var ext2: String?
    
    /// Client Parameter 3
    var ext3: String?
    
    /// Client Parameter 4
    var ext4: String?
    
    /// Client Parameter 5
    var ext5: String?
    
    /// Client Parameter 6
    var ext6: String?
    
    /// Client Parameter 7
    var ext7: String?
    
    /// Client Parameter 8
    var ext8: String?
    
    /// Client Parameter 9
    var ext9: String?
    
    /// Client Parameter 10
    var ext10: String?

    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.lang: language,
            PlatonMethodProperty.errorUrl: errorUrl,
            PlatonMethodProperty.formId: formId,
            PlatonMethodProperty.ext1: ext1,
            PlatonMethodProperty.ext2: ext2,
            PlatonMethodProperty.ext3: ext3,
            PlatonMethodProperty.ext4: ext4,
            PlatonMethodProperty.ext5: ext5,
            PlatonMethodProperty.ext6: ext6,
            PlatonMethodProperty.ext7: ext7,
            PlatonMethodProperty.ext8: ext8,
            PlatonMethodProperty.ext9: ext9,
            PlatonMethodProperty.ext10: ext10,
        ]
    }
    
    public init(language: String?, errorUrl: String?, formId: String?,
                ext1: String?, ext2: String?, ext3: String?, ext4: String?,
                ext5: String? = nil, ext6: String? = nil, ext7: String? = nil, ext8: String? = nil, ext9: String? = nil, ext10: String? = nil) {
        self.language = language
        self.errorUrl = errorUrl
        self.formId = formId
        self.ext1 = ext1
        self.ext2 = ext2
        self.ext3 = ext3
        self.ext4 = ext4
        self.ext5 = ext5
        self.ext6 = ext6
        self.ext7 = ext7
        self.ext8 = ext8
        self.ext9 = ext9
        self.ext10 = ext10
    }
    
}

/// This class extends *PlatonWebOptions* and provide some new fields which handle representation of requests from *PlatonWebSaleAdapter*
public struct PlatonWebTokenSaleAdditional: PlatonParametersProtocol, PlatonWebTokenAdditionalProtocol {
    
    /// Localization language to be selected on the payment page by default
    var language: String?
    
    /// Optional URL to which the Buyer will be returned after three unsuccessful purchase attempts
    var errorUrl: String?
    
    /// Specific payment page identifier for web payments
    ///
    /// (In case the Client's account has multiple payment pages configured)
    var formId: String?
    
    /// Card token
    var cardToken: String?
    
    /// Client Parameter 1
    var ext1: String?

    /// Client Parameter 2
    var ext2: String?
    
    /// Client Parameter 3
    var ext3: String?
    
    /// Client Parameter 4
    var ext4: String?
    
    /// Client Parameter 5
    var ext5: String?
    
    /// Client Parameter 6
    var ext6: String?
    
    /// Client Parameter 7
    var ext7: String?
    
    /// Client Parameter 8
    var ext8: String?
    
    /// Client Parameter 9
    var ext9: String?
    
    /// Client Parameter 10
    var ext10: String?

    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.lang: language,
            PlatonMethodProperty.errorUrl: errorUrl,
            PlatonMethodProperty.formId: formId,
            PlatonMethodProperty.cardToken: cardToken,
            PlatonMethodProperty.ext1: ext1,
            PlatonMethodProperty.ext2: ext2,
            PlatonMethodProperty.ext3: ext3,
            PlatonMethodProperty.ext4: ext4,
            PlatonMethodProperty.ext5: ext5,
            PlatonMethodProperty.ext6: ext6,
            PlatonMethodProperty.ext7: ext7,
            PlatonMethodProperty.ext8: ext8,
            PlatonMethodProperty.ext9: ext9,
            PlatonMethodProperty.ext10: ext10,
        ]
    }
    
    public init(language: String?, errorUrl: String?, formId: String?, cardToken: String?,
                ext1: String? = nil, ext2: String?, ext3: String?, ext4: String?,
                ext5: String? = nil, ext6: String? = nil, ext7: String? = nil, ext8: String? = nil, ext9: String? = nil, ext10: String? = nil) {
        self.language = language
        self.errorUrl = errorUrl
        self.formId = formId
        self.cardToken = cardToken
        self.ext1 = ext1
        self.ext2 = ext2
        self.ext3 = ext3
        self.ext4 = ext4
        self.ext5 = ext5
        self.ext6 = ext6
        self.ext7 = ext7
        self.ext8 = ext8
        self.ext9 = ext9
        self.ext10 = ext10
    }
}


/// This class extends *PlatonWebOptions* and provide some new fields which handle representation of requests from *PlatonWebCardVerificationAdapter*
public struct PlatonWebVerificationAdditional: PlatonParametersProtocol, PlatonWebVerificationProtocol {
    
    /// Turn on callback for Bank ID (yes/no)
    var bankId: String?

    /// Turn on callback for Payer ID (yes/no)
    var payerId: String?

    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.bankId: bankId,
            PlatonMethodProperty.payerId: payerId,
        ]
    }
    
    public init(bankId: String?, payerId: String?) {
        self.bankId = bankId
        self.payerId = payerId
    }
    
}



