//
//  CustomSegmentedControl.swift
//  TV
//
//  Created by Артем Соловьев on 10.04.2022.
//

import UIKit

protocol CustomSegmentedControlDelegate: AnyObject {
    func change(to index:Int)
}

final class CustomSegmentedControl: UIView {
    private var buttonTitles:[String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    
    private var textColor = UIColor(hex: Constants.SystemColor.grey)
    private var selectorViewColor = UIColor(hex: Constants.SystemColor.blue)
    private var selectorTextColor = UIColor(hex: Constants.SystemColor.white)
    
    weak var delegate:CustomSegmentedControlDelegate?
    
    public private(set) var selectedIndex : Int = 0
    
    convenience init(frame:CGRect,buttonTitle:[String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.updateView()
    }
    
    private func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    private func setIndex(index:Int) {
        self.buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        self.selectedIndex = index
        button.setTitleColor(self.selectorTextColor, for: .normal)
        let selectorPosition = frame.width/CGFloat(self.buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }
    
    @objc func buttonAction(sender:UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
}

//MARK: - Configuration View

extension CustomSegmentedControl {
    private func updateView() {
        self.createButton()
        self.configSelectorView()
        self.configStackView()
    }
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        self.selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: -2))
        self.selectorView.backgroundColor = self.selectorViewColor
        addSubview(self.selectorView)
    }
    
    private func createButton() {
        self.buttons = [UIButton]()
        self.buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
        self.buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    
}
