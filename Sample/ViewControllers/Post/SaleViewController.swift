
import UIKit
import PlatonSDK

class SaleViewController: UIViewController {
    
    // MARK: - Properties
    // Views
    @IBOutlet var tfOrderId: UITextField!
    @IBOutlet var tfOrderAmount: UITextField!
    @IBOutlet var tfOrderDescription: UITextField!
    @IBOutlet var tfOrderCurrency: UITextField!
    
    @IBOutlet var tfPayerFirstName: UITextField!
    @IBOutlet var tfPayerLastName: UITextField!
    @IBOutlet var tfPayerAddress: UITextField!
    @IBOutlet var tfPayerCountryCode: UITextField!
    @IBOutlet var tfPayerState: UITextField!
    @IBOutlet var tfPayerCity: UITextField!
    @IBOutlet var tfPayerZip: UITextField!
    @IBOutlet var tfPayerEmail: UITextField!
    @IBOutlet var tfPayerPhone: UITextField!
    @IBOutlet var tfPayerIpAddress: UITextField!
    
    @IBOutlet var scSaleType: CustomSegmentControll!
    
    @IBOutlet var swAsyncSale: UISwitch!
    @IBOutlet var swRecurringSale: UISwitch!
    @IBOutlet var tfChanelId: UITextField!
    
    @IBOutlet var lbResponse: UILabel!
    
    @IBOutlet var btnAuth: UIButton!
    @IBOutlet var btnSale: UIButton!
    
    // Constraints
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfOrderId.text = "667"
        tfOrderAmount.text = "20"
        tfOrderDescription.text = "Accusantium est aut rem eum. Repellat consequatur nesciunt nihil. Autem culpa omnis."
        tfOrderCurrency.text = "UAH"
        
        tfPayerFirstName.text = "Leo"
        tfPayerLastName.text = "Ernser"
        tfPayerAddress.text = "Apt. 282"
        tfPayerCountryCode.text = "BQ"
        tfPayerState.text = "NA"
        tfPayerCity.text = "New Howell borough"
        tfPayerZip.text = "79591"
        tfPayerEmail.text = "ulices@casper.bz"
        tfPayerPhone.text = "(202) 091-2508"
        tfPayerIpAddress.text = "47.18.163.249"
        
        //        tfChanelId.text = "6b3e5d85-0b8f-468c-9478-21d6fe99d5f"
        
        swAsyncSale.isOn = false
        swRecurringSale.isOn = false
    }
    
    // MARK: - Actions
    
    @IBAction func action(_ sender: LoadingButton) {
        sender.isLoading = true
        view.endEditing(true)
        
        let order = PlatonOrder(amount: Float(tfOrderAmount.text ?? "") ?? 0,
                                id: tfOrderId.text ?? "",
                                orderDescription: tfOrderDescription.text ?? "",
                                currencyCode: tfOrderCurrency.text ?? "")
        
        let card = PlatonCard(test: Test(rawValue: scSaleType.selectedSegmentIndex))
        
        let payer = PlatonPayer(firstName: tfPayerFirstName.text ?? "",
                                lastName: tfPayerLastName.text ?? "",
                                address: tfPayerAddress.text ?? "",
                                countryCode: tfPayerCountryCode.text ?? "",
                                state: tfPayerState.text ?? "",
                                city: tfPayerCity.text ?? "",
                                zip: tfPayerZip.text ?? "",
                                email: tfPayerEmail.text ?? "",
                                phone: tfPayerPhone.text ?? "",
                                ipAddress: tfPayerIpAddress.text ?? "")
        
        let saleOption = PlatonSaleAdditional(async: swAsyncSale.isOn ? .yes : nil,
                                              channelId: tfChanelId.text,
                                              recurringInit: swRecurringSale.isOn ? .yes : nil)
        
        let auth = sender == btnAuth ? PlatonOption.yes : nil
        
        PlatonPostPayment.sale.sale(order: order,
                                    card: card,
                                    payer: payer,
                                    saleOption: saleOption,
                                    auth: auth) { (result) in
                                        sender.isLoading = false
                                        
                                        let basicSale = result.responseObject
                                        let transId = basicSale?.transId
                                        
                                        switch result {
                                        case .failure(let error):
                                            self.lbResponse.text = "\(error)"
                                            
                                        case .recurringInit(let saleRecurring):
                                            UserDefaults.standard.setValue(saleRecurring.recurringToken, forKeyPath: PlatonMethodProperty.recurringToken.rawValue)
                                            
                                        case .secure3d(let sale3ds):
                                            self.confirm3ds(sale3ds)
                                            
                                        default:
                                            break
                                        }
                                        
                                        if let unwSale = basicSale {
                                            self.lbResponse.text = "\(String(describing: unwSale))"
                                        }
                                        
                                        UserDefaults.standard.setValue(transId, forKeyPath: PlatonMethodProperty.transId.rawValue)
                                        UserDefaults.standard.setValue(order.id, forKey: PlatonMethodProperty.orderId.rawValue)
                                        UserDefaults.standard.synchronize()
                                        
        }
        
    }
    
    func confirm3ds(_ sale3ds: PlatonSale3DS) {
        guard let request = sale3ds.submit3dsDataRequest else {
            return
        }
        
        WebViewController.open(request: request.request, fromConstroller: self)
    }
    
}
