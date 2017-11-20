
import UIKit
import PlatonSDK

class RecurringSaleViewController: UIViewController {

    // MARK: - Properties
    // Views
    @IBOutlet var tfOrderId: UITextField!
    @IBOutlet var tfOrderAmount: UITextField!
    @IBOutlet var tfOrderDescription: UITextField!
    
    @IBOutlet var tfPayerEmail: UITextField!
    @IBOutlet var tfCardNumber: UITextField!
    @IBOutlet var tfFirstTransId: UITextField!
    @IBOutlet var tfRecurringToken: UITextField!
    @IBOutlet var swAsyncRecurring: UISwitch!
    
    
    @IBOutlet var btnAuth: UIButton!
    @IBOutlet var btnSale: UIButton!
    @IBOutlet var lbResponse: UILabel!
    
    // Constraints
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfOrderId.text = UserDefaults.standard.string(forKey: PlatonMethodProperty.orderId.rawValue)
        tfOrderAmount.text = "15"
        tfOrderDescription.text = "Accusantium est aut rem eum. Repellat consequatur nesciunt nihil. Autem culpa omnis."
        
        tfPayerEmail.text = "ulices@casper.bz"
        tfCardNumber.text = PlatonCard(test: .success).number
        tfFirstTransId.text = UserDefaults.standard.string(forKey: PlatonMethodProperty.transId.rawValue)
        tfRecurringToken.text = UserDefaults.standard.string(forKey: PlatonMethodProperty.recurringToken.rawValue)
        
        swAsyncRecurring.setOn(false, animated: false)
    }
    
    // MARK: - Actions

    @IBAction func recurringAction(_ sender: LoadingButton) {
        sender.isLoading = true
        view.endEditing(true)
        
        let order = PlatonOrder(amount: Float(tfOrderAmount.text ?? "") ?? 0,
                                id: tfOrderId.text ?? "",
                                orderDescription: tfOrderDescription.text ?? "")
        
        let recurring = PlatonRecurring(firstTransId: tfFirstTransId.text ?? "",
                                        token: tfRecurringToken.text ?? "")
        
        let auth = sender == btnAuth ? PlatonOption.yes : nil
        
        PlatonPostPayment.recurring.sale(order: order,
                                            recurring: recurring,
                                            email: tfPayerEmail.text ?? "",
                                            cardNumber: tfCardNumber.text ?? "",
                                            auth: auth,
                                            async: swAsyncRecurring.isOn ? .yes : nil) { (result) in
                                                sender.isLoading = false
                                                
                                                switch result {
                                                case .failure(let error):
                                                    self.lbResponse.text = "\(error)"                                                    
                                                default:
                                                    self.lbResponse.text = "\(String(describing: result.responseObject!))"
                                                }
                                                
        }
        
    }
}
