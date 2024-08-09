//
//  TaskListViewController.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import UIKit
import Combine

class TaskListViewController: UIViewController, QRCodeScannerViewControllerDelegate {
   
    
    private var viewModel = TaskViewModel()
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        fetchData()
    }
    
    private func setupUI() {
        title = "Tasks"
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tasks"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        //Setting the rowHeight allows the cell height to be adjusted automatically
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        let qrScanButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(scanQRCode))
        navigationItem.rightBarButtonItem = qrScanButton
  
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func refreshData() {
        Task {
            await viewModel.fetchTasks()
            tableView.refreshControl?.endRefreshing()
            tableView.reloadData()
        }
    }
    
    // Method to present the QRScannerViewController
    @objc func scanQRCode() {
        let qrScannerVC = QRCodeScannerViewController()
        qrScannerVC.modalPresentationStyle = .fullScreen
        qrScannerVC.delegate = self  // Assuming you'll implement a delegate to pass the scanned value back
        present(qrScannerVC, animated: true, completion: nil)
    }
    
    private func setupBindings() {
        Task {
            await observeFilteredTasks()
        }
    }

    @MainActor
    private func observeFilteredTasks() async {
        // Create an AsyncStream to observe changes in the filteredTasks array
        for await _ in viewModel.filteredTasksStream {
            tableView.reloadData()
        }
    }
    
    private func fetchData() {
        Task {
            await viewModel.fetchTasks()
            tableView.reloadData()
        }
    }
    
    func didFindQRCode(_ code: String) {
        searchController.searchBar.text = code  // Assuming you have a UISearchBar
        viewModel.filterTasks(searchText: code)  // Trigger the search with the scanned text
    }
    
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = viewModel.filteredTasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
    
 
}


extension TaskListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterTasks(searchText: searchText) // Call the filter method

    }
}

