//
//  AlertView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 25/10/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

enum AlertViewKind {
    case disclaimer,priceInput
}

class AlertView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var priceInputContainerView: UIView!
    @IBOutlet weak var buttonContainerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var priceInputField: LineTextField!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    
    var priceEstimate: PriceEstimate?
    
    let kind: AlertViewKind
    
    var parentVC: AlertVC?
    
    init(priceEstimate: PriceEstimate) {
        self.priceEstimate = priceEstimate
        self.kind = .priceInput
        
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    init() {
        self.kind = .disclaimer
        
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.kind = .disclaimer
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        textView.isScrollEnabled = false
    }
    
    override func layoutSubviews() {
        
        contentView.backgroundColor = .clear
        titleLabel.textColor = UIColor(color: .mainGreen)
        
        addShadow(blur: 10, opacity: 0.5)
        
        let normalTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 15.0) as Any
        ]
        
        let boldTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 15.0) as Any,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.styleSingle.rawValue as Any
        ]
        
        let lineBreakTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 8.0) as Any,
        ]
        
        let buttonTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 16.0) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white as Any
        ]
        
        let lineBreak = NSMutableAttributedString(string: "\n\n", attributes: lineBreakTextAttributes)
        
        let combination = NSMutableAttributedString()
        
        switch kind {
        case .disclaimer:
            
            titleContainerView.isHidden = false
            textContainerView.isHidden = false
            priceInputContainerView.isHidden = true
            buttonContainerView.isHidden = false
            
            titleLabel.text = "Deseja criar um carro?"
            
            let firstPart = NSMutableAttributedString(string: "Quando você cria o seu próprio carro, o ponto e a hora de partida são exatamente aqueles que você já escolheu!", attributes: normalTextAttributes)
            
            let secondPart = NSMutableAttributedString(string: "Entretanto, a responsabilidade de ", attributes: normalTextAttributes)
            
            let thirdPart = NSMutableAttributedString(string: "chamar o carro no horário e pagar estará por sua conta.", attributes: boldTextAttributes)
            
            let fourthPart = NSMutableAttributedString(string: "Não se preocupe, assim que chegar o horário da corrida o nosso aplicativo cobrará a parte de cada um e você não sairá no prejuizo!", attributes: normalTextAttributes)
            
            combination.append(firstPart)
            combination.append(lineBreak)
            combination.append(secondPart)
            combination.append(thirdPart)
            combination.append(lineBreak)
            combination.append(fourthPart)
            
            textView.attributedText = combination
            
            let buttonString = NSMutableAttributedString(string: "Entendi, deixa comigo!", attributes: buttonTextAttributes)
            
            doneButton.setAttributedTitle(buttonString, for: .normal)
            
        case .priceInput:
            
            titleContainerView.isHidden = false
            textContainerView.isHidden = false
            priceInputContainerView.isHidden = false
            buttonContainerView.isHidden = false
            
            priceInputField.setPlaceholderText(with: priceEstimate!.upperPrice)
            
            titleLabel.text = "Quanto vai custar?"
            
            let firstPart = NSMutableAttributedString(string: "O preço da corrida quem define é você!", attributes: normalTextAttributes)
            
            let secondPart = NSMutableAttributedString(string: "O valor será automaticamente distribuído de forma igual para todos os passageiros no carro.", attributes: normalTextAttributes)
            
            combination.append(firstPart)
            combination.append(lineBreak)
            combination.append(secondPart)
            
            textView.attributedText = combination
            
            let buttonString = NSMutableAttributedString(string: "Criar meu carro!", attributes: buttonTextAttributes)
            
            doneButton.setAttributedTitle(buttonString, for: .normal)
        }
        
        doneButton.backgroundColor = UIColor(color: .mainGreen)
        
        // some fucked up messy shit code to fix apple bugs
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        
        var b = textView.bounds
        let h = textView.sizeThatFits(CGSize(
            width: textView.bounds.size.width,
            height: CGFloat.greatestFiniteMagnitude)
            ).height
        b.size.height = h
        textView.bounds = b
        
        textViewHeight.constant = textView.intrinsicContentSize.height
        
        textView.layoutIfNeeded()
        
    }
    
    @IBAction func didPressDoneButton(_ sender: Any) {
        parentVC?.doneButtonPressed()
    }
    
    @IBAction func didPressExitButton(_ sender: Any) {
        parentVC?.exitButtonPressed()
    }
    
    

}
