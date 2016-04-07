//
//  DepartmentServicesCD.swift
//  CoreDataPractice
//
//  Created by Sauvik Dolui on 07/04/16.
//  Copyright © 2016 VSP Vision Care. All rights reserved.
//

import UIKit
import CoreData


class DepartmentServicesCD: NSObject {
    
    static let moc = PersistanceManager.sharedManager.managedObjectContext
    static let deptEntityDescription = NSEntityDescription.entityForName("Department", inManagedObjectContext: moc)
    static var allEntityFetchRequest: NSFetchRequest { return NSFetchRequest(entityName: "Department") }
    
    static var allDepartmentMOs : [NSManagedObject] {
        return loadAllDepartmentsMO()
    }
    
    static func createNewDepartment(departmentID: String, departmentName: String, callback: CoreDataSaveDeleteCallback){
        
        // 1. TESTING WHETHER DEPARTMENT EXISTS OR NOT
        if let _ = getDepartmentMOWithID(departmentID){
            callback(success: false, error: CoreDataError.DepartmentAlreadyExistError)
            return
        }
        
        // 2. Creating a new Department with ManagedObject
        let newEntry = NSManagedObject(entity: deptEntityDescription!, insertIntoManagedObjectContext: moc)
        newEntry.setValue(departmentID, forKey: "departmentID")
        newEntry.setValue(departmentName, forKey: "departmentName")
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
    }
    
    static func getAllEmployessFromDepartment(deptID: String, callBack: EmployeeFetchCallBack) {
        if let dept = getDepartmentMOWithID(deptID) {
            if let employeesSet = dept.valueForKey("employees"){
                let employees = ((employeesSet as! NSSet).allObjects) as! [NSManagedObject]
                if employees.count > 0 {
                    callBack(employess: employees, error: nil)
                } else {
                    callBack(employess: nil, error: CoreDataError.UserNotFoundError)
                }                
            }
        } else {
            callBack(employess: nil, error: CoreDataError.DepartmentNotFoundError)
        }

    }
    static func loadAllDepartmentsMO() -> [NSManagedObject] {
        do {
            return  try moc.executeFetchRequest(allEntityFetchRequest) as! [NSManagedObject]
        } catch {
            print("DepartmentServicesCD: loadAllDepartmentsMOM() error = \(error)")
        }
        return [NSManagedObject]()
    }
    
    static func getDepartmentMOWithID(deptID: String) -> NSManagedObject? {
        
        // 1. Adding predicate to get specific department
        let request = allEntityFetchRequest
        request.predicate = NSPredicate(format: "departmentID = %@", deptID)
        
        do {
          return try (moc.executeFetchRequest(request) as! [NSManagedObject]).last
        } catch {
            print("DepartmentServicesCD: getDepartmentWithID() error = \(error)")
        }
        return nil
    }
}
