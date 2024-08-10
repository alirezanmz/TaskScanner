//
//  TaskListViewController.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//
import UIKit
import Combine

// Displays a list of tasks, allowing filtering via search bar or QR code scanning.
class TaskListViewController: UIViewController, QRCodeScannerViewControllerDelegate {
   
    private lazy var viewModel = TaskViewModel()  // Manages task data.
    
    // Table view to display tasks, with pull-to-refresh functionality.
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    // Search controller to filter tasks by user input.
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tasks"
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()          // Initialize UI components.
        setupBindings()    // Bind data to UI.
        fetchData()        // Load initial data.
    }
    
    // Sets up the UI components and layout.
    private func setupUI() {
        title = "Tasks"
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let qrScanButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(scanQRCode))
        navigationItem.rightBarButtonItem = qrScanButton
    }

    // Refreshes task data from the view model.
    @objc private func refreshData() {
        Task { [weak self] in
            guard let self = self else { return }
            await self.viewModel.fetchTasks()
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // Presents the QR code scanner.
    @objc func scanQRCode() {
        let qrScannerVC = QRCodeScannerViewController()
        qrScannerVC.modalPresentationStyle = .fullScreen
        qrScannerVC.delegate = self
        present(qrScannerVC, animated: true, completion: nil)
    }
    
    // Sets up bindings between the view model and UI.
    private func setupBindings() {
        Task { [weak self] in
            guard let self = self else { return }
            await self.observeFilteredTasks()
        }
    }

    // Observes changes in filtered tasks and updates the table view.
    @MainActor
    private func observeFilteredTasks() async {
        for await _ in viewModel.filteredTasksStream {
            tableView.reloadData()
        }
    }
    
    // Fetches the initial set of tasks from the view model.
    private func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            await self.viewModel.fetchTasks()
            self.tableView.reloadData()
        }
    }
    
    // Updates the search bar with the scanned QR code and filters tasks.
    func didFindQRCode(_ code: String) {
        searchController.searchBar.text = code
        viewModel.filterTasks(searchText: code)
    }
}

// Handles table view data source and delegate methods.
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

// Updates search results as the user types in the search bar.
extension TaskListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterTasks(searchText: searchText)
    }
}
