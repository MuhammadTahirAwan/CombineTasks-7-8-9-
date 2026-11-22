//
//  ViewController.swift
//  CombineBasics_RemainingTasks
//
//  Created by Tahir Awan on 15/11/2026.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private let viewModel = ButtonViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let loadingHandler = LoadingManager()
    
    
    private lazy var tapButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Press Me"
        config.cornerStyle = .medium
        
        let action = UIAction { [weak self] _ in
            // Bridge imperative button tap into the Combine subject
            self?.viewModel.buttonTapped.send()
        }
        
        let button = UIButton(configuration: config, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var loadpostsButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Load Posts"
        config.cornerStyle = .medium
        
        let action = UIAction { [weak self] _ in
            let postsVC = PostsViewController()
            self?.navigationController?.pushViewController(postsVC, animated: true)
        }
        
        let button = UIButton(configuration: config, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupButton()
        bindViewModel()
        
        
        loadingHandler.$isLoading
            .sink{ isloading in
                
                print("Loading state changed: \(isloading)")
            }
            .store(in: &cancellables)
        
        loadingHandler.simulateNetworkWork()
    }
    
    // 2. Add to view hierarchy and center with Auto Layout
    private func setupButton() {
        view.addSubview(tapButton)
        view.addSubview(loadpostsButton)
        
        NSLayoutConstraint.activate([
            tapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tapButton.widthAnchor.constraint(equalToConstant: 160),
            tapButton.heightAnchor.constraint(equalToConstant: 50),
            
            loadpostsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadpostsButton.centerYAnchor.constraint(equalTo: tapButton.bottomAnchor, constant: 30),
            loadpostsButton.widthAnchor.constraint(equalToConstant: 160),
            loadpostsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // 3. Observe the subject and print the running tap count
    private func bindViewModel() {
        viewModel.buttonTapped
            .scan(0) { count, _ in
                count + 1
            }
            .sink { pressCount in
                print("Button pressed \(pressCount) time(s)")
            }
            .store(in: &cancellables)
    }


}

