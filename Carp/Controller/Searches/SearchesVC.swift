//
//  SearchesVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 01/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit
import GooglePlaces

private enum PlaceType {
    case destiny
    case origin
}

class SearchesVC: UIViewController {

    @IBOutlet weak var destinySearchView: SearchView!
    @IBOutlet weak var originSearchView: SearchView!
    
    @IBOutlet weak var destinyTableView: UITableView!
    @IBOutlet weak var originTableView: UITableView!
    
    private var destinyPredictions: [GMSAutocompletePrediction]
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
                self.viewEndEditing()
                self.originSearchView.textField.text = self.origin?.name
                self.mapDelegate.createMapMarker(of: self.origin!)
            }
        }
    }
    private var destiny: Place? {
        didSet {
            DispatchQueue.main.async {
                self.viewEndEditing()
                self.destinySearchView.textField.text = self.destiny?.name
                self.mapDelegate.createMapMarker(of: self.destiny!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        // Search View
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
        
        destinySearchView.delegate = self
        originSearchView.delegate = self
        
        destinySearchView.textField.placeholder = "Destino"
        originSearchView.textField.placeholder = "Origem"
        
        // Table View
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
        
        destinyTableView.delegate = self
        destinyTableView.dataSource = self
        destinyTableView.isHidden = true
        
        originTableView.delegate = self
        originTableView.dataSource = self
        originTableView.isHidden = true
    }
    
    init(mapDelegate: MapControllerDelegate) {
        destinyPredictions = [GMSAutocompletePrediction]()
        originPredictions = [GMSAutocompletePrediction]()
        
        self.mapDelegate = mapDelegate
        locationsManager = LocationsManager.locationsManager
        
        super.init(nibName: "SearchesVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    
    func viewEndEditing() {
        destinyTableView.isHidden = true
        originTableView.isHidden = true
        view.endEditing(true)
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
        
        if tableView == destinyTableView {
            currentCell.placeAddressLabel.text = destinyPredictions[indexPath.row].attributedFullText.string
            currentCell.placeNameLabel.text = destinyPredictions[indexPath.row].attributedPrimaryText.string
        } else if tableView == originTableView {
            currentCell.placeAddressLabel.text = originPredictions[indexPath.row].attributedFullText.string
            currentCell.placeNameLabel.text = originPredictions[indexPath.row].attributedPrimaryText.string
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == destinyTableView {
            return destinyPredictions.count
        }
        return originPredictions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == destinyTableView {
            guard let placeID = destinyPredictions[indexPath.row].placeID else { return }
            locationsManager.getPlace(ofID: placeID) { (place) in
                self.destiny = place
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
        
        if currentState == SlidingViewState.origin {
            if self.destiny != nil && self.origin != nil  {
                //carrega outra telinha
                return
            }
        }
        
        slidingView?.slideViewAnimated()
        
    }
    
    func searchFieldDidChange(_ view: UIView, newText: String) {
        if view == destinySearchView {
            destinyTableView.isHidden = false
            
            locationsManager.getPlacePredictions(with: newText) { (predictions) in
                self.destinyPredictions = predictions
                self.destinyTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
            
            if newText == "" {
                destinyTableView.isHidden = true
            }
        } else if view == originSearchView {
            originTableView.isHidden = false
            
            locationsManager.getPlacePredictions(with: newText) { (predictions) in
                self.originPredictions = predictions
                self.originTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
            
            if newText == "" {
                originTableView.isHidden = true
            }
        }
    }
    
    func primaryActionTriggered(_ view: UIView) {
        if view == destinySearchView {
            guard let placeID = destinyPredictions.first?.placeID else { return }
            locationsManager.getPlace(ofID: placeID) { (place) in
                self.destiny = place
            }
            
        } else if view == originSearchView {
            guard let placeID = originPredictions.first?.placeID else { return }
            locationsManager.getPlace(ofID: placeID) { (place) in
                self.origin = place
            }
        }
    }
}
