
import UIKit
import PlatonSDK


class CaptureViewController: UIViewController {
    
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
        tfPartialAmount.text = "15"
    }
    
    // MARK: - Actions
    
    @IBAction func captureAction(_ sender: LoadingButton) {
        sender.isLoading = true
        view.endEditing(true)
        
        PlatonPostPayment.capture.capture(transactionId: tfTransId.text ?? "",
                                         payerEmail: tfPayerEmail.text ?? "",
                                         cardNumber: tfCardNumber.text ?? "",
                                         amount: Float(tfPartialAmount.text ?? "")) { [unowned self] (result) in
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
