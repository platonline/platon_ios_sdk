
import UIKit
import PlatonSDK

class WebCardVerificationViewController: UIViewController {
    
    // MARK: - Views
    @IBOutlet var tfOrderId: UITextField!
    @IBOutlet var tfPayerFirstName: UITextField!
    @IBOutlet var tfPayerLastName: UITextField!
    @IBOutlet var tfPayerAddress: UITextField!
    @IBOutlet var tfPayerCountryCode: UITextField!
    @IBOutlet var tfPayerState: UITextField!
    @IBOutlet var tfPayerCity: UITextField!
    @IBOutlet var tfPayerZip: UITextField!
    @IBOutlet var tfPayerEmail: UITextField!
    @IBOutlet var tfPayerPhone: UITextField!
    @IBOutlet var tfLanguage: UITextField!
    @IBOutlet var tfSuccessURL: UITextField!
    @IBOutlet var tfErrorURL: UITextField!
    @IBOutlet var tfExt1: UITextField!
    @IBOutlet var tfExt2: UITextField!
    @IBOutlet var tfExt3: UITextField!
    @IBOutlet var tfExt4: UITextField!
    
    @IBOutlet weak var productsScrollView: UIScrollView!
    @IBOutlet weak var productsStackView: UIStackView!
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfOrderId.text = "6673333"
        
        tfPayerFirstName.text = "Leo"
        tfPayerLastName.text = "Ernser"
        tfPayerAddress.text = "Apt. 282"
        tfPayerCountryCode.text = "BQ"
        tfPayerState.text = "NA"
        tfPayerCity.text = "New Howell borough"
        tfPayerZip.text = "79591"
        tfPayerEmail.text = "ulices@casper.bz"
        tfPayerPhone.text = "(202) 091-2508"
        
        tfLanguage.text = "RU"
        tfSuccessURL.text = "https://www.apple.com"
        tfErrorURL.text = "https://www.google.com.ua"
        
        tfExt1.text = "https://robohash.org/Esther?size=300x300"
        tfExt2.text = "https://robohash.org/Gwendolyn?size=300x300"
        tfExt3.text = "https://robohash.org/Eleanore?size=300x300"
        tfExt4.text = "https://robohash.org/Joana?size=300x300"
    }
    
    // MARK: - Actions
    
    @IBAction func scheduleAction(_ sender: LoadingButton) {
        guard validateUrl(tfErrorURL.text, tfSuccessURL.text) else {
            return
        }
        
        sender.isLoading = true
        
        var prdouctsSale = [PlatonProductSale]()
        
        let productSale = PlatonProductSale(isSelected: true,
                                            isRecurring: false,
                                            amount: 1,
                                            currencyCode: "UAH",
                                            description: "product")
        prdouctsSale.append(productSale)

        let payerWrbSale = PlatonPayerWebSale(firstName: tfPayerFirstName.text,
                                              lastName: tfPayerLastName.text,
                                              address: tfPayerAddress.text,
                                              countryCode: tfPayerCountryCode.text,
                                              state: tfPayerState.text,
                                              city: tfPayerCity.text,
                                              zip: tfPayerZip.text,
                                              email: tfPayerEmail.text,
                                              phone: tfPayerPhone.text)
        
        let additional = PlatonWebSaleAdditional(language: tfLanguage.text,
                                                 errorUrl: tfErrorURL.text,
                                                 formId: nil,
                                                 ext1: tfExt1.text,
                                                 ext2: tfExt2.text,
                                                 ext3: tfExt3.text,
                                                 ext4: tfExt4.text,
                                                 ext5: "ext5",
                                                 ext6: "ext6",
                                                 ext7: "ext7",
                                                 ext8: "ext8",
                                                 ext9: "ext9",
                                                 ext10: "ext10")
        let verificationAdditional = PlatonWebVerificationAdditional(bankId: "yes", payerId: "yes")
        
        PlatonWebPayment.cardVerification.verify(productSales: prdouctsSale,
                                                 successUrl: tfSuccessURL.text ?? "",
                                                 orderId: tfOrderId.text ?? "",
                                                 req_token: "Y",
                                                 payerWebSale: payerWrbSale,
                                                 additional: additional,
                                                 verificationAdditional: verificationAdditional) { result, response  in
            sender.isLoading = false
            
            switch result {
                case .failure(let error):
                    self.showError(error)
                    
                case .success(_):
                    WebViewController.open(url: response?.url, fromConstroller: self)
            }
        }
    }
}
