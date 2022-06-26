//
//  DetailViewController.swift
//  ToDoApp_TDD
//
//  Created by Felix Titov on 6/26/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    var task: Task!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        locationLabel.text = task.location?.name
    }
}
