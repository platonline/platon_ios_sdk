
import UIKit

class CustomSegmentControll: UISegmentedControl {
    
    @IBInspectable var numberOfLines: Int = 1 {
        didSet {
            updateLabels()
        }
    }

    override init(items: [Any]?) {
        super.init(items: items)
        
        customInit()
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
        updateLabels()
    }
    
    func updateLabels() {
        for subview in subviews {
            for subsubviews in subview.subviews {
                (subsubviews as? UILabel)?.numberOfLines = numberOfLines
            }
        }
    }

}
