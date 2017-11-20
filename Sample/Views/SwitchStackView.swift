
import UIKit

class SwitchStackView: UIStackView {

    // MARK: Properties
    
    var lbTitle: UILabel!
    var swTitle: UISwitch!
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    convenience init(title: String?) {
        self.init(frame: CGRect.zero)
        
        lbTitle.text = title
    }
    
    func customInit() {
        axis = .horizontal
        alignment = .fill
        distribution = .fill
        spacing = 8
        clipsToBounds = false
//        layer.masksToBounds = false
        
        lbTitle = UILabel()
        lbTitle.font = UIFont.systemFont(ofSize: 14)
        
        swTitle = UISwitch()
        swTitle.isOn = false
        
        addArrangedSubview(lbTitle)
        addArrangedSubview(swTitle)
    }

}
