//
//  MainVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

private enum BarButtonState {
    case menu,back
}

enum MainViewState {
    case searches,rideDetails,results,car
}

class MainVC: UIViewController, DismissKeyboardProtocol {

    private let searchesVC: SearchesVC
    private let mapVC: MapVC
    private var resultsVC: ResultsVC?
    private var rideDetailsVC: RideDetailsVC?
    private var carVC: CarVC?
    
    private var leftBarBtnState: BarButtonState = .menu
    private var currentState: MainViewState = .searches
    
    private let navigationBtnAttributes = [
        NSAttributedString.Key.font: UIFont(name: "FontAwesome5FreeSolid", size: 20.0) as Any,
        NSAttributedString.Key.foregroundColor: UIColor.white as Any
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeLeftBarBtnTo(.menu)
        
        let rightBarBtn = UIBarButtonItem(title: "\u{f013}", style: .plain, target: self, action: #selector(didTapRightBarBtn))
        rightBarBtn.setTitleTextAttributes(navigationBtnAttributes, for: .normal)
        
        navigationItem.setRightBarButton(rightBarBtn, animated: false)
        
        navigationItem.title = "Nova Busca"
        
        addChildVC(mapVC)
        addChildVC(searchesVC)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewEndEditing))
        tap.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(tap)
        
        mapVC.mapView.dismissKeyboard = self
        
    }
    
    init() {
        mapVC = MapVC()
        searchesVC = SearchesVC(mapDelegate: mapVC)
        
        super.init(nibName: "MainVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func viewEndEditing() {
        self.view.endEditing(true)
    }
    
    private func hideAllViews() {
        rideDetailsVC?.rideDetailsView.hideView()
        resultsVC?.resultsView.hideView()
        carVC?.popUpView?.hideView()
    }
    
    func show(_ viewToShow: MainViewState, at slindingState: SlidingViewState = .destination, shouldSelect: Bool = false) {
        
        switch viewToShow {
        case .searches:
            hideAllViews()
            
            searchesVC.slidingView?.slideViewAnimated(to: slindingState, withDuration: 0.8)
            mapVC.mapView.animateTo(slindingState)
            
            if shouldSelect {
                switch slindingState {
                case .destination:
                    searchesVC.destinationSearchView.selectTextField()
                case .origin:
                    searchesVC.originSearchView.selectTextField()
                case .hidden:
                    break
                }
            }
            
            navigationItem.title = "Nova Busca"
            
            currentState = .searches
            changeLeftBarBtnTo(.menu)
            
        case .rideDetails:
            hideAllViews()
            
            guard let rideDetailsVC = rideDetailsVC else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                if rideDetailsVC.parent == nil {
                    self.addChildVC(rideDetailsVC)
                }
                
                rideDetailsVC.rideDetailsView.showView()
                self.navigationItem.title = "Detalhes"
                self.changeLeftBarBtnTo(.back)
                self.currentState = .rideDetails
            }
            
        case .results:
            hideAllViews()
            
            guard let resultsVC = resultsVC else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                if resultsVC.parent == nil {
                    self.addChildVC(resultsVC)
                }
                
                resultsVC.resultsView.showView()
                self.navigationItem.title = "Resultados"
                self.changeLeftBarBtnTo(.back)
                self.currentState = .results
            }
        case .car:
            hideAllViews()
            
            guard let carVC = carVC else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                if carVC.parent == nil {
                    self.addChildVC(carVC)
                }
                
                carVC.popUpView?.showView()
                self.navigationItem.title = "Carro"
                self.changeLeftBarBtnTo(.back)
                self.currentState = .car
            }
        }
    }
    
    func callRideDetailsVC(origin: Place, destination: Place) {
        for subVC in children {
            if let subVC = subVC as? RideDetailsVC {
                subVC.removeFromParentVC()
            }
        }
        
        rideDetailsVC = RideDetailsVC()
        guard let rideDetailsVC = rideDetailsVC else { return }
        
        rideDetailsVC.origin = origin
        rideDetailsVC.destination = destination
        
        self.show(.rideDetails)
    }
    
    func callResultsVC(ride: Ride) {
        for subVC in children {
            if let subVC = subVC as? ResultsVC {
                subVC.removeFromParentVC()
            }
        }
        
        resultsVC = ResultsVC(ride: ride)
        
        PersistantDataManager.dataManager.saveRideToDisk(ride: ride)
        
        self.show(.results)
    }
    
    func callCarVC(car: Car) {
        for subVC in children {
            if let subVC = subVC as? CarVC {
                subVC.removeFromParentVC()
            }
        }
        
        carVC = CarVC(car: car)
        
        show(.car)
    }
    
    @objc func didTapRightBarBtn() {
        let ride = PersistantDataManager.dataManager.getRideFromDisk()
        
        for subVC in children {
            if let subVC = subVC as? ResultsVC {
                subVC.removeFromParentVC()
            }
        }
        
        resultsVC = ResultsVC(ride: ride)
        
        PersistantDataManager.dataManager.saveRideToDisk(ride: ride)
        
        self.show(.results)
    }
    
    @objc func didTapLeftBarBtn() {
        
        switch leftBarBtnState {
        case .menu:
            break
        case .back:
            switch currentState {
            case .searches:
                break
            case .rideDetails:
                show(.searches, at: .origin)
            case .results:
                show(.rideDetails)
            case .car:
                show(.results)
            }
        }
    }
    
    fileprivate func changeLeftBarBtnTo(_ state: BarButtonState) {
        
        switch state {
        case .menu:
            
            let leftBarBtn = UIBarButtonItem(title: "\u{f0c9}", style: .plain, target: self, action: #selector(didTapLeftBarBtn))
            leftBarBtn.setTitleTextAttributes(navigationBtnAttributes, for: .normal)
            navigationItem.setLeftBarButton(leftBarBtn, animated: false)
            
            leftBarBtnState = .menu
            
        case .back:
            
            let leftBarBtn = UIBarButtonItem(title: "\u{f053}", style: .plain, target: self, action: #selector(didTapLeftBarBtn))
            leftBarBtn.setTitleTextAttributes(navigationBtnAttributes, for: .normal)
            navigationItem.setLeftBarButton(leftBarBtn, animated: false)
            
            leftBarBtnState = .back
            
        }
    }
}

protocol DismissKeyboardProtocol: class {
    func viewEndEditing()
}
