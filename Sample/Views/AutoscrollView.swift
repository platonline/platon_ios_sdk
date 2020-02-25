import UIKit

class AutoscrollView: UIScrollView {

    // MARK: Properties
    
    fileprivate var firstInsets = UIEdgeInsets.zero
    
    var pading: CGFloat = 16
    var keyboardFrame: CGRect?
    var keyboardIsHidden = true
    var didEndEditing: (() -> Swift.Void)? = nil
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        keyboardDismissMode = .onDrag
        
        firstInsets = contentInset

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(sender: Notification) {
        keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
       
        updateContentOffset(responserView: self.firstResponder)
    }
    
    func updateContentOffset(responserView: UIView?) {
        guard let firstResponder = responserView, let keyboardFrame = keyboardFrame else {
            return
        }
        
        if (keyboardIsHidden) {
            firstInsets = contentInset
        }
        
        keyboardIsHidden = false
        
        let firstResponderMaxY = firstResponder.originOfScreen.y + firstResponder.frame.size.height
        let delta = firstResponderMaxY - keyboardFrame.minY + pading
        
        if (delta > 0) {
            DispatchQueue.main.async {
                self.contentInset.bottom += delta
                self.setContentOffset(CGPoint(x: self.contentOffset.x,
                                              y: self.contentOffset.y + delta), animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide() {
        contentInset = firstInsets;
        keyboardIsHidden = true;
        keyboardFrame = nil
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        endEditing(true)
        didEndEditing?()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if hitView is UITextInput {
            updateContentOffset(responserView: hitView)
        }
        
        return hitView
    }
    
}

extension UIView {
    
    var firstResponder: UIView? {
        guard !isFirstResponder else {
            return self
        }
        
        for subview in subviews {
            
            if let responderView = subview.firstResponder {
                return responderView;
            }
            
        }
        
        return nil
    }
    
    var originOfScreen: CGPoint {
        var origin = UIView.init(frame: UIScreen.main.bounds).convert(CGPoint.zero, to: self)
        origin.x *= -1;
        origin.y *= -1;
        
        return origin;
    }
}

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        setContentOffset(CGPoint(x: max(0, self.contentSize.width - self.frame.width),
                                 y: max(0, self.contentSize.height - self.frame.height)), animated: animated)
    }
}
