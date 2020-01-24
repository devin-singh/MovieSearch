//
//  MovieListTableViewController.swift
//  MovieSearch
//
//  Created by Devin Singh on 1/24/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [Movie] = [] {
        didSet {
            tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func fetchMovies(withName name: String) {
        MovieController.getMovies(withTitle: name) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.movies = movies
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
            }
        }
    }
   
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell()}
        
        let movie = movies[indexPath.row]
        
        MovieController.getImageFromPath(urlPath: movie.imagePath ?? "") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    cell.imageView?.image = image
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
            }
        }
       
        cell.titleLabel.text = movie.title ?? "Error With Title"
        guard let rating = movie.rating else { return UITableViewCell() }
        cell.ratingLabel.text = String(rating)
        cell.overviewLabel.text = movie.overview ?? "Error Loading Overview"
        
        return cell
    }
}

extension MovieListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          guard let searchText = searchBar.text else { return }
              fetchMovies(withName: searchText)
    }
}
