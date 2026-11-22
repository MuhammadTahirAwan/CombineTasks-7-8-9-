//
//  PostsLoader.swift
//  CombineBasics_RemainingTasks
//
//  Created by Tahir Awan on 16/11/2026.
//

import Foundation
import Combine


class Post: Decodable{
    
    let id: Int
    let title: String
    let body: String
    
}


protocol NetworkLoader{
    
    
}

class PostsLoader{
    
    @Published public var posts: [Post] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedPosts in
                self?.posts = fetchedPosts
            }
            .store(in: &cancellables)
    }
    
}



