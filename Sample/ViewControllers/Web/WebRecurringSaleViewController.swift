
import UIKit
import PlatonSDK

class WebRecurringSaleViewController: UIViewController {
    
    // MARK: - Properties
    // MARK: - Views
    @IBOutlet weak var tfOrderId: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfOrderDescription: UITextField!
    @IBOutlet weak var tfFirstTransId: UITextField!
    @IBOutlet weak var tfRecurringToken: UITextField!
    @IBOutlet weak var tfExt1: UITextField!
    @IBOutlet weak var tfExt2: UITextField!
    @IBOutlet weak var tfExt3: UITextField!
    @IBOutlet weak var tfExt4: UITextField!
    
    // Constraints
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfOrderId.text = "667"
        tfAmount.text = "13"
        tfOrderDescription.text = "Accusantium est aut rem eum. Repellat consequatur nesciunt nihil. Autem culpa omnis."
        
        tfFirstTransId.text = "20677-25871-98008"
        tfRecurringToken.text = "297d2db30f349d66a1003ee80ace78b0"
        
        tfExt1.text = "https://robohash.org/Esther?size=300x300"
        tfExt2.text = "https://robohash.org/Gwendolyn?size=300x300"
        tfExt3.text = "https://robohash.org/Eleanore?size=300x300"
        tfExt4.text = "https://robohash.org/Joana?size=300x300"
    }
    
    // MARK: - Actions
    @IBAction func recurringSaleAction(_ sender: LoadingButton) {
        // Will be available in next releases
        
//        sender.isLoading = true
//
//        let productRecurring = PlatonProductRecurring(id: tfOrderId.text ?? "",
//                                                      amount: Float(tfAmount.text ?? "") ?? 0,
//                                                      description: tfOrderDescription.text ?? "")
//        
//        let recurring = PlatonRecurringWeb(firstTransId: tfFirstTransId.text ?? "",
//                                           token: tfRecurringToken.text ?? "")
//        
//        let additional = PlatonWebAdditional(ext1: tfExt1.text,
//                                             ext2: tfExt2.text,
//                                             ext3: tfExt3.text,
//                                             ext4: tfExt4.text)
//        
//        _ = PlatonWebPayment.recurring.recurringSale(productRecurring: productRecurring,
//                                                     recurring: recurring,
//                                                     additional: additional) { (result) in
//                                                        sender.isLoading = false
//
//                                                        switch result {
//                                                        case .failure(let error):
//                                                            self.showError(error)
//
//                                                        case .success(let result):
//                                                            WebViewController.open(url: result.response?.url, fromConstroller: self)
//                                                        }
//
//        }
        
    }
    
    // MARK: - Additional fucntions
    
}
