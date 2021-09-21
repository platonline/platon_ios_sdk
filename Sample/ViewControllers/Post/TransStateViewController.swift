
import UIKit
import PlatonSDK

class TransStateViewController: UIViewController {

    // MARK: - Properties
    // Views
    @IBOutlet var tfTransId: UITextField!
    
    @IBOutlet var lbResponse: UILabel!
    
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfTransId.text = "32918-68712-1083" //"32918-68712-1083" // 1231-3123-asd123-12
    }
    
    // MARK: - Actions

    @IBAction func mainAction(_ sender: LoadingButton) {
        sender.isLoading = true
        view.endEditing(true)
        
        PlatonPostPayment.transState.getState(orderId: tfTransId.text ?? "", completion: { result in
            sender.isLoading = false
            
            switch result {
                case .failure(let error):
                    self.lbResponse.text = "\(error)"
                default:
                    self.lbResponse.text = "\(result.responseObject!)"
            }
        })
    }
}
