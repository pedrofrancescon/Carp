//
//  CarVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 01/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class CarVC: UIViewController {
    
    @IBOutlet weak var containerCarCellView: UIView!
    @IBOutlet weak var containerChatView: UIView!
    
    @IBOutlet weak var carCellViewHeight: NSLayoutConstraint!
    
    private let car: Car
    private let carCellView: CarCellView
    private let chatVC: ChatVC
    
    var popUpView: PopUpView? {
        get {
            guard let popUp = self.view as? PopUpView else {
                return nil
            }
            return popUp
        }
    }
    
    init(car: Car) {
        self.car = car
        self.carCellView = CarCellView()
        self.chatVC = ChatVC(car: car)
        super.init(nibName: "CarVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatVC.parentVC = self
        
        DispatchQueue.main.async {
            self.carCellViewHeight.constant = ResultsCell.cellHeight
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        carCellView.carTableView.delegate = self
        carCellView.carTableView.dataSource = self
        
        containerCarCellView.addSubview(carCellView)
        carCellView.frame = containerCarCellView.bounds
        
        addChild(chatVC)
        containerChatView.addSubview(chatVC.view)
        chatVC.view.frame = containerChatView.bounds
    }
}

extension CarVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ResultsCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell") as? ResultsCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "ResultsCell", bundle: nil), forCellReuseIdentifier: "resultsCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell") as? ResultsCell
        }
        
        cell?.originDistanceLabel.text = "\(Int.random(in: ClosedRange<Int>(uncheckedBounds: (lower: 300, upper: 600)))) m"
        cell?.destinationDistanceLabel.text = "\(Int.random(in: ClosedRange<Int>(uncheckedBounds: (lower: 200, upper: 700)))) m"
        cell?.timeLabel.text = "14h24"
        
        cell?.priceLabel.text = "R$ \(car.price)"
        
        cell?.usersStackView.removeAllArrangedSubviews()
        
        cell?.usersStackView.add(UIImage(named: "Uber")!)
        cell?.usersStackView.add(UIImage(named: "Cabify")!)
        
        cell?.usersStackView.add("+2")
        
        return cell!
    }
    
}
