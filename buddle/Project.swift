//
//  Project.swift
//  buddle
//
//  Created by Vu Quang Huy on 21/11/2021.
//

import Foundation

struct Project: Equatable {
    let projectUID: String
    let imagePath: String
    let owner: String
    let name: String
    let overview: String
    let description: String
    let role: String
    let experience: String
    let roleDescription: String
    var request = [String]()
    
    init(projectUID: String, owner: String, name: String, imagePath: String, overview: String, description: String, role: String, experience: String, roleDescription: String, request: [String]) {
        self.projectUID = projectUID
        self.owner = owner
        self.name = name
        self.imagePath = imagePath
        self.overview = overview
        self.description = description
        self.role = role
        self.experience = experience
        self.roleDescription = roleDescription
        self.request = request
    }
    
    func getProjectUID() -> String {
        return self.projectUID
    }
    
    func getOwner() -> String {
        return self.owner
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getImagePath() -> String {
        return self.imagePath
    }
    
    func getOverview() -> String {
        return self.overview
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func getRole() -> String {
        return self.role
    }
    
    func getExperience() -> String {
        return self.experience
    }
    
    func getRoleDescription() -> String {
        return self.roleDescription
    }
    
    func getRequest() -> [String] {
        return self.request
    }
    
}
