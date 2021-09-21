
import UIKit
import PlatonSDK
import PassKit

private let clientKey = "test" // !!! Set real value
private let termsUrl3ds = "https://www.google.com/" // !!! Set real value
private let merchantIdentifier = "merchant.platon.ua" // !!! Set real value
private let ipAddress = "111.111.111.111" // !!! Set real value

class ApplePayViewController: UIViewController {
    
    // MARK: - Properties
    // Views
    @IBOutlet var tfOrderId: UITextField!
    @IBOutlet var tfOrderDescription: UITextField!
    @IBOutlet var tfPartialAmount: UITextField!
    @IBOutlet var tfCapturreButton: LoadingButton!

    @IBOutlet var lbResponse: UILabel!


    var paymentAuthorizationViewController: PKPaymentAuthorizationViewController?
    var paymentRequest: PKPaymentRequest?
    // Constraints
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfOrderId.text = "2353346"
        tfOrderDescription.text = "Test order"
        tfPartialAmount.text = "1"

        setupApplePay()
    }
    
    // MARK: - Privatte
    @objc
    private func tryApplePay() {
        present(paymentAuthorizationViewController!, animated: true, completion: nil)
    }

    private func setupApplePay() {
        if PKPaymentAuthorizationViewController.canMakePayments() {
            let applePayButton = PKPaymentButton.init(paymentButtonType: .plain, paymentButtonStyle: .black)
            applePayButton.addTarget(self, action: #selector(tryApplePay), for: .touchUpInside)
            applePayButton.frame = CGRect(x: view.bounds.width / 2 - 70, y: 0, width: 140, height: 30)
            tfCapturreButton.addSubview(applePayButton)
            tfCapturreButton.setTitle(nil, for: .normal)
            paymentRequest = PKPaymentRequest()
            paymentRequest?.currencyCode = "UAH"
            paymentRequest?.countryCode = "UA"
            paymentRequest?.merchantIdentifier = merchantIdentifier
            paymentRequest?.paymentSummaryItems = [PKPaymentSummaryItem(label: "Test", amount: NSDecimalNumber(string: tfPartialAmount.text))]
            paymentRequest?.supportedNetworks = [.visa, .masterCard, .chinaUnionPay]
            paymentRequest?.merchantCapabilities = .capability3DS
            paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest!)
            paymentAuthorizationViewController?.delegate = self
        }
    }

    private func proceed(payment: PKPayment, successHandler success: @escaping () -> Void, failureHandler failure: @escaping (PlatonError?) -> Void) {
        let contact = payment.billingContact ?? payment.shippingContact ?? {let contact = PKContact()
                contact.emailAddress = "test@user.com"
                return contact}()
        let address = contact.postalAddress ?? CNPostalAddress()
        let name = contact.name ?? PersonNameComponents()
        guard let tokenData = try? JSONEncoder().encode(payment.token),
            let token = String(data: tokenData, encoding: .utf8) else {
            failure(nil)
            return
        }
        let payer = PlatonPayerApplePay(firstName: name.givenName ?? "",
                                        lastName: name.familyName ?? "",
                                        midleName: name.middleName ?? "",
                                        birthday: "",
                                        address: address.street,
                                        address2: address.city,
                                        countryCode: address.isoCountryCode,
                                        state: address.state,
                                        city: address.city,
                                        zip: address.postalCode,
                                        email: contact.emailAddress ?? "",
                                        phone: contact.phoneNumber?.stringValue ?? "",
                                        ipAddress: ipAddress)
        PlatonPostPayment.applePay.pay(payer: payer,
                                       paymentToken: token,
                                       clientKey: clientKey,
                                       channelId: nil,
                                       orderId: tfOrderId.text ?? "",
                                       orderDescription: tfOrderDescription.text ?? "",
                                       amount: Float(tfPartialAmount.text ?? "") ?? 0,
                                       termsUrl3ds: termsUrl3ds) { [unowned self] (result) in
            switch result {
                case .failure(let error):
                    self.lbResponse.text = "\(error)"
                    failure(error)
                case .secure3d(let sale3ds):
                    self.confirm3ds(sale3ds)
                    self.lbResponse.text = "\(result.responseObject!)"
                    success()
                default:
                    self.lbResponse.text = "\(result.responseObject!)"
                    success()
            }
        }
    }

    private func confirm3ds(_ sale3ds: PlatonApplePay3DS) {
        guard let request = sale3ds.submit3dsDataRequest else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            WebViewController.open(request: request, fromConstroller: self)
        }
    }

}

extension ApplePayViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    @available(iOS 11.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        proceed(payment: payment, successHandler: {
            completion(.init(status: .success, errors: nil))
        }) { (error) in
            completion(.init(status: .failure, errors: nil))
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                controller.dismiss(animated: true, completion: nil)
            }
        }
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        proceed(payment: payment, successHandler: {
            completion(.success)
        }) { (error) in
            completion(.failure)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                controller.dismiss(animated: true, completion: nil)
            }
        }
    }
}
