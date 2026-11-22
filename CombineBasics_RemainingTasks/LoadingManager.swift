//
//  LoadingManager.swift
//  CombineBasics_RemainingTasks
//
//  Created by Tahir Awan on 16/11/2026.
//

import Foundation
import Combine


class LoadingManager{
    
    @Published var isLoading: Bool = false
    
    func simulateNetworkWork(){
        
        isLoading = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){ [weak self] in
            
            self?.isLoading = false
        }
    }
}
