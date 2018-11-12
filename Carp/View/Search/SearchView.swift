//
//  SearchView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

import UIKit

class SearchView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextBtnLabel: UILabel!
    
    var delegate: SearchViewDelegate?
    
    private static var isFirst: Bool = true
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(self.didTapNextButton))
        return recognizer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    private func comminInit() {
        Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        if SearchView.isFirst {
            iconLabel.font = UIFont(name: "FontAwesome5FreeSolid", size: 12)
            iconLabel.text = "\u{f3c5}"
            SearchView.isFirst = false
        } else {
             iconLabel.font = UIFont(name: "FontAwesome5FreeSolid", size: 8)
            iconLabel.text = "\u{f111}"
        }
        
        iconLabel.textColor = UIColor.darkGreyText
        nextBtnLabel.text = "\u{f054}"
        
        nextBtnLabel.textColor = UIColor.green
        textField.textColor = UIColor.darkGreyText
        
        nextBtnLabel.addGestureRecognizer(tapRecognizer)
        
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .sentences
        
        addShadow(blur: 10)
        
    }
    
    private var timeoutInSeconds: TimeInterval {
        return 0.5
    }
    
    private var idleTimer: Timer?
    
    private func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }
        
        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds,
                                         target: self,
                                         selector: #selector(timeHasExceeded),
                                         userInfo: nil,
                                         repeats: false
        )
    }
    
    @objc private func timeHasExceeded() {
        delegate?.searchFieldDidChange(self, newText: textField.text!)
    }
    
    @IBAction func didChangeTextField(_ sender: Any) {
        self.resetIdleTimer()
    }
    
    @IBAction func primaryActionTriggered(_ sender: Any) {
        delegate?.primaryActionTriggered(self)
    }
    
    @objc func didTapNextButton() {
        delegate?.didTapNextButton()
    }
    
    func resetField() {
        textField.text = ""
        
    }
    
    func selectTextField() {
        textField.becomeFirstResponder()
    }
    
}

protocol SearchViewDelegate: class {
    func searchFieldDidChange(_ view: UIView, newText: String)
    func primaryActionTriggered(_ view: UIView)
    func didTapNextButton()
}
