//
//  TaskCell.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/9/24.
//
import UIKit
import UIKit

// Custom UITableViewCell for displaying task information.
class TaskCell: UITableViewCell {
    
    // Title label for the task.
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Description label for additional task details.
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0  // Allows for multiple lines of text.
        return label
    }()
    
    // Color view as an indicator for task categorization or priority.
    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4  // Rounded corners for a subtle effect.
        return view
    }()
    
    // Initialize the cell and setup UI elements.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set up the UI layout and constraints.
    private func setupUI() {
        contentView.addSubview(colorView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            // Layout for the color indicator view.
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 10),
            colorView.heightAnchor.constraint(equalToConstant: 10),
            
            // Layout for the title label.
            titleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            // Layout for the description label.
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // Configure the cell with task data.
    func configure(with task: Assignment) {
        titleLabel.text = task.title
        descriptionLabel.text = task.details
        colorView.backgroundColor = UIColor(hexString: task.colorCode) ?? .clear
    }
}
