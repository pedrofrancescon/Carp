//
//  MainVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    private let searchesVC: SearchesVC
    private let mapVC: MapVC
    private var resultsVC: ResultsVC?
    private var rideDetailsVC: RideDetailsVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let navigationBtnAttributes = [
            NSAttributedStringKey.font: UIFont(name: "FontAwesome5FreeSolid", size: 20.0) as Any,
            NSAttributedStringKey.foregroundColor: UIColor.white as Any
        ]
        
        let rightBarBtn = UIBarButtonItem(title: "\u{f013}", style: .plain, target: self, action: #selector(clicked))
        rightBarBtn.setTitleTextAttributes(navigationBtnAttributes, for: .normal)
        let leftBarBtn = UIBarButtonItem(title: "\u{f0c9}", style: .plain, target: self, action: #selector(clicked))
        leftBarBtn.setTitleTextAttributes(navigationBtnAttributes, for: .normal)
        
        navigationItem.setRightBarButton(rightBarBtn, animated: false)
        navigationItem.setLeftBarButton(leftBarBtn, animated: false)
        
        navigationItem.title = "Nova Busca"
        
        addChildViewController(mapVC)
        addChildViewController(searchesVC)
        
        view.addSubview(mapVC.view)
        view.addSubview(searchesVC.view)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func callRideDetailsVC(origin: Place, destiny: Place) {
        if rideDetailsVC != nil {
            rideDetailsVC?.rideDetailsView.showView()
            return
        }
        
        rideDetailsVC = RideDetailsVC()
        guard let rideDetailsVC = rideDetailsVC else { return }
        
        rideDetailsVC.origin = origin
        rideDetailsVC.destiny = destiny
        
        addChildViewController(rideDetailsVC)
        view.addSubview(rideDetailsVC.view)
        
        rideDetailsVC.rideDetailsView.showView()
    }
    
    init() {
        mapVC = MapVC()
        searchesVC = SearchesVC(mapDelegate: mapVC)
        
        super.init(nibName: "MainVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clicked() {
        if rideDetailsVC != nil {
            return
        }
        
        rideDetailsVC = RideDetailsVC()
        guard let rideDetailsVC = rideDetailsVC else { return }
        
        addChildViewController(rideDetailsVC)
        view.addSubview(rideDetailsVC.view)
        
        rideDetailsVC.rideDetailsView.showView()
    }

}
