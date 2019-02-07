//
//  StringPickerTableViewController.swift
//  AirQuality
//
//  Created by Thomas Feng on 1/14/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import UIKit

protocol StringPickerTableViewControllerDelegate {
    func stringPickerDidSelect(picker: StringPickerTableViewController, title: String)
}

class StringPickerTableViewController: UITableViewController, UISearchBarDelegate {
    
    private let titles: [String]
    private var filteredTitles: [String]
    private let delegate: StringPickerTableViewControllerDelegate?
    lazy var searchBar:UISearchBar = UISearchBar()
    
    init(titles: [String], delegate: StringPickerTableViewControllerDelegate) {
        self.titles = titles
        self.delegate = delegate
        self.filteredTitles = titles
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override func viewDidLoad()
    {
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredTitles.removeAll()
        if searchText.count != 0 {
            for title in titles {
                let range = title.lowercased().range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    self.filteredTitles.append(title)
                }
            }
        }
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = filteredTitles[indexPath.row]
        
        return cell
    }
    
    // MARK - Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.stringPickerDidSelect(picker: self, title: filteredTitles[indexPath.row])        
    }
    
}
