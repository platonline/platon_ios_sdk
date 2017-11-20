
import UIKit

class ProductStackView: UIStackView {

    // MARK: Properties
    
    var tfAmount: UITextField!
    var tfDescription: UITextField!
    var tfCurrency: UITextField!
    var selectedView: SwitchStackView!
    var recurringView: SwitchStackView!
    var btnRemove: UIButton!
    
    var swSelected: UISwitch {
        return selectedView.swTitle
    }
    
    var swRecurring: UISwitch {
        return recurringView.swTitle
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    func customInit() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 8
        
        tfAmount = UITextField()
        tfAmount.placeholder = "Product Amount"
        tfAmount.clearButtonMode = .always
        tfAmount.borderStyle = .roundedRect
        tfAmount.font = UIFont.systemFont(ofSize: 14)
        addArrangedSubview(tfAmount)
        
        tfDescription = UITextField()
        tfDescription.placeholder = "Product Description"
        tfDescription.clearButtonMode = .always
        tfDescription.borderStyle = .roundedRect
        tfDescription.font = UIFont.systemFont(ofSize: 14)
        addArrangedSubview(tfDescription)
        
        tfCurrency = UITextField()
        tfCurrency.placeholder = "Product Currency"
        tfCurrency.clearButtonMode = .always
        tfCurrency.borderStyle = .roundedRect
        tfCurrency.font = UIFont.systemFont(ofSize: 14)
        addArrangedSubview(tfCurrency)
        
        selectedView = SwitchStackView(title: "Selected")
        addArrangedSubview(selectedView)
        
        recurringView = SwitchStackView(title: "Recurring")
        addArrangedSubview(recurringView)
        
        btnRemove = UIButton(type: .system)
        btnRemove.setTitle("Remove", for: .normal)
        addArrangedSubview(btnRemove)
    }

}
