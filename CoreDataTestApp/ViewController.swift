//
//  ViewController.swift
//  CoreDataTestApp
//
//  Created by t2023-m0076 on 2023/09/12.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Variables
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
    // Fetch Todo
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
    
    // Create Todo
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
                print("Save error")
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
    
    // Edit Todo
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectTodo = self.todos![indexPath.row]
        let alert = UIAlertController(title: "Edit Todo", message: "Plese edit your todo.", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields![0]
        textField.text = selectTodo.todo
        
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            let textField = alert.textFields![0]
            selectTodo.todo = textField.text
            
            do {
                try self.context.save()
            } catch {
                print("Edit error")
            }
            
            self.fetchTodo()
        }
        
        alert.addAction(save)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // Delete Todo
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let todoToRemove = self.todos![indexPath.row]
            self.context.delete(todoToRemove)
            
            do {
                try self.context.save()
            } catch {
                print("Delete error")
            }
            
            self.fetchTodo()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
