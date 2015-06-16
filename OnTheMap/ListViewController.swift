//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 11.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Magic Values
    private struct Defaults {

        static let MapPinIcon = "map-pin"

        static let StudentLocationCellReuseIdetifier = "Student Location Cell"

        static let AddUserLocationSegue = "Add User Location"
    }

    // MARK: - Actions and Outlets

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    @IBAction func refreshLocations(sender: UIBarButtonItem) {
        updateStudentLocations()
    }

    // MARK: - Auxiliary Methods

    private func updateStudentLocations() {
        ParseAPI.client.getStudentLocations(updateTableData)
    }

    private func updateTableData(locations: [StudentLocation]) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }

    private func openURL(urlString: String) {
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    // MARK: - UITableView Data Source Methods

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseAPI.client.studentLocations!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Defaults.StudentLocationCellReuseIdetifier, forIndexPath: indexPath) as! UITableViewCell

        cell.imageView?.image = UIImage(named: Defaults.MapPinIcon)
        cell.textLabel?.text = ParseAPI.client.studentLocations![indexPath.row].firstName + " " + ParseAPI.client.studentLocations![indexPath.row].lastName
        cell.detailTextLabel?.text = ParseAPI.client.studentLocations![indexPath.row].mapString

        return cell
    }

    // MARK: - UITableView Delegate Methods

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        openURL(ParseAPI.client.studentLocations![indexPath.row].mediaURL)
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        if ParseAPI.client.studentLocations == nil {
            updateStudentLocations()
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Defaults.AddUserLocationSegue {
            let navVC = segue.destinationViewController as! UINavigationController
            let destination = navVC.visibleViewController as! AddLocationViewController
            let source = self.tabBarController?.viewControllers?.first as! MapViewController
            destination.region = source.mapView.region
        }
    }
}