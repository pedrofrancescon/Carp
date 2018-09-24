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
            NSAttributedString.Key.font: UIFont(name: "FontAwesome5FreeSolid", size: 20.0) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white as Any
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
            resultsVC?.resultsView.hideView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.rideDetailsVC?.rideDetailsView.showView()
            }
            
            return
        }
        
        rideDetailsVC = RideDetailsVC()
        guard let rideDetailsVC = rideDetailsVC else { return }
        
        resultsVC?.resultsView.hideView()
        
        rideDetailsVC.origin = origin
        rideDetailsVC.destiny = destiny
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.addChildViewController(rideDetailsVC)
            self.view.addSubview(rideDetailsVC.view)
            
            rideDetailsVC.rideDetailsView.showView()
        }
    }
    
    func callResultsVC(ride: Ride) {
        if resultsVC != nil {
            rideDetailsVC?.rideDetailsView.hideView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.resultsVC?.resultsView.showView()
            }
            
            return
        }
        
        resultsVC = ResultsVC(ride: ride)
        guard let resultsVC = resultsVC else { return }
        
        rideDetailsVC?.rideDetailsView.hideView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.addChildViewController(resultsVC)
            self.view.addSubview(resultsVC.view)
            
            resultsVC.resultsView.showView()
        }
        
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
        
//        if rideDetailsVC != nil {
//            rideDetailsVC?.rideDetailsView.showView()
//            return
//        }
//
//        rideDetailsVC = RideDetailsVC()
//        guard let rideDetailsVC = rideDetailsVC else { return }
//
//        addChildViewController(rideDetailsVC)
//        view.addSubview(rideDetailsVC.view)
//
//        rideDetailsVC.rideDetailsView.showView()
        
        if resultsVC != nil {
            resultsVC?.resultsView.showView()
            return
        }

        resultsVC = ResultsVC()
        guard let resultsVC = resultsVC else { return }

        rideDetailsVC?.view.removeFromSuperview()
        rideDetailsVC?.removeFromParentViewController()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.addChildViewController(resultsVC)
            self.view.addSubview(resultsVC.view)

            resultsVC.resultsView.showView()
        }
        
    }

}
