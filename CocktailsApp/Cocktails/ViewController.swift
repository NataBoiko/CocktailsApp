//
//  ViewController.swift
//  CocktailsApp
//
//  Created by Nata Boiko on 15.07.2020.
//  Copyright © 2020 Nata Boiko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var filters = [Category]()
    private var listOfCocktails = [Drink]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 120

        
        setupNavigation()
        getFilters()
        getCocktails()
    }
    
    func setupNavigation() {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "filter"), for: .normal)
        button.addTarget(self, action:#selector(handleFiltering), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let filterButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [filterButton]
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 1

        let navigationTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        navigationTitle.textAlignment = .left
        let title = "Drinks"
        let font = UIFont(name: "Roboto-Bold", size: 24)
        let attributes = [NSAttributedString.Key.font: font]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes as [NSAttributedString.Key : Any])
        navigationTitle.attributedText = attributedTitle
        self.navigationItem.titleView = navigationTitle
    }
    
    @objc func handleFiltering() {
        guard let filtersViewController = self.storyboard?.instantiateViewController(identifier: "FiltersViewController") as? FiltersViewController else { return }
        
        navigationController?.pushViewController(filtersViewController, animated: true)
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
    
    @objc func getCocktails() {

         let cocktailsRequest = CocktailsRequest()
         cocktailsRequest.getCocktails { [weak self] result in
             switch result {
             case .failure (let error):
                 print(error)
             case .success (let cocktails):
                 self?.listOfCocktails = cocktails
             }
         }
     }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        for i in 0...10 {
            return filters[i].strCategory
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfCocktails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CocktailCell
        let cocktail = listOfCocktails[indexPath.row]
        
        let font = UIFont(name: "Roboto-Regular", size: 16)
        let color = UIColor(red: 0.496, green: 0.496, blue: 0.496, alpha: 1)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        cell.cocktailName.attributedText = NSAttributedString(string: cocktail.strDrink
            , attributes: attributes as [NSAttributedString.Key : Any])
        
        let url = URL(string: cocktail.strDrinkThumb)
           DispatchQueue.global().async {
               let data = try? Data(contentsOf: url!)
               DispatchQueue.main.async {
                cell.cocktailImage.image = UIImage(data: data!)
               }
           }
        return cell
    }
}

