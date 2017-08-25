//
//  Note+CoreDataProperties.swift
//  NoteSpreader
//
//  Created by BenRussell on 8/25/17.
//  Copyright © 2017 BenRussell. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let titleLength = 50

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var actualTitle: String?
    @NSManaged public var createdOn: Date?
    @NSManaged public var text: String?
    @NSManaged public var updatedOn: Date?
    @NSManaged public var photo: UIImage?
    @NSManaged public var location: Location?
    
    public var title: String? {
        get {
            guard let text = self.text else {
                return ""
            }
            if text.characters.count < titleLength {
                actualTitle = self.text
                return self.text
            } else {
                let startIndex =  text.index(text.startIndex, offsetBy: 0)
                let endIndex = text.index(startIndex, offsetBy: titleLength)
                actualTitle = text[startIndex...endIndex]
                return text[startIndex...endIndex]
            }
        }
        set {
            self.title = newValue
            actualTitle = newValue
        }
    }
    
    override public func willSave() {
        if createdOn == nil {
            self.createdOn = Date()
        }
        
        if let updatedOn = updatedOn {
            if updatedOn.timeIntervalSince(Date()) > 10.0 {
                self.updatedOn = Date()
            }
            
        } else {
            self.updatedOn = Date()
        }
    }

}
