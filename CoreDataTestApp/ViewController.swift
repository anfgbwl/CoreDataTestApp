//
//  ViewController.swift
//  CoreDataTestApp
//
//  Created by t2023-m0076 on 2023/09/12.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    private var todo: [Todo]?
    
    // MARK: - UI Conponents
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorColor = .gray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem()
        addButton.image = UIImage(systemName: "plus")
        return addButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupUI() {
        self.navigationItem.rightBarButtonItem = self.addButton
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todo = todo![indexPath.row]
        cell.textLabel?.text = "todo"
        return cell
    }
    
}
