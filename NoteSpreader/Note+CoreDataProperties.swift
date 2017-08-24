//
//  Note+CoreDataProperties.swift
//  NoteSpreader
//
//  Created by BenRussell on 8/24/17.
//  Copyright © 2017 BenRussell. All rights reserved.
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var createdOn: Date?
    @NSManaged public var updatedOn: Date?
    @NSManaged public var text: String?
    @NSManaged public var actualTitle: String?
    public var title: String? {
        get {
            guard let text = self.text else {
                return ""
            }
            if text.characters.count < 50 {
                return self.text
            } else {
                let startIndex =  text.index(text.startIndex, offsetBy: 0)
                let endIndex = text.index(startIndex, offsetBy: 50)
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
