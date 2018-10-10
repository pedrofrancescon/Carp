//
//  ResultsVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 02/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class ResultsVC: UIViewController {
    
    let resultsView: ResultsView
    
    private let ride: Ride?
    
    var cars: [Car]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = resultsView
        
        resultsView.tableView.dataSource = self
        resultsView.tableView.delegate = self
        
        guard let ride = ride else { return }
        
        _ = RideRequestsManager().findMatches( ride,
            onUpdate: { cars in
                self.cars = self.cars.filter({ car in
                    return !cars.contains(where: { _car in
                        return _car.owner.id == car.owner.id
                    })
                })
                self.cars.append(contentsOf: cars)
                self.resultsView.tableView.reloadData()
                    }
        )
        
    }
    
    init(ride: Ride) {
        self.ride = ride
        self.cars = []
        resultsView = ResultsView(frame: .zero)
        super.init(nibName: "ResultsVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ResultsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let _ = cell as! ResultsCell
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell") as? ResultsCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "ResultsCell", bundle: nil), forCellReuseIdentifier: "resultsCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell") as? ResultsCell
        }
        
        cell?.originDistanceLabel.text = "\(Int.random(in: ClosedRange<Int>(uncheckedBounds: (lower: 300, upper: 600)))) m"
        cell?.destinyDistanceLabel.text = "\(Int.random(in: ClosedRange<Int>(uncheckedBounds: (lower: 200, upper: 700)))) m"
        cell?.timeLabel.text = "14h24"
        
        cell?.priceLabel.text = "R$ \(cars[indexPath.row].price)"
        
        cell?.usersStackView.removeAllArrangedSubviews()
        
        cell?.usersStackView.add(UIImage(named: "Uber")!)
        cell?.usersStackView.add(UIImage(named: "Cabify")!)
        
        cell?.usersStackView.add("+2")
        
        return cell!
    }
    
}
