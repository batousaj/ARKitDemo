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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupListView() {
        self.view.addSubview(self.listView)
        listView.translatesAutoresizingMaskIntoConstraints = false
        listView.dataSource = self
        listView.delegate = self
    }
    
}

extension ListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = UITableViewCell()
        return table
    }
    
}
