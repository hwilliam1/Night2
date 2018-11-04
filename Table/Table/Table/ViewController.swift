@@ -0,0 +1,190 @@

import UIKit
import Alamofire
class TableViewController: UITableNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


private func loadactivitiesFromApi() {
    activities = [
        [
            "id": 1,
            "name" : "Take a Shower",
            ],
        [
            "id": 2,
            "name": "Finish Problem Set"
        ]
    ]
}


var activities:[NSDictionary] = []

override func viewDidLoad() {
    self.super.viewDidLoad()
    
    loadUsersFromApi()
}

// MARK: - Table view data source


override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
}


override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath)
    cell.textLabel?.text = users[indexPath.row]["name"] as! String?
    return cell
}


override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let movedObject = users[sourceIndexPath.row]
    users.remove(at: sourceIndexPath.row)
    users.insert(movedObject, at: destinationIndexPath.row)
}

override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        self.users.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

navigationItem.title = "To Do Before Bed"
navigationItem.rightBarButtonItem = self.editButtonItem
navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: add, target)


public func showAddUserAlertController() {
    let alterCtrl = UIAlertController(title:"To Do Before Bed", message: "Things to Do Before Bed", preferredStyle: .alert)
    
    alterCtrl.addTextField { (textField) in
        self.textField = textField
        self.textField.autocapitilizationType == words
        self.textField.placeholder = "e.g Shower"
    }
    alertCtrl.addAction(UIAlertAction(title:"Cancel",style: .cancel, handler: nil))
    
    alertCtrl.addAction(UIAlertAction(title: "Add", style: .default, handler: {action in
        if let name = self.textField.text, name != ""{
            self.users.append(["id": self.users.count, "name": name])
            self.tableView.reloadData()
        }
    }))
    present(alertCtrl, animated: true, completion:nil)
}

var textField: UITextField!


override func viewDidLoad() {
    // other stuff...
    setupActivityIndicator()
    loadUsersFromApi()
}

private func loadUsersFromApi() {
    indicator.startAnimating()
    
    Alamofire.request(self.endpoint + "/users").validate().responseJSON { (response) in
        switch response.result {
        case .success(let JSON):
            self.users = JSON as! [NSDictionary]
            self.tableView.reloadData()
            self.indicator.stopAnimating()
        case .failure(let error):
            print(error)
        }
    }
}


var endpoint = "http://localhost:4000"
var indicator = UIActivityIndicatorView()

private func setupActivityIndicator() {
    indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    indicator.activityIndicatorViewStyle = .white
    indicator.backgroundColor = UIColor.darkGray
    indicator.center = self.view.center
    indicator.layer.cornerRadius = 05
    indicator.hidesWhenStopped = true
    indicator.layer.zPosition = 1
    indicator.isOpaque = false
    indicator.tag = 999
    tableView.addSubview(indicator)
}



if let name = self.textField.text, name != "" {
    let payload: Parameters = ["name": name, "deviceId": self.deviceId]
    
    Alamofire.request(self.endpoint + "/add", method: .post, parameters:payload).validate().responseJSON { (response) in
        switch response.result {
        case .success(_):
            self.users.append(["id": self.users.count, "name" :name])
            self.tableView.reloadData()
        case .failure(let error):
            print(error)
        }
    }
}

let deviceId = UIDevice.current.identifierForVendor!.uuidString


override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let movedObject = users[sourceIndexPath.row]
    
    let payload:Parameters = [
        "deviceId": self.deviceId,
        "src":sourceIndexPath.row,
        "dest": destinationIndexPath.row,
        "src_id": users[sourceIndexPath.row]["id"]!,
        "dest_id": users[destinationIndexPath.row]["id"]!
    ]
    

    Alamofire.request(self.endpoint+"/move", method: .post, parameters: payload).validate().responseJSON { (response) in
        switch response.result {
        case .success(_):
            self.activites.remove(at: sourceIndexPath.row)
            self.activities.insert(movedObject, at: destinationIndexPath.row)
        case .failure(let error):
            print(error)
        }
    }
}

private func setupActivityIndicator() {
    indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    indicator.activityIndicatorViewStyle = .white
    indicator.backgroundColor = UIColor.darkGray
    indicator.center = self.view.center
    indicator.layer.cornerRadius = 05
    indicator.hidesWhenStopped = true
    indicator.layer.zPosition = 1
    indicator.isOpaque = false
    indicator.tag = 999
    tableView.addSubview(indicator)
}
