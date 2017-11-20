
import UIKit
import PlatonSDK


class CreditVoidViewController: UIViewController {
    
    // MARK: - Properties
    // Views
    @IBOutlet var tfTransId: UITextField!
    @IBOutlet var tfPayerEmail: UITextField!
    @IBOutlet var tfCardNumber: UITextField!
    @IBOutlet var tfPartialAmount: UITextField!
    
    @IBOutlet var lbResponse: UILabel!
    
    // Constraints
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfTransId.text = UserDefaults.standard.string(forKey: PlatonMethodProperty.transId.rawValue)
        tfPayerEmail.text = "ulices@casper.bz"
        tfCardNumber.text = PlatonCard(test: .success).number
        tfPartialAmount.text = "16734.43"
    }
    
    // MARK: - Actions
    
    @IBAction func creditVoidAction(_ sender: LoadingButton) {
        sender.isLoading = true
        view.endEditing(true)
        
        PlatonPostPayment.creditVoid.creditVoid(transactionId: tfTransId.text ?? "",
                                               payerEmail: tfPayerEmail.text ?? "",
                                               cardNumber: tfCardNumber.text ?? "",
                                               amount: Float(tfPartialAmount.text ?? "")) { (result) in
                                                sender.isLoading = false
                                                
                                                switch result {
                                                case .failure(let error):
                                                    self.lbResponse.text = "\(error)"
                                                default:
                                                    self.lbResponse.text = "\(result.responseObject!)"
                                                }
        }
    }
}
