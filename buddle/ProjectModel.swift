//
//  ProjectModel.swift
//  buddle
//
//  Created by Vu Quang Huy on 22/11/2021.
//

import Foundation

class ProjectModel : NSObject {
    private var projects: [Project] = [Project] ()
    public static let shared = ProjectModel()
    
    override init() {
        super.init()
        
        print("Initialize shared ProjectModel")
    }
    
    func numberOfProjects() -> Int {
        return projects.count
    }
   
    
}
