//
//  ViewController.swift
//  DiffableDataSource
//
//  Created by Tal Spektor on 02/12/2020.
//  Copyright © 2020 Tal Spektor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    // hashable by default
    enum Section {
        case first
    }
    
    // most be hashable
    struct Fruit: Hashable {
        let title: String
        
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, Fruit>!
    
    var fruits = [Fruit]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model.title
            return cell
        })
        
        title = "My Fruits"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let actionSheet = UIAlertController(title: "Select Fuit", message: nil, preferredStyle: .actionSheet)
        
        for x in 0...100 {
            actionSheet.addAction(UIAlertAction(title: "Fruit \(x+1)", style: .default, handler: { [weak self] _ in
                let fruit = Fruit(title: "Fruit \(x+1)")
                self?.fruits.append(fruit)
                self?.updateDateSource()
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cencel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    private func updateDateSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Fruit>()
        snapshot.appendSections([.first])
        snapshot.appendItems(fruits)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let fruit = dataSource.itemIdentifier(for: indexPath) else { return }
        
        print(fruit.title)
    }
}

