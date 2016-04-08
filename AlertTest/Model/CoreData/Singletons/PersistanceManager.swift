//
//  PersistanceManager.swift
//  CoreDataPractice
//
//  Created by Sauvik Dolui on 07/04/16.
//  Copyright © 2016 VSP Vision Care. All rights reserved.
//

import UIKit
import CoreData


typealias CoreDataSaveDeleteCallback = (success: Bool, error: CoreDataError?) -> Void
typealias EmployeeFetchCallBack = (employess: [NSManagedObject]?, error: CoreDataError?) -> Void

class PersistanceManager: NSObject {
    
    static let sharedManager: PersistanceManager = PersistanceManager()

    // MARK: - HELPING PROPERTIES
    
        /// WHERE WE ARE GOING TO PUT DATA
    lazy var applicationDocumentDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.last!
    }()
    
    
        /// MANAGED OBJECT MODEL TO GET ALL DETAILS OF ENTITIES AND RELATIONSHIPS AND FECTHED PROPERTIES
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModelFilePath = NSBundle.mainBundle().URLForResource("Company", withExtension: "momd")
        return NSManagedObjectModel(contentsOfURL: managedObjectModelFilePath!)!
    }()
    
    
    // MARK: - CREATING THE PERSISTANCE STORE COORDINATOR
    lazy var persistanceStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        // 1. Persistance store coordinator with the managed object model to look up for consistancy
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel:self.managedObjectModel )
        
        // 2. URL where to store the model data 
        let persistanceStoreLocation = self.applicationDocumentDirectory.URLByAppendingPathComponent("Company.sqlite")
        
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: persistanceStoreLocation, options: nil)
        } catch var error as NSError {
            
            // Faced an error while adding store destination file
            coordinator = nil
            let error = CoreDataError.PersistanceStoreLoadError
            print(error.description)
            
            
            // Abboriting application
            abort()
            
            
        } catch {
            // Abboriting application
            fatalError()
        }
        
        return coordinator
        
    }()
    
    // MARK: - MANAGED OBJECT CONTEXT
    lazy var managedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistanceStoreCoordinator
        return moc
    }()

    
    
    // MARK: - FUNCTIONS
    func saveManagedObjectContextWithCompletionBlock(callBack: CoreDataSaveDeleteCallback?) {
        var error: CoreDataError?
        var savingStatus = false
        managedObjectContext.performBlock({ () -> Void in
            
            do {
                try self.managedObjectContext.save()
                savingStatus = true
            } catch _ as NSError {
                error = CoreDataError.ManagedObjectContextSaveError
                print("COULD NOT SAVE MOC in CoreData \(error), \(error?.description)")
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                if let callBack = callBack {
                    callBack(success: savingStatus, error: error)
                }
            })
        })
    }
}



//MARK: - HELPING FUNCTIONS FOR WORKING WITH CORE DATA

//MARK: - DEPARTMENT SERVICES
extension PersistanceManager {
    func createNewDepartment(departmentID: String, departmentName: String, callback: CoreDataSaveDeleteCallback) {
        DepartmentServicesCD.createNewDepartment(departmentID, departmentName: departmentName, callback: callback)
    }
    func loadAllDepartmentsMO() -> [NSManagedObject] {
        return DepartmentServicesCD.loadAllDepartmentsMO()
    }
    
    func getAllEmployessFromDepartment(deptID: String, callBack: EmployeeFetchCallBack) {
         DepartmentServicesCD.getAllEmployessFromDepartment(deptID, callBack: callBack)
    }
}

extension PersistanceManager {
    func addNewEmployee(fistName: String, lastName: String, employeeID: String, inDepartment deptID: String, callback: CoreDataSaveDeleteCallback) {
        EmployeeServicesCD.addNewEmployee(fistName, lastName: lastName, employeeID: employeeID, inDepartment: deptID, callback: callback)
    }
}
