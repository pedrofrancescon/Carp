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
        
        iconLabel.text = "\u{f3c5}"
        nextBtnLabel.text = "\u{f054}"
        
        nextBtnLabel.textColor = UIColor(color: .green)
        
        nextBtnLabel.addGestureRecognizer(tapRecognizer)
        
        textField.borderStyle = .none
        
    }
    
    @IBAction func didChangeTextField(_ sender: Any) {
        guard let delegate = delegate else { return }
        delegate.searchFieldDidChange(self, newText: textField.text!)
    }
    
    @IBAction func primaryActionTriggered(_ sender: Any) {
        delegate?.primaryActionTriggered(self)
    }
    
    @objc func didTapNextButton() {
        delegate?.didTapNextButton()
    }
    
}

protocol SearchViewDelegate: class {
    func searchFieldDidChange(_ view: UIView, newText: String)
    func primaryActionTriggered(_ view: UIView)
    func didTapNextButton()
}
