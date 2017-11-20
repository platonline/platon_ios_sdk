
import UIKit
import PlatonSDK

class WebScheduleViewController: UIViewController {
    
    // MARK: - Views
    
    @IBOutlet weak var tfOrderAmount: UITextField!
    @IBOutlet weak var tfOrderDescription: UITextField!
    @IBOutlet weak var tfFirstTransId: UITextField!
    @IBOutlet weak var tfRecurringToken: UITextField!
    @IBOutlet weak var tfPeriod: UITextField!
    @IBOutlet weak var tfInitialDelay: UITextField!
    @IBOutlet weak var tfRepeatTimes: UITextField!
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfOrderAmount.text = "13"
        tfOrderDescription.text = "Accusantium est aut rem eum. Repellat consequatur nesciunt nihil. Autem culpa omnis."
        
        tfFirstTransId.text = "20677-25871-98008"
        tfRecurringToken.text = "297d2db30f349d66a1003ee80ace78b0"
        
        tfPeriod.text = "2"
        tfInitialDelay.text = "3"
        tfRepeatTimes.text = "2"
    }
    
    // MARK: - Actions
    
    @IBAction func scheduleAction(_ sender: LoadingButton) {
        // Will be available in next releases
        
//        sender.isLoading = true
//        
//        let product = PlatonProduct(amount: Float(tfOrderAmount.text ?? "") ?? 0,
//                                    description: tfOrderDescription.text ?? "")
//        
//        let recurringWeb = PlatonRecurringWeb(firstTransId: tfFirstTransId.text ?? "",
//                                              token: tfRecurringToken.text ?? "")
//        
//        let additional = PlatonWebScheduleAdditonal(initialDelay: Int(tfInitialDelay.text ?? "") ?? 0,
//                                                    period: Int(tfPeriod.text ?? "") ?? 0,
//                                                    repeatTimes: Int(tfRepeatTimes.text ?? "") ?? 0)
//        
//        PlatonWebPayment.schedule.schedule(product: product,
//                                               recurring: recurringWeb,
//                                               additional: additional) { (result) in
//                                                sender.isLoading = false
//                                                
//                                                switch result {
//                                                case .failure(let error):
//                                                    self.showError(error)
//                                                    
//                                                case .success(let responseData):
//                                                    WebViewController.open(url: responseData.response?.url, fromConstroller: self)
//                                                }
//                                                
//        }
        
    }
    
}
