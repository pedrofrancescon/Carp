//
//  SearchesVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 01/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit
import GooglePlaces


enum PlaceType {
    case destination
    case origin
}

class SearchesVC: UIViewController {

    @IBOutlet weak var destinationSearchView: SearchView!
    @IBOutlet weak var originSearchView: SearchView!
    
    @IBOutlet weak var destinationTableView: SearchTableView!
    @IBOutlet weak var originTableView: SearchTableView!
    
    private var destinationPredictions: [GMSAutocompletePrediction]
    private var originPredictions: [GMSAutocompletePrediction]
    
    private let locationsManager: LocationsManager
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    
    private var mapDelegate: MapControllerDelegate
    
    var slidingView: SlidingView? {
        get {
            guard let sliding = self.view as? SlidingView else {
                return nil
            }
            return sliding
        }
    }
    
    private var origin: Place? {
        didSet {
            DispatchQueue.main.async {
                if self.origin != nil {
                    self.originSearchView.textField.text = self.origin?.name
                    self.mapDelegate.createMapMarker(of: .origin, with: self.origin!)
                }
            }
        }
    }
    
    private var destination: Place? {
        didSet {
            DispatchQueue.main.async {
                if self.destination != nil {
                    self.destinationSearchView.textField.text = self.destination?.name
                    self.mapDelegate.createMapMarker(of: .destination, with: self.destination!)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(slidingViewDidChange), name: .slidginViewStateChanged, object: nil)
        
        // Search View
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
        
        destinationSearchView.delegate = self
        originSearchView.delegate = self
        
        destinationSearchView.textField.placeholder = "Destino"
        originSearchView.textField.placeholder = "Origem"
        
        // Table View
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
        
        destinationTableView.delegate = self
        destinationTableView.dataSource = self
        
        
        originTableView.delegate = self
        originTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        slidingView?.layout()
        
        super.viewDidLayoutSubviews()
    }
    
    init(mapDelegate: MapControllerDelegate) {
        destinationPredictions = [GMSAutocompletePrediction]()
        originPredictions = [GMSAutocompletePrediction]()
        
        self.mapDelegate = mapDelegate
        locationsManager = LocationsManager.locationsManager
        
        super.init(nibName: "SearchesVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    
    private func viewEndEditing() {
        destinationTableView.isHidden = true
        originTableView.isHidden = true
        view.endEditing(true)
    }
    
    @objc func slidingViewDidChange() {
        guard let state = slidingView?.currentState else { return }
        
        switch state {
        case .destination:
            if destination != nil {
                mapDelegate.animateTo(.destination)
            }
        case .origin:
            if origin != nil {
                mapDelegate.animateTo(.origin)
            }
        case .hidden:
            break
        }
    }
}

extension SearchesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsCell") as? SearchResultsCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "SearchResultsCell", bundle: nil), forCellReuseIdentifier: "searchResultsCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsCell") as? SearchResultsCell
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentCell = cell as! SearchResultsCell
        
        if tableView == destinationTableView {
            currentCell.placeAddressLabel.text = destinationPredictions[indexPath.row].attributedFullText.string
            currentCell.placeNameLabel.text = destinationPredictions[indexPath.row].attributedPrimaryText.string
        } else if tableView == originTableView {
            currentCell.placeAddressLabel.text = originPredictions[indexPath.row].attributedFullText.string
            currentCell.placeNameLabel.text = originPredictions[indexPath.row].attributedPrimaryText.string
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == destinationTableView {
            destinationTableView.changeHeightTo(numberOfCells: destinationPredictions.count)
            return destinationPredictions.count
        }
        
        originTableView.changeHeightTo(numberOfCells: originPredictions.count)
        return originPredictions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchTableView.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewEndEditing()
        
        if tableView == destinationTableView {
            guard let placeID = destinationPredictions[indexPath.row].placeID else { return }
            locationsManager.getPlace(ofID: placeID) { (place) in
                self.destination = place
            }
        } else if tableView == originTableView {
            guard let placeID = originPredictions[indexPath.row].placeID else { return }
            locationsManager.getPlace(ofID: placeID) { (place) in
                self.origin = place
            }
        }
    }
}

extension SearchesVC: SearchViewDelegate {
    
    func didTapNextButton() {
        
        guard let currentState = slidingView?.currentState else { return }
        
        viewEndEditing()
        
        if currentState == SlidingViewState.origin {
            if let _destination = self.destination, let _origin = self.origin  {
                slidingView?.slideViewAnimated(to: .hidden, withDuration: 0.8)
                
                RootVC.main.callRideDetailsVC(origin: _origin, destination: _destination)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.mapDelegate.drawRoute(from: _origin, to: _destination)
                }
                
                return
            }
        }
        
        slidingView?.slideViewAnimated(to: currentState.opposite, withDuration: 0.7)
        
    }
    
    func searchFieldDidChange(_ view: UIView, newText: String) {
        if view == destinationSearchView {
            destinationTableView.isHidden = false
            
            locationsManager.getPlacePredictions(with: newText) { (predictions) in
                
                self.destinationPredictions = predictions
                self.destinationTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                
            }
        } else if view == originSearchView {
            originTableView.isHidden = false
            
            locationsManager.getPlacePredictions(with: newText) { (predictions) in
                self.originPredictions = predictions
                self.originTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    
    func primaryActionTriggered(_ view: UIView) {
        self.viewEndEditing()
        
        if view == destinationSearchView {
            guard let placeID = destinationPredictions.first?.placeID else { return }
            locationsManager.getPlace(ofID: placeID) { (place) in
                self.destination = place
            }
            
        } else if view == originSearchView {
            guard let placeID = originPredictions.first?.placeID else { return }
            locationsManager.getPlace(ofID: placeID) { (place) in
                self.origin = place
            }
        }
    }
}
