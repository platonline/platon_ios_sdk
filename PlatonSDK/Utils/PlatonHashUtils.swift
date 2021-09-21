
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

/**
 Hash is signature rule used either to validate your requests to POST payment platform or to validate callback from payment platform to your system
 
 Sign is signature rule used either to validate your requests to WEB payment platform or to validate callback from payment platform to your system
 */
final class PlatonHashUtils {
    
    /// md5(strtoupper(strrev(email).CLIENT_PASS.trans_id.strrev(substr(card_number,0,6).substr(card_number,-4))))
    ///
    /// - Parameters:
    ///   - email: payer email
    ///   - cardNumber: initial transaction id
    ///   - transId: payer card number
    /// - Returns: md5 hash for all requests
    static func encryptSale(email: String, cardNumber: String, transId: String? = nil) -> String? {
        guard let unwPlatonCredentials = PlatonSDK.shared.credentials,
            email.count > 0 && cardNumber.count > 0 && cardNumber.count > 5 else { return nil }
        
        let reverseEmail = String(email.reversed())
        let clientPass = unwPlatonCredentials.clientPass
        
        let cardNumberFirstPart = cardNumber.prefix(6)
        let cardNumberSecondPart = cardNumber.suffix(4)

        let cardNumberCombination = cardNumberFirstPart + cardNumberSecondPart
        let reverseCardNumberCombination = String(cardNumberCombination.reversed())
        
        let allReversedString: String
        
        if let unwTransId = transId {
            allReversedString = reverseEmail + clientPass + unwTransId + reverseCardNumberCombination
        } else {
            allReversedString = reverseEmail + clientPass + reverseCardNumberCombination
        }
        
        return MD5(allReversedString.uppercased()).lowercased()
    }
    
    /// md5(strtoupper(strrev(CLIENT_KEY).strrev(payment).strrev(data).strrev(successUrl).strrev(CLIENT_PASS)))
    ///
    /// - Parameters:
    ///   - payment: payment code
    ///   - data: encoded base64 products list
    ///   - successUrl: successful url after sale transaction
    /// - Returns: md5 hash for *PlatonWebSaleAdapter.swift* requests
    static func encryptSaleWeb(payment: String?, data: String?, successUrl: String?) -> String? {
        guard let unwPlatonCredentials = PlatonSDK.shared.credentials, let unwPayment = payment, let unwData = data, let unwSuccessUrl = successUrl else { return nil }
        
        let reverseClientKey = String(unwPlatonCredentials.clientKey.reversed())
        let reversePayment = String(unwPayment.reversed())
        let reverseData = String(unwData.reversed())
        let reverseSuccessUrl = String(unwSuccessUrl.reversed())
        let reverseClientPass = String(unwPlatonCredentials.clientPass.reversed())
        
        let allString = reverseClientKey + reversePayment + reverseData + reverseSuccessUrl + reverseClientPass
        
        return MD5(allString.uppercased()).lowercased()
    }
    
    /// $sign = md5(strtoupper(strrev($key).strrev($payment).strrev($data).strrev($url).strrev($card_token).strrev($CLIENT_PASS)));
    ///
    /// - Parameters:
    ///   - payment: payment code
    ///   - data: encoded base64 products list
    ///   - card_token
    ///   - successUrl: successful url after sale transaction
    /// - Returns: md5 hash for *PlatonWebTokenSaleAdapter.swift* requests
    static func encryptSaleTokenWeb(payment: String?, data: String?, successUrl: String?, cardToken: String?) -> String? {
        guard let unwPlatonCredentials = PlatonSDK.shared.credentials, let unwPayment = payment, let unwData = data, let unwSuccessUrl = successUrl, let unwCardToken = cardToken else { return nil }
        
        let reverseClientKey = String(unwPlatonCredentials.clientKey.reversed())
        let reversePayment = String(unwPayment.reversed())
        let reverseData = String(unwData.reversed())
        let reverseSuccessUrl = String(unwSuccessUrl.reversed())
        let reverseClientPass = String(unwPlatonCredentials.clientPass.reversed())
        let reverseCardToken = String(unwCardToken.reversed())
        
        let allString = reverseClientKey + reversePayment + reverseData + reverseSuccessUrl + reverseCardToken + reverseClientPass
        
        return MD5(allString.uppercased()).lowercased()
    }
    
    /// md5(strtoupper(strrev(CLIENT_KEY).strrev(amount).strrev(description).strrev(rc_id).strrev(rc_token).strrev(CLIENT_PASS)))
    ///
    /// - Parameters:
    ///   - productRecurring: product recurring info
    ///   - recurring: recurring info with id and token
    /// - Returns: md5 hash for *PlatonWebRecurringAdapter.swift* requests
    static func encryptRecurringWeb(productRecurring: PlatonProductRecurring?, recurring: PlatonRecurringWeb?) -> String? {
        guard let credentials = PlatonSDK.shared.credentials, let unwProductRecutting = productRecurring, let unwRecurring = recurring, let amount = unwProductRecutting.amount.platonAmount else { return nil }
        
        let reverseClientKey = String(credentials.clientKey.reversed())
        let reverseAmount = String(amount.reversed())
        let reverseDescription = String(unwProductRecutting.description.reversed())
        let reverseTransId = String(unwRecurring.firstTransId.reversed())
        let reverseToken = String(unwRecurring.token.reversed())
        let reverseClientPass = String(credentials.clientPass.reversed())
        
        return MD5(reverseClientKey.appending(reverseAmount).appending(reverseDescription).appending(reverseTransId).appending(reverseToken).appending(reverseClientPass).uppercased()).lowercased()
    }
    
    /// md5(strtoupper(strrev(CLIENT_KEY).strrev(amount).strrev(.strrev(rc_id).strrev(rc_token).strrev(initial_delay).strrev(period).strrev(times).strrev(CLIENT_PASS)))
    ///
    /// - Parameters:
    ///   - productRecurring: product recurring
    ///   - recurringWeb: recurring info with id and token
    ///   - scheduleAdditional: schedule additonal parameters
    /// - Returns: md5 hash for *PlatonWebScheduleAdapter.schedule()*
    static func encryptScheduleWeb(productRecurring: PlatonProduct?, recurringWeb: PlatonRecurringWeb?, scheduleAdditional: PlatonWebScheduleAdditonal) -> String? {
        
        guard let credentials = PlatonSDK.shared.credentials, let unwProductRecutting = productRecurring, let unwRecurring = recurringWeb, let amount = unwProductRecutting.amount.platonAmount else { return nil }
        
        let reverseClientKey = String(credentials.clientKey.reversed())
        let reverseAmount = String(amount.reversed())
        let reverseDescription = String(unwProductRecutting.description.reversed())
        let reverseTransId = String(unwRecurring.firstTransId.reversed())
        let reverseToken = String(unwRecurring.token.reversed())
        
        let reverseInitialDelay = String(String(scheduleAdditional.initialDelay).reversed())
        let reversePeriod = String(String(scheduleAdditional.period).reversed())
        let reverseRepeatTime = String(String(scheduleAdditional.repeatTimes).reversed())
        
        let reverseClientPass = String(credentials.clientPass.reversed())
        
        return MD5(reverseClientKey.appending(reverseAmount).appending(reverseDescription).appending(reverseTransId).appending(reverseToken).appending(reverseInitialDelay).appending(reversePeriod).appending(reverseRepeatTime).appending(reverseClientPass).uppercased()).lowercased()
    }
    
    /// md5(strtoupper(strrev(CLIENT_KEY).strrev(rc_id).strrev(rc_token).strrev(CLIENT_PASS)
    ///
    /// - Parameter recurringWeb: recurring info with id and token
    /// - Returns: md5 hash for *PlatonWebScheduleAdapter.deschedule*
    public static func encryptDescheduleWeb(recurringWeb: PlatonRecurringWeb) -> String? {
        guard let credentials = PlatonSDK.shared.credentials else {
            return nil
        }
        
        let reverseClientKey = String(credentials.clientKey.reversed())
        let reverseTransId = String(recurringWeb.firstTransId.reversed())
        let reverseToken = String(recurringWeb.token.reversed())
        let reverseClientPass = String(credentials.clientPass.reversed())
        
        return MD5(reverseClientKey.appending(reverseTransId).appending(reverseToken).appending(reverseClientPass).uppercased()).lowercased()
    }
    
    /// md5(strtoupper(strrev(CLIENT_KEY).strrev(data).strrev(rc_id).strrev(rc_token).strrev(url).strrev(CLIENT_PASS)))
    ///
    /// - Parameters:
    ///   - data: encoded base64 product sale
    ///   - recurringWeb: holder for rc_id and rc_token
    ///   - successUrl: successful url after one-click payment
    /// - Returns: md5 hash for *PlatonWebOneClickSaleAdapter.swift* requests
    public static func encryptOneClickSaleWeb(data: String?, recurringWeb: PlatonRecurringWeb, successUrl: String) -> String? {
        guard let credentials = PlatonSDK.shared.credentials, let unwData = data else {
            return nil
        }
        
        let reverseClientKey = String(credentials.clientKey.reversed())
        let reverseData = String(unwData.reversed())
        let reverseTransId = String(recurringWeb.firstTransId.reversed())
        let reverseToken = String(recurringWeb.token.reversed())
        let reverseSuccessUrl = String(successUrl.reversed())
        let reverseClientPass = String(credentials.clientPass.reversed())
        
        return MD5(reverseClientKey.appending(reverseData).appending(reverseTransId).appending(reverseToken).appending(reverseSuccessUrl).appending(reverseClientPass).uppercased()).lowercased()
    }

    /// md5(strtoupper(strrev(email).CLIENT_PASS.strrev(payment_token)))
    ///
    /// - Parameters:
    ///   - email: payer email
    ///   - token: ApplePay transaction token
    /// - Returns: md5 hash for *PlatonApplePayAdapter.swift* requests

    static func encryptApplePay(email: String, token: String) -> String? {
        guard let unwPlatonCredentials = PlatonSDK.shared.credentials,
            email.count > 0 && token.count > 0 else { return nil }

        let reverseEmail = String(email.reversed())
        let clientPass = unwPlatonCredentials.clientPass
        let reverseToken = String(token.reversed())

        let allString = reverseEmail + clientPass + reverseToken

        return MD5(allString.uppercased()).lowercased()
    }

    /// md5(strtoupper(CLIENT_PASS.strrev(order_it)))
    ///
    /// - Parameters:
    ///   - orderId: order ID
    /// - Returns: md5 hash for *PlatonTransStateAdapter.swift* requests

    static func encryptStateTransaction(orderId: String) -> String? {
        guard let unwPlatonCredentials = PlatonSDK.shared.credentials else { return nil }

        let clientPass = unwPlatonCredentials.clientPass

        let allString = clientPass + orderId

        return MD5(allString.uppercased()).lowercased()
    }

    /// md5(strtoupper(strrev(CLIENT_KEY).strrev(payment).strrev(amount).strrev(currency).strrev(description).strrev(url).strrev(CLIENT_PASS)))
    ///
    /// - Parameters:
    ///   - payment: payment code
    ///   - productSale: product sale info
    ///   - successUrl: successful url after sale transaction
    /// - Returns: md5 hash for *PlatonWebC2AAdapter.swift* requests
    static func encryptC2AWeb(payment: String?, productSale: PlatonProductSale?, successUrl: String) -> String? {
        guard let credentials = PlatonSDK.shared.credentials, let unwPayment = payment, let unwProductSale = productSale, let amount = unwProductSale.amount.platonAmount else { return nil }
        
        let reverseClientKey = String(credentials.clientKey.reversed())
        let reversePayment = String(unwPayment.reversed())
        let reverseAmount = String(amount.reversed())
        let reverseCurrency = String(unwProductSale.currencyCode.reversed())
        let reverseDescription = String(unwProductSale.description.reversed())
        let reverseSuccessUrl = String(successUrl.reversed())
        let reverseClientPass = String(credentials.clientPass.reversed())

        let allString = reverseClientKey + reversePayment + reverseAmount + reverseCurrency + reverseDescription + reverseSuccessUrl + reverseClientPass

        return MD5(allString.uppercased()).lowercased()
    }

    private static func MD5Data(_ string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    
    //MD5 Hex
    private static func MD5(_ string: String) -> String {
        let md5Data = MD5Data(string)
        return md5Data.map { String(format: "%02hhx", $0) }.joined()
    }

    //MD5 Base64
    private static func MD5Base64(_ string: String) -> String {
        let md5Data = MD5Data(string)
        return md5Data.base64EncodedString()
    }
}


