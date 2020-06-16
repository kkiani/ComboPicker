#if !os(macOS)
import UIKit

open class ComboPickerView: UITextField,UITextFieldDelegate {
    
    // MARK: - Global Variables
    public var dataSource = [String](){
        didSet{
            if dataSource.count > 0{
                selectItem(0)
            }
        }
    }
    private var picker:UIPickerView = UIPickerView(frame: CGRect.zero)
    private let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
    var Done:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
    var titleLabel:UILabel = UILabel()
    
    fileprivate func defualts() {
        self.inputView = picker
        self.tintColor = UIColor.clear

        picker.delegate = self
        picker.dataSource = self
    
        accessoryView.addSubview(titleLabel)
        accessoryView.addSubview(Done)
        
        accessoryView.backgroundColor = UIColor.groupTableViewBackground
        
        
        Done.setTitle("Done", for: UIControl.State.normal)
        Done.sizeToFit()
        Done.addTarget(self, action: #selector(Done_tapped(_:)), for: UIControl.Event.touchUpInside)
        NSLayoutConstraint.activate([
            Done.widthAnchor.constraint(equalToConstant: 44),
            Done.trailingAnchor.constraint(equalTo: Done.superview!.trailingAnchor, constant: -16),
            Done.topAnchor.constraint(equalTo: Done.superview!.topAnchor, constant: 0),
            Done.bottomAnchor.constraint(equalTo: Done.superview!.bottomAnchor, constant: 0)
            ])
        
        Done.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.darkGray
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleLabel.superview!.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: Done.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: titleLabel.superview!.topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: titleLabel.superview!.bottomAnchor, constant: 0)
            ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.inputAccessoryView = accessoryView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defualts()
    }
    
    required public init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        defualts()
    }
    
    @objc func Done_tapped(_ sender:Any){
        self.resignFirstResponder()
        sendActions(for: .editingDidEnd)
    }
}

extension ComboPickerView{
    public func selectItem(_ index: Int){
        guard index < dataSource.count else{return}
        text = dataSource[index]
    }
    
    public func selectedItem() -> Int?{
        guard let text = self.text else{return nil}
        return dataSource.firstIndex(of: text)
    }
}

// MARK: - UIPickerView Delegate & DataSource
extension ComboPickerView: UIPickerViewDelegate, UIPickerViewDataSource{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return dataSource[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard dataSource.count > row else{ return }
        self.text = dataSource[row]
        self.sendActions(for: .valueChanged)
    }
}
#endif
