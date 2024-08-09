//
//  TaskCell.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/9/24.
//

import UIKit

class TaskCell: UITableViewCell {
    
    // Define views once as private properties to avoid unnecessary allocations
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        return view
    }()
    
    // Initialize the cell and setup constraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Setup UI only once during initialization
    private func setupUI() {
        contentView.addSubview(colorView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        // Constraints for color view
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 10),
            colorView.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        // Constraints for title label
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        
        // Constraints for description label
     
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

    }
    
    // Configure the cell with data, avoiding unnecessary re-setup
    func configure(with task: Assignment) {
        titleLabel.text = task.title
        descriptionLabel.text = task.details
        if let color = UIColor(hexString: task.colorCode) {
            colorView.backgroundColor = color
        } else {
            colorView.backgroundColor = .clear // Default color if parsing fails
        }
    }
}
