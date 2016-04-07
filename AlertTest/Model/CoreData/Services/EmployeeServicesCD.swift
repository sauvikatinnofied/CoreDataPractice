//
//  EmployeeServicesCD.swift
//  CoreDataPractice
//
//  Created by Sauvik Dolui on 07/04/16.
//  Copyright © 2016 VSP Vision Care. All rights reserved.
//

import UIKit
import CoreData

class EmployeeServicesCD: NSObject {

    static let moc = PersistanceManager.sharedManager.managedObjectContext
    static let empEntityDescription = NSEntityDescription.entityForName("Employee", inManagedObjectContext: moc)
    static var allEntityFetchRequest: NSFetchRequest { return NSFetchRequest(entityName: "Employee") }
    
    static var allEmployeeMOs : [NSManagedObject] {
        return loadAllEmployeeMO()
    }
    
    
    static func addNewEmployee(fistName: String, lastName: String, employeeID: String, inDepartment deptID: String, callback: CoreDataSaveDeleteCallback){
        
        // 1. TESTING WHETHER DEPARTMENT EXISTS OR NOT
        if let dept = DepartmentServicesCD.getDepartmentMOWithID(deptID){
            
            
            // 2. TEST USER ALREADY EXISTS OR NOT 
            if let _ = getEmployeeMOWithID(employeeID, deptID: deptID){
                callback(success: false, error: CoreDataError.UserAlreadyExistError)
                return
            }
            // 3. Creating a new Department with ManagedObject
            let newEntry = NSManagedObject(entity: empEntityDescription!, insertIntoManagedObjectContext: moc)
            newEntry.setValue(fistName, forKey: "firstName")
            newEntry.setValue(lastName, forKey: "lastName")
            newEntry.setValue(employeeID, forKey: "employeeID")
            newEntry.setValue(dept, forKey: "department")
            PersistanceManager.sharedManager.saveManagedObjectContextWithCompletionBlock( {(success, error) -> Void in
                
                var successStatus = false
                var error: CoreDataError?
                
                if success {
                    successStatus = true
                } else {
                    error = CoreDataError.DepartmentCreationError
                }
                
                callback(success: successStatus, error: error)
            })
            
        } else {
            callback(success: false, error: CoreDataError.DepartmentNotFoundError)
        }
        

    }
    
    
    static func loadAllEmployeeMO() -> [NSManagedObject] {
        do {
            return  try moc.executeFetchRequest(allEntityFetchRequest) as! [NSManagedObject]
        } catch {
            print("DepartmentServicesCD: loadAllDepartmentsMOM() error = \(error)")
        }
        return [NSManagedObject]()
    }
    
    static func getEmployeeMOWithID(empID: String, deptID: String?) -> NSManagedObject? {
        
        // 1. Adding predicate to get specific department
        let request = allEntityFetchRequest
        if let deptID = deptID{
            request.predicate = NSPredicate(format: "employeeID = %@ AND department.departmentID = %@", empID, deptID)
        } else {
            request.predicate = NSPredicate(format: "employeeID = %@", empID)
        }
        
        do {
            return try (moc.executeFetchRequest(request) as! [NSManagedObject]).last
        } catch {
            print("DepartmentServicesCD: getDepartmentWithID() error = \(error)")
        }
        return nil
    }
    
}
