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
    
    //private let ride: Ride?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = resultsView
        
        resultsView.tableView.dataSource = self
        resultsView.tableView.delegate = self
        
    }
    
    init() {
        resultsView = ResultsView(frame: .zero)
        super.init(nibName: "ResultsVC", bundle: nil)
    }
    
    init(ride: Ride) {
        //self.ride = ride
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentCell = cell as! ResultsCell
        
        currentCell.originDistanceLabel.text = "500 m"
        currentCell.destinyDistanceLabel.text = "200 m"
        currentCell.timeLabel.text = "14h24"
        
        currentCell.addToStackView(image: UIImage(named: "Uber")!)
        currentCell.addToStackView(image: UIImage(named: "Cabify")!)
        currentCell.addToStackView(image: UIImage(named: "99.jpeg")!)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell") as? ResultsCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "ResultsCell", bundle: nil), forCellReuseIdentifier: "resultsCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell") as? ResultsCell
        }
        
        return cell!
    }
    
}
