
import UIKit
import PlatonSDK

class WebOneClickSaleViewController: UIViewController {

    // MARK: - Views
    
    @IBOutlet weak var tfFirstTransId: UITextField!
    @IBOutlet weak var tfRecurringToken: UITextField!
    
    @IBOutlet weak var tfOrderId: UITextField!
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

        tfFirstTransId.text = "20677-25871-98008"
        tfRecurringToken.text = "297d2db30f349d66a1003ee80ace78b0"
        
        tfOrderId.text = "667"
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
        sender.isLoading = true
        
        let productSale = PlatonProductSale(amount: Float(tfOrderAmount.text ?? "") ?? 0,
                                            currencyCode: tfOrderCurrencyCode.text ?? "",
                                            description: tfOrderDescription.text ?? "")
        let recurringWeb = PlatonRecurringWeb(firstTransId: tfFirstTransId.text ?? "",
                                              token: tfRecurringToken.text ?? "")
        let additional = PlatonWebSaleAdditional(language: tfLanguage.text,
                                                 errorUrl: tfErrorUrl.text,
                                                 formId: tfFormId.text,
                                                 ext1: tfExt1.text,
                                                 ext2: tfExt2.text,
                                                 ext3: tfExt3.text,
                                                 ext4: tfExt4.text)
        
        PlatonWebPayment.oneClickSale.sale(productSale: productSale,
                                           recurringWeb: recurringWeb,
                                           successUrl: tfSuccessUrl.text ?? "",
                                           orderId: tfOrderId.text,
                                           additonal: additional) { (result) in
                                            sender.isLoading = false
                                            
                                            switch result {
                                            case .failure(let error):
                                                self.showError(error)
                                            case .success(let responseData):
                                                WebViewController.open(url: responseData.response?.url, fromConstroller: self)
                                            }
                                            
        }
        
    }
    

}
