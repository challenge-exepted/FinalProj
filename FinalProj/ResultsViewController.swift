//
//  ResultsViewController.swift
//  FinalProj
//
//  Created by Lucy Chebotar on 6/4/18.
//  Copyright © 2018 Lucy Chebotar. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import Realm
import RealmSwift

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var titleOfScreen = ""
    var airport = Airport()
    
    var departureArray = [FlightInfo]()
    var arrivalArray = [FlightInfo]()
    var favouritesArray = [FlightInfo]()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let nib = UINib(nibName:"FlightCell", bundle: nil)
        resultsTableView.register(nib, forCellReuseIdentifier: "FlightCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadFavData()
        reloadData()
    }
    private func setupUI(){
        setGradientBackground()
        resultsTableView.backgroundColor = .clear
        resultsTableView.tableFooterView = UIView()
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        title = titleOfScreen
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "GillSans", size: 20)!]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let font = UIFont(name: "GillSans", size: 20)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        segmentedControl.setTitle("Departures", forSegmentAt: 0)
        segmentedControl.setTitle("Arrivals", forSegmentAt: 1)
        
        //MARK:- Library settings, pull to refresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0)
        resultsTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.reloadData()
            self?.resultsTableView.dg_stopLoading()
            }, loadingView: loadingView)
        resultsTableView.dg_setPullToRefreshFillColor(UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0))
        resultsTableView.dg_setPullToRefreshBackgroundColor(resultsTableView.backgroundColor!)
    }

    private func reloadData(){
        let airportDataService = DataService()
        airportDataService.airport = airport
        airportDataService.getData(completion:{
            self.departureArray = airportDataService.getDeparturesData()
            self.arrivalArray = airportDataService.getArrivalsData()
            DispatchQueue.main.async{
               self.resultsTableView.reloadData()
            }
        })
    }

    private func reloadFavData(){
        do{
            let realm = try Realm()
            let favResults = realm.objects(FlightInfo.self)
            favouritesArray = Array(favResults)
        } catch{
            print(error)
        }
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 0.7).cgColor
        let colorBottom = UIColor(red: 255/255, green: 94/255, blue: 58/255, alpha: 0.7).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    //MARK: - TableViw Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex{
        case 0: return departureArray.count
        case 1: return arrivalArray.count
        default: return favouritesArray.count
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath) as! FlightCell
        var flightInfo = FlightInfo.init()
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            flightInfo = departureArray[indexPath.row]
        case 1:
            flightInfo = arrivalArray[indexPath.row]
        default:
            flightInfo = favouritesArray[indexPath.row]
        }
        cell.configure(information: flightInfo)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var flightInfo = FlightInfo.init()
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            flightInfo = departureArray[indexPath.row]
        case 1:
            flightInfo = arrivalArray[indexPath.row]
        default:
            flightInfo = favouritesArray[indexPath.row]
        }

         tableView.deselectRow(at: indexPath, animated: true)
         performSegue(withIdentifier: "goToInformation", sender: flightInfo )
        //var flightsArray = segmentedControl.selectedSegmentIndex == 0 ? departureArray: arrivalArray
        //var flghtInfo = flightsArray[indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is InformationViewController {
            let access  = segue.destination as? InformationViewController
            access?.flightInformation = (sender as! FlightInfo)
        }
    }
    

    
    @IBAction func segmentedControl(_ sender: Any) {
        resultsTableView.reloadData()
    }
    
}
