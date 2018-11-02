//
//  MainVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class MainVC: UIViewController, DismissKeyboardProtocol {

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
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewEndEditing))
//        tap.cancelsTouchesInView = false
//        navigationController?.navigationBar.addGestureRecognizer(tap)
//        
//        mapVC.mapView.dismissKeyboard = self
        
    }
    
    @objc func viewEndEditing() {
        self.view.endEditing(true)
    }
    
    func callRideDetailsVC(origin: Place, destiny: Place) {
        if rideDetailsVC != nil {
            resultsVC?.resultsView.hideView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.rideDetailsVC?.rideDetailsView.showView()
                self.navigationItem.title = "Detalhes"
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
            self.navigationItem.title = "Detalhes"
        }
    }
    
    func callResultsVC(ride: Ride) {
        if resultsVC != nil {
            rideDetailsVC?.rideDetailsView.hideView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.resultsVC?.resultsView.showView()
                self.navigationItem.title = "Resultados"
            }
            
            return
        }
        
        resultsVC = ResultsVC(ride: ride)
        guard let resultsVC = resultsVC else { return }
        
        PersistantDataManager.dataManager.saveRideToDisk(ride: ride)
        
        rideDetailsVC?.rideDetailsView.hideView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.addChildViewController(resultsVC)
            self.view.addSubview(resultsVC.view)
            
            resultsVC.resultsView.showView()
            self.navigationItem.title = "Resultados"
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
        if resultsVC != nil {
            rideDetailsVC?.rideDetailsView.hideView()

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.resultsVC?.resultsView.showView()
            }

            return
        }
        
        let ride = PersistantDataManager.dataManager.getRideFromDisk()
        
        if ride != nil {
            resultsVC = ResultsVC(ride: ride as! Ride)
            guard let resultsVC = resultsVC else { return }
            
            rideDetailsVC?.rideDetailsView.hideView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.addChildViewController(resultsVC)
                self.view.addSubview(resultsVC.view)
                
                resultsVC.resultsView.showView()
            }

        }
        
    }

}

protocol DismissKeyboardProtocol: class {
    
    func viewEndEditing()
    
}
