
import UIKit
import PlatonSDK

class GetTransDetailsViewController: UIViewController {
    
    // MARK: - Properties
    // Views
    @IBOutlet var tfTransId: UITextField!
    @IBOutlet var tfPayerEmail: UITextField!
    @IBOutlet var tfCardNumber: UITextField!
    
    @IBOutlet var lbResponse: UILabel!
    
    // Constraints
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfTransId.text = UserDefaults.standard.string(forKey: PlatonMethodProperty.transId.rawValue)
        tfPayerEmail.text = "ulices@casper.bz"
        tfCardNumber.text = PlatonCard(test: .success).number
    }
    
    // MARK: - Actions
    
    @IBAction func getTransDetailsAction(_ sender: LoadingButton) {
        sender.isLoading = true
        view.endEditing(true)
        
        PlatonPostPayment.transaction.getTransDetails(transactionId: tfTransId.text ?? "",
                                                     payerEmail: tfPayerEmail.text ?? "",
                                                     cardNumber: tfCardNumber.text ?? "") { (result) in
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
