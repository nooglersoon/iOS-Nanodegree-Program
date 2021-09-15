//
//  MainTableViewController.swift
//  On The Map
//
//  Created by Fauzi Achmad B D on 22/08/21.
//

import UIKit

class MainTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var students = StudentModel.students
    
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator.startAnimating()
        OTMClient.getStudents(completion: getStudentHandler(response:error:))
        
    }
    
    @IBAction func addLocationTapped(_ sender: Any) {
        
        let addLocationVC = storyboard?.instantiateViewController(identifier: "addLocationVC") as! AddLocationViewController
        present(addLocationVC, animated: true, completion: nil)
        
    }
    
    @IBAction func refreshDataTapped(_ sender: Any) {
        tableView.reloadData()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        whileLogingOut(true)
        OTMClient.userLogout(completion: userLoggingOutHandler(complete:error:))
    }
    
    private func getStudentHandler(response: [StudentResponseModel], error: Error?) {
        
        if error == nil {
            
            students = response
            activityIndicator.stopAnimating()
        } else {
            
            DispatchQueue.main.async {
                self.showAlert(message: "Fetch Data Failed")
            }
            
        }
        
        tableView.reloadData()
        
    }
    
    func userLoggingOutHandler(complete: Bool, error: Error?){
        
        whileLogingOut(false)
        
        if complete {
            dismiss(animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                self.showAlert(message: "Log Out Failed")
            }
        }
        
    }
    
    func whileLogingOut(_ loggingOut: Bool){
        
        if loggingOut {
            
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.refreshButton.isEnabled = false
                self.logOutButton.isEnabled = false
                self.addLocationButton.isEnabled = false
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.refreshButton.isEnabled = true
                self.logOutButton.isEnabled = true
                self.addLocationButton.isEnabled = true
            }
            
        }
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = !loggingOut
            self.refreshButton.isEnabled = !loggingOut
            self.logOutButton.isEnabled = !loggingOut
            self.addLocationButton.isEnabled = !loggingOut
        }
        
        
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension MainTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersTableCell", for: indexPath)
        
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = students[indexPath.row].firstName + " " +  students[indexPath.row].lastName
        cell.detailTextLabel?.text = students[indexPath.row].mediaURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = URL(string: students[indexPath.row].mediaURL) {
            UIApplication.shared.open(url)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
