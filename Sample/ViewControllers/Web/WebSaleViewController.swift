
import UIKit
import PlatonSDK

class WebSaleViewController: UIViewController {
    
    // MARK: - Properties
    
    var arrProducts = NSMutableArray()
    
    // MARK: - Views
    
    @IBOutlet weak var btnAddItem: UIButton!
    
    @IBOutlet var tfOrderId: UITextField!
    @IBOutlet var tfPayerFirstName: UITextField!
    @IBOutlet var tfPayerLastName: UITextField!
    @IBOutlet var tfPayerAddress: UITextField!
    @IBOutlet var tfPayerCountryCode: UITextField!
    @IBOutlet var tfPayerState: UITextField!
    @IBOutlet var tfPayerCity: UITextField!
    @IBOutlet var tfPayerZip: UITextField!
    @IBOutlet var tfPayerEmail: UITextField!
    @IBOutlet var tfPayerPhone: UITextField!
    @IBOutlet var tfLanguage: UITextField!
    @IBOutlet var tfSuccessURL: UITextField!
    @IBOutlet var tfErrorURL: UITextField!
    @IBOutlet var tfFormID: UITextField!
    @IBOutlet var tfExt1: UITextField!
    @IBOutlet var tfExt2: UITextField!
    @IBOutlet var tfExt3: UITextField!
    @IBOutlet var tfExt4: UITextField!
    @IBOutlet var tfExt5: UITextField!
    @IBOutlet var tfExt6: UITextField!
    @IBOutlet var tfExt7: UITextField!
    @IBOutlet var tfExt8: UITextField!
    @IBOutlet var tfExt9: UITextField!
    @IBOutlet var tfExt10: UITextField!

    @IBOutlet weak var productsScrollView: UIScrollView!
    @IBOutlet weak var productsStackView: UIStackView!
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfOrderId.text = "667"
        
        tfPayerFirstName.text = "Leo"
        tfPayerLastName.text = "Ernser"
        tfPayerAddress.text = "Apt. 282"
        tfPayerCountryCode.text = "BQ"
        tfPayerState.text = "NA"
        tfPayerCity.text = "New Howell borough"
        tfPayerZip.text = "79591"
        tfPayerEmail.text = "ulices@casper.bz"
        tfPayerPhone.text = "(202) 091-2508"
        
        tfLanguage.text = "RU"
        tfSuccessURL.text = "https://www.apple.com"
        tfErrorURL.text = "https://www.google.com.ua"
        
        tfExt1.text = "https://robohash.org/Esther?size=300x300"
        tfExt2.text = "https://robohash.org/Gwendolyn?size=300x300"
        tfExt3.text = "https://robohash.org/Eleanore?size=300x300"
        tfExt4.text = "https://robohash.org/Joana?size=300x300"
        tfExt5.text = "test ext5"
        tfExt6.text = "test ext6"
        tfExt7.text = "test ext7"
        tfExt8.text = "test ext8"
        tfExt9.text = "test ext9"
        tfExt10.text = "test ext10"

        updateProductsButtonTitle()
    }
    
    // MARK: - Actions
    
    @IBAction func addItemAction(_ sender: Any) {
        let newProdcuctView = ProductStackView()
        newProdcuctView.btnRemove.addTarget(self, action: #selector(removeItemAction(_:)), for: .touchUpInside)
        newProdcuctView.tfAmount.text = "\(10 + arrProducts.count)"
        newProdcuctView.tfDescription.text = "Test desctiption of \(arrProducts.count + 1) product"
        newProdcuctView.tfCurrency.text = "UAH"
        newProdcuctView.swSelected.addTarget(self, action: #selector(itemSelectedAction(_:)), for: .valueChanged)
        newProdcuctView.translatesAutoresizingMaskIntoConstraints = false
        
        productsStackView.addArrangedSubview(newProdcuctView)
        arrProducts.add(newProdcuctView)
        
        newProdcuctView.widthAnchor.constraint(equalTo: productsStackView.superview!.widthAnchor, constant: -productsStackView.spacing).isActive = true
        
        view.layoutIfNeeded()
        
        productsScrollView.scrollToBottom(animated: true)
        updateProductsButtonTitle()
        
        UIView.animate(withDuration: arrProducts.count > 1 ? 0 : 0.3, delay: 0, options: .allowUserInteraction, animations: {
            self.productsStackView.superview?.backgroundColor = self.arrProducts.count > 0 ? UIColor.groupTableViewBackground : UIColor.white
        }, completion: nil)
    }
    
    @objc func removeItemAction(_ sender: UIView) {
        guard let productView = sender.superview else {
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            productView.alpha = 0
            self.productsStackView.superview?.backgroundColor = self.arrProducts.count > 1 ? UIColor.groupTableViewBackground : UIColor.white
            self.productsScrollView.contentOffset.x = max(0, self.productsScrollView.contentOffset.x - self.productsScrollView.frame.width)
        }, completion: { (_) in
            self.productsStackView.removeArrangedSubview(productView)
            self.arrProducts.remove(productView)
            productView.removeFromSuperview()
            
            self.updateProductsButtonTitle()
        })
        
    }
    
    @objc func itemSelectedAction(_ sender: UISwitch) {
        for productView in arrProducts as! [ProductStackView] {
            
            if productView.swSelected.isOn && productView.swSelected != sender {
                sender.setOn(false, animated: true)
                
                let alert = UIAlertController(title: "", message: "You can select only one product", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    @IBAction func scheduleAction(_ sender: LoadingButton) {
        guard validateUrl(tfErrorURL.text, tfSuccessURL.text) else {
            return
        }
        
        sender.isLoading = true
        
        var prdouctsSale = [PlatonProductSale]()
        
        for productView in arrProducts as! [ProductStackView] {
            let productSale = PlatonProductSale(isSelected: productView.swSelected.isOn,
                                                isRecurring: productView.swRecurring.isOn,
                                                amount: Float(productView.tfAmount.text ?? "") ?? 0,
                                                currencyCode: productView.tfCurrency.text ?? "",
                                                description: productView.tfDescription.text ?? "")
            prdouctsSale.append(productSale)
        }

        let payerWebSale = PlatonPayerWebSale(firstName: tfPayerFirstName.text,
                                              lastName: tfPayerLastName.text,
                                              address: tfPayerAddress.text,
                                              countryCode: tfPayerCountryCode.text,
                                              state: tfPayerState.text,
                                              city: tfPayerCity.text,
                                              zip: tfPayerZip.text,
                                              email: tfPayerEmail.text,
                                              phone: tfPayerPhone.text)
        
        let additional = PlatonWebSaleAdditional(language: tfLanguage.text,
                                                 errorUrl: tfErrorURL.text,
                                                 formId: tfFormID.text,
                                                 ext1: tfExt1.text,
                                                 ext2: tfExt2.text,
                                                 ext3: tfExt3.text,
                                                 ext4: tfExt4.text,
                                                 ext5: tfExt5.text,
                                                 ext6: tfExt6.text,
                                                 ext7: tfExt7.text,
                                                 ext8: tfExt8.text,
                                                 ext9: tfExt9.text,
                                                 ext10: tfExt10.text)
        
        PlatonWebPayment.sale.sale(productSales: prdouctsSale,
                                       successUrl: tfSuccessURL.text ?? "",
                                       orderId: tfOrderId.text ?? "",
                                       req_token: "Y",
                                       payerWebSale: payerWebSale,
                                       additional: additional) { result, response  in
                                        sender.isLoading = false
                                        
                                        switch result {
                                        case .failure(let error):
                                            self.showError(error)
                                            
                                        case .success(_):
                                            WebViewController.open(url: response?.url, fromConstroller: self)
                                        }
        }
    }
    
    // MARK: - Additional fucntions
    
    func updateProductsButtonTitle() {
        btnAddItem.setTitle("Add Item (\(self.arrProducts.count))", for: .normal)
    }
}
