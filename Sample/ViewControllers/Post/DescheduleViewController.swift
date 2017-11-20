
import UIKit
import PlatonSDK

class DescheduleViewController: UIViewController {

    // MARK: - Properties
    // Views
    @IBOutlet var tfPayerEmail: UITextField!
    @IBOutlet var tfCardNumber: UITextField!
    @IBOutlet var tfTransId: UITextField!
    @IBOutlet var tfRecurringToken: UITextField!
    
    @IBOutlet var lbResponse: UILabel!
    
    // Constraints
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfPayerEmail.text = "ulices@casper.bz"
        tfCardNumber.text = PlatonCard(test: .success).number
        tfTransId.text = UserDefaults.standard.string(forKey: PlatonMethodProperty.transId.rawValue)
        tfRecurringToken.text = UserDefaults.standard.string(forKey: PlatonMethodProperty.recurringToken.rawValue)
    }
    
    // MARK: - Actions

    @IBAction func descheduleAction(_ sender: LoadingButton) {
        sender.isLoading = true
        view.endEditing(true)
        
        let recurring = PlatonRecurring(firstTransId: tfTransId.text ?? "", token: tfRecurringToken.text ?? "")
        
        PlatonPostPayment.schedule.deschedule(recurring: recurring,
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
