//
//  AlertView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 25/10/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class AlertView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var priceInputContainerView: UIView!
    @IBOutlet weak var buttonContainerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var priceInputField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var priceEstimate: PriceEstimate?
    
    init(priceEstimate: PriceEstimate) {
        self.priceEstimate = priceEstimate
        
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = .clear
        
        titleLabel.textColor = UIColor(color: .mainGreen)
        
        let normalTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 15.0) as Any
        ]
        
        let boldTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 15.0) as Any,
            //NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternSolid as Any
        ]
        
        let buttonTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 16.0) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white as Any
        ]
        
        if let _ = priceEstimate {
            
            titleContainerView.isHidden = false
            textContainerView.isHidden = false
            priceInputContainerView.isHidden = false
            buttonContainerView.isHidden = false
            
            let buttonString = NSMutableAttributedString(string: "Criar meu carro!", attributes: buttonTextAttributes)
            
            doneButton.setAttributedTitle(buttonString, for: .normal)
            
        } else {
            
            titleContainerView.isHidden = false
            textContainerView.isHidden = false
            priceInputContainerView.isHidden = true
            buttonContainerView.isHidden = false
            
            titleLabel.text = "Deseja criar um carro?"
            
            let firstPart = NSMutableAttributedString(string: "Quando você cria o seu próprio carro o ponto e a hora de partida são exatamente aqueles que você já escolheu!\n\nEntretanto, a responsabilidade de ", attributes: normalTextAttributes)
            
            let secondPart = NSMutableAttributedString(string: "chamar o carro no horário e pagar estará por sua conta.\n\n", attributes: boldTextAttributes)
            
            let thirdPart = NSMutableAttributedString(string: "Não se preocupe, assim que chegar o horário da corrida o nosso aplicativo cobrará a parte de cada um e você não sairá no prejuizo!", attributes: normalTextAttributes)
            
            let combination = NSMutableAttributedString()
            
            combination.append(firstPart)
            combination.append(secondPart)
            combination.append(thirdPart)
            
            textView.attributedText = combination
            
            let buttonString = NSMutableAttributedString(string: "Entendi, deixa comigo!", attributes: buttonTextAttributes)
            
            doneButton.setAttributedTitle(buttonString, for: .normal)
            doneButton.backgroundColor = UIColor(color: .mainGreen)
            
        }
        
    }

}
