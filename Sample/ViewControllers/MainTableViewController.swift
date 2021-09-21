import UIKit
import PlatonSDK

class MainTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var dataSorcePost = ["SALE",
                         "CAPTURE",
                         "CREDIT_VOID",
                         "GET_TRANS_STATUS",
                         "GET_TRANS_DETAILS",
                         "RECURRING_SALE",
                         "SCHEDULE",
                         "DESCHEDULE",
                         "APPLEPAY",
                         "GET_TRANS_STATE"
    ]
    
    var dataSourceWeb = ["WEB_SALE",
                         "WEB_CARD_VERIFY",
                         "WEB_C2A",
                         "WEB_C2A_ONE_CLICK",
                         "WEB_ONE_CLICK_SALE",
                         "WEB_TOKEN_SALE",
                         
                         // Will be available in next releases
//                         "WEB_RECURRING_SALE",
//                         "WEB_SCHEDULE",
//                         "WEB_DESCHEDULE"
    ]
    
    var dataSource = [String]()
    
    // Views
    @IBOutlet weak var scSDKType: UISegmentedControl!
    
    // Constraints
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sdkTypeAction(scSDKType)
    }
    
    func webPaymentSDKConfig() {
        
        PlatonSDK.config(credendials: PlatonCredentials(clientKey: "FY4WVLX8BK",
                                                        clientPass: "fJTHb9NcNwBqGBrvphabqWT6ZAVdBhjT",
                                                        paymentUrl: "https://secure.platononline.com/payment/auth",
                                                        termUrl3Ds: "https://platon.ua"))
        self.dataSource = self.dataSourceWeb
    }
    
    func postPaymentSDKConfig() {
        PlatonSDK.config(credendials: PlatonCredentials(clientKey: "FY4WVLX8BK",
                                                        clientPass: "fJTHb9NcNwBqGBrvphabqWT6ZAVdBhjT",
                                                        paymentUrl: "https://secure.platononline.com/post",
                                                        termUrl3Ds: "https://platon.ua",
                                                        stateUrl: "https://secure.platononline.com/post-unq/"))
        self.dataSource = self.dataSorcePost
    }
    
    // MARK: - Actions
    
    @IBAction func sdkTypeAction(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            webPaymentSDKConfig()
        } else {
            postPaymentSDKConfig()
        }
        
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = dataSource == dataSorcePost ? "Post" : "Web"
        let controller = dataSource[indexPath.row]
        
        navigationController?.pushViewController(UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: controller), animated: true)
    }

}

extension UIViewController {
    func showError(_ error: PlatonError) {
        let alert = UIAlertController(title: "", message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateUrl(_ url: String?...) -> Bool {
        
        for strUrl in url {
            
            if let unwStrUlr = strUrl {
                
                if !unwStrUlr.hasPrefix("http") &&
                    !unwStrUlr.hasPrefix("https") &&
                    !unwStrUlr.hasPrefix("ftp") &&
                    !unwStrUlr.hasPrefix("sftp") {
                    
                    let alert = UIAlertController(title: "", message: "Url should begin from: http, https, ftp or sftp", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    return false
                }

            }
        }
        
        return true
    }
}
