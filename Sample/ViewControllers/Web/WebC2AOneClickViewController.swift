
import UIKit
import PlatonSDK

class WebC2AOneClickViewController: UIViewController {

    // MARK: - Views
    
    @IBOutlet weak var tfPayerFirstName: UITextField!
    @IBOutlet weak var tfPayerLastName: UITextField!
    @IBOutlet weak var tfPayerAddress: UITextField!
    @IBOutlet weak var tfPayerCountryCode: UITextField!
    @IBOutlet weak var tfPayerState: UITextField!
    @IBOutlet weak var tfPayerCity: UITextField!
    @IBOutlet weak var tfPayerZip: UITextField!
    @IBOutlet weak var tfPayerEmail: UITextField!
    @IBOutlet weak var tfPayerPhone: UITextField!

    @IBOutlet weak var tfOrderId: UITextField!
    @IBOutlet weak var tfRecurringToken: UITextField!
    @IBOutlet weak var tfOrderAmount: UITextField!
    @IBOutlet weak var tfOrderDescription: UITextField!
    @IBOutlet weak var tfOrderCurrencyCode: UITextField!
    @IBOutlet weak var tfSuccessUrl: UITextField!
    @IBOutlet weak var tfErrorUrl: UITextField!
    @IBOutlet weak var tfLanguage: UITextField!
    @IBOutlet weak var tfFormId: UITextField!
    @IBOutlet weak var tfExt1: UITextField!
    @IBOutlet weak var tfExt2: UITextField!
    @IBOutlet weak var tfExt3: UITextField!
    @IBOutlet weak var tfExt4: UITextField!
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfPayerFirstName.text = "Leo"
        tfPayerLastName.text = "Ernser"
        tfPayerAddress.text = "Apt. 282"
        tfPayerCountryCode.text = "BQ"
        tfPayerState.text = "NA"
        tfPayerCity.text = "New Howell borough"
        tfPayerZip.text = "79591"
        tfPayerEmail.text = "ulices@casper.bz"
        tfPayerPhone.text = "(202) 091-2508"

        tfOrderId.text = "6671234"
        tfRecurringToken.text = "508e04f162ca933e55da1b169107e29601ddcf728703fb271591cbf1a7d3b592"
        tfOrderAmount.text = "13"
        tfOrderDescription.text = "Accusantium est aut rem eum. Repellat consequatur nesciunt nihil. Autem culpa omnis."
        tfOrderCurrencyCode.text = "UAH"
        tfSuccessUrl.text = "https://www.apple.com"
        tfErrorUrl.text = "https://www.google.com.ua"
        tfLanguage.text = "RU"
        
        tfExt1.text = "https://robohash.org/Esther?size=300x300"
        tfExt2.text = "https://robohash.org/Gwendolyn?size=300x300"
        tfExt3.text = "https://robohash.org/Eleanore?size=300x300"
        tfExt4.text = "https://robohash.org/Joana?size=300x300"
    }

    // MARK: - Actions

    @IBAction func oneClickSaleAction(_ sender: LoadingButton) {
        guard validateUrl(tfSuccessUrl.text, tfErrorUrl.text) else {
            return
        }
        
        sender.isLoading = true
        
        let productSale = PlatonProductSale(amount: Float(tfOrderAmount.text ?? "") ?? 0,
                                            currencyCode: tfOrderCurrencyCode.text ?? "",
                                            description: tfOrderDescription.text ?? "")
        let additional = PlatonWebTokenSaleAdditional(language: tfLanguage.text,
                                                      errorUrl: tfErrorUrl.text,
                                                      formId: tfFormId.text,
                                                      cardToken: tfRecurringToken.text,
                                                      ext1: tfExt1.text,
                                                      ext2: tfExt2.text,
                                                      ext3: tfExt3.text,
                                                      ext4: tfExt4.text)

        let payerWrbSale = PlatonPayerWebSale(firstName: tfPayerFirstName.text,
                                              lastName: tfPayerLastName.text,
                                              address: tfPayerAddress.text,
                                              countryCode: tfPayerCountryCode.text,
                                              state: tfPayerState.text,
                                              city: tfPayerCity.text,
                                              zip: tfPayerZip.text,
                                              email: tfPayerEmail.text,
                                              phone: tfPayerPhone.text)

        PlatonWebPayment.C2AOneClick.sale(productSale: productSale,
                                  successUrl: tfSuccessUrl.text ?? "",
                                  orderId: tfOrderId.text ?? "",
                                  payerWebSale: payerWrbSale,
                                  additional: additional) { result, response in
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
