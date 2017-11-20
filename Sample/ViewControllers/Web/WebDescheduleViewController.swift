
import UIKit
import PlatonSDK

class WebDescheduleViewController: UIViewController {
    
    // MARK: - Views
    
    @IBOutlet weak var tfFirstTransId: UITextField!
    @IBOutlet weak var tfRecurringToken: UITextField!
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfFirstTransId.text = "20677-25871-98008"
        tfRecurringToken.text = "297d2db30f349d66a1003ee80ace78b0"
    }
    
    // MARK: - Actions
    
    @IBAction func descheduleAction(_ sender: LoadingButton) {
        // Will be available in next releases
        
//        sender.isLoading = true
//
//        let recurringWeb = PlatonRecurringWeb(firstTransId: tfFirstTransId.text ?? "",
//                                              token: tfRecurringToken.text ?? "")
//
//        _ = PlatonWebPayment.schedule.deschedule(recurring: recurringWeb) { (result) in
//            sender.isLoading = false
//            
//            switch result {
//            case .failure(let error):
//                self.showError(error)
//                
//            case .success(let responseData):
//                WebViewController.open(url: responseData.response?.url, fromConstroller: self)
//            }
//            
//        }
        
    }
    
}
