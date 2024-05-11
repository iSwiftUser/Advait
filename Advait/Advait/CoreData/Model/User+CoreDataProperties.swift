//
//  User+CoreDataProperties.swift
//  Advait
//
//  Created by Gaurav Sharma on 10/05/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var imageID: String?

}
