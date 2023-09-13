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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var todos: [Todo]?
    
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        tableView.dataSource = self
        tableView.delegate = self
        addButton.target = self
        addButton.action = #selector(addTapped)
        
        fetchTodo()
    }
    
    // MARK: - function
    private func fetchTodo() {
        do {
            self.todos = try context.fetch(Todo.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("fetchTodo Error")
        }
        
    }
    
    @objc private func addTapped() {
        let alert = UIAlertController(title: "Add Todo", message: "", preferredStyle: .alert)
        alert.addTextField{ (textField) in
            textField.placeholder = "Please write your todo."
        }
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            let textField = alert.textFields![0]
            let newTodo = Todo(context: self.context)
            newTodo.todo = textField.text
            newTodo.createDate = Date()
            
            do {
                try self.context.save()
            } catch {
                print("save error")
            }
            
            self.fetchTodo()
        }
        
        alert.addAction(add)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - setupUI
    private func setupUI() {
        self.navigationItem.rightBarButtonItem = self.addButton
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }


}

// MARK: - NORMAL CELL
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todo = todos![indexPath.row]
        cell.textLabel?.text = todo.todo
        return cell
    }
    
}
