//
//  PostsViewController.swift
//  CombineBasics_RemainingTasks
//
//  Created by Tahir Awan on 16/11/2026.
//

import UIKit
import Combine

class PostsViewController: UIViewController {
    
    
    private let postsModel = PostsLoader()
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "PostCell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Posts"
        
        setupTableView()
        bindViewModel()
        postsModel.fetchPosts()
        

    }
    
    private func bindViewModel(){
        
        postsModel.$posts
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    

}



extension PostsViewController: UITableViewDataSource {
    
    // Stub 1: Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsModel.posts.count
    }
    
    // Stub 2: Configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        let post = postsModel.posts[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = post.title
        content.textProperties.numberOfLines = 0 // Allows multi-line post titles to wrap
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - UITableViewDelegate (Optional)
extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
