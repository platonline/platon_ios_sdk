
import UIKit
import Alamofire

class WebViewController: UIViewController {

    var webView: UIWebView!
   
    var url: URL? {
        didSet {
            loadUrl(url)
        }
    }
    
    var request: URLRequest? {
        didSet {
            loadRequest(request)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = UIWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.keyboardDisplayRequiresUserAction = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
        loadUrl(url)
        loadRequest(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Loading
    
    func loadUrl(_ url: URL?) {
        guard let unwUrl = url else {
            return
        }
        
        self.loadRequest(URLRequest(url: unwUrl))
    }
    
    func loadRequest(_ request: URLRequest?) {
        guard let unwRequest = request else {
            return
        }
        
        webView?.loadRequest(unwRequest)
    }

}

extension WebViewController {
    
    static func open(url: URL?, fromConstroller controller: UIViewController?, title: String? = "PlatonSDK Eample") {
        let webVC = WebViewController()
        webVC.title = title
        webVC.url = url
        controller?.navigationController?.pushViewController(webVC, animated: true)
    }
    
    static func open(request: URLRequest?, fromConstroller controller: UIViewController?, title: String? = "PlatonSDK Eample") {
        let webVC = WebViewController()
        webVC.title = title
        webVC.request = request
        controller?.navigationController?.pushViewController(webVC, animated: true)
    }
    
}
