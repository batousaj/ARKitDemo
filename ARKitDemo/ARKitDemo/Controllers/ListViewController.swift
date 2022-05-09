//
//  ListViewController.swift
//  ARKitDemo
//
//  Created by Thien Vu on 05/05/2022.
//

import Foundation
import UIKit

class ListViewController : UIViewController {
    
    var listView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitle()
        self.setupListView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupTitle() {
        self.title = "AR Test Demo"
        self.navigationController?.navigationBar.backgroundColor = .systemGray3
    }
    
    func setupListView() {
        self.view.addSubview(self.listView)
        listView.translatesAutoresizingMaskIntoConstraints = false
        
        let contraints = [
            listView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            listView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
        ]
        
        NSLayoutConstraint.activate(contraints)
        
        listView.dataSource = self
        listView.delegate = self
    }
    
    func presentARView(name : View) {
        if (name == View.ARSCNView) {
            let storyboard = UIStoryboard(name: "ARSCNSreen", bundle: nil)
            let ViewController = storyboard.instantiateViewController(withIdentifier: "ARSCNSreen") as! ViewController
            self.navigationController?.pushViewController(ViewController, animated: true)
        } else if name == View.ARView {
            let storyboard = UIStoryboard(name: "ARScreen", bundle: nil)
            let ARViewController = storyboard.instantiateViewController(withIdentifier: "ARScreen") as! ARViewController
            self.navigationController?.pushViewController(ARViewController, animated: true)
        }
    }
}

extension ListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = UITableViewCell()
        if ( indexPath.row == 0) {
            table.textLabel?.text = "ARSCNView"
        } else if ( indexPath.row == 1) {
            table.textLabel?.text = "ARView"
        }
        return table
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.presentARView(name: View.ARSCNView)
        } else if indexPath.row == 1 {
            self.presentARView(name: View.ARView)
        }
    }
    
}
