//
//  FiltersViewController.swift
//  CocktailsApp
//
//  Created by Nata Boiko on 15.07.2020.
//  Copyright © 2020 Nata Boiko. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var filters = [Category]() {
    didSet {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
      }
    }
    
        let filterButton: UIButton = {
        let filter = UIButton(type: .system)
        let title = "APPLY"
        let font = UIFont(name: "Roboto-Bold", size: 16)
        let color = UIColor.white
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
            let attributedTitle = NSAttributedString(string: title, attributes: attributes as [NSAttributedString.Key : Any])
        filter.setAttributedTitle(attributedTitle, for: .normal)
        filter.setTitleColor(UIColor.white, for: .normal)
        filter.layer.backgroundColor = UIColor.black.cgColor
        filter.titleLabel?.textAlignment = .center
        filter.addTarget(self, action: #selector(handleSearch(_:)), for: .touchUpInside)
        return filter
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        navTitle.textAlignment = .left
        let title = "Drinks"
        let font = UIFont(name: "Roboto-Bold", size: 24)
        let attributes = [NSAttributedString.Key.font: font]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes as [NSAttributedString.Key : Any])
        navTitle.attributedText = attributedTitle
        self.navigationItem.titleView = navTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 60

        getFilters()

        
        view.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70).isActive = true
        filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func handleSearch(_ sender: UIButton) {
        
    }
    
   func getFilters() {
        let filtersRequest = FiltersRequest()
        filtersRequest.getFilters { [weak self] result in
            switch result {
            case .failure (let error):
                print(error)
            case .success (let filters):
                self?.filters = filters
            }
        }
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! CategoryCell
        let category = filters[indexPath.row]
        let font = UIFont(name: "Roboto-Regular", size: 16)
        let color = UIColor(red: 0.496, green: 0.496, blue: 0.496, alpha: 1)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        cell.categoryName.attributedText = NSAttributedString(string: category.strCategory, attributes: attributes as [NSAttributedString.Key : Any])
        cell.tintColor = UIColor.black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
        }
    }
}
