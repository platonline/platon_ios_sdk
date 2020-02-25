
import UIKit

class LoadingButton: UIButton {
    
    var loadingView: UIActivityIndicatorView?
    var isLoading: Bool = false {
        didSet {
            
            if isLoading {
                loadingView?.startAnimating()
                self.titleLabel?.alpha = 0
                
            } else {
                loadingView?.stopAnimating()
                self.titleLabel?.alpha = 1
            }
            
            self.isUserInteractionEnabled = !isLoading
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        customInit()
    }
    
    func customInit() {
        loadingView = UIActivityIndicatorView(style: .gray)
        loadingView?.hidesWhenStopped = true
        loadingView?.stopAnimating()
        loadingView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingView!)
        
        NSLayoutConstraint.activate([
            loadingView!.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView!.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
    }

}
