//
//  NoteSpreaderTableViewController.swift
//  NoteSpreader
//
//  Created by BenRussell on 8/23/17.
//  Copyright © 2017 BenRussell. All rights reserved.
//

import UIKit
import CoreData

class NoteSpreaderTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let coreDataController = BARCoreDataController.sharedInstance
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedOn", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataController.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
           try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        self.updateView()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }
    
    private func updateView() {
        var hasNotes = false
        
        if let quotes = fetchedResultsController.fetchedObjects {
            hasNotes = quotes.count > 0
        }
        
        tableView.isHidden = !hasNotes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - FetchedResultsController & Delegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        break;
        default:
            print("...")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notes = fetchedResultsController.fetchedObjects else { return 0 }
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let note = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = note.title
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        if let date = note.createdOn {
            cell.detailTextLabel?.text = formatter.string(from: date)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = fetchedResultsController.object(at: indexPath)
            
            note.managedObjectContext?.delete(note)
            coreDataController.saveContext()
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNoteSeque" {
            let viewController:NoteSpreaderAddNoteViewController = segue.destination as! NoteSpreaderAddNoteViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            viewController.noteID = self.fetchedResultsController.fetchedObjects?[(indexPath?.row)!].objectID
        }
    }
}
