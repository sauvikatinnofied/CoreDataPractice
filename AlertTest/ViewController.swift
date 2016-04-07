//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by Sauvik Dolui on 06/04/16.
//  Copyright © 2016 VSP Vision Care. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        
        let persistanceManager = PersistanceManager.sharedManager        
//        persistanceManager.createNewDepartment("1234fert34", departmentName: "iOS R&D") { (success, error) in
//            if success {
//                
//
//                
//            } else {
//                print(error?.description)
//                
//                // going to add a new employee
//                persistanceManager.addNewEmployee("Sauvik", lastName: "Dolui", employeeID: "3589u438t34ju4thn", inDepartment: "1234fert34", callback: { (success, error) in
//                    if success {
//                        
//                        for dept in  persistanceManager.loadAllDepartmentsMO(){
//                            
//                            if let allEmpoyeeSet = dept.valueForKey("employees")  {
//                                for employee in (allEmpoyeeSet as! NSSet).allObjects as! [NSManagedObject] {
//                                    print("\n-----------------------------------------")
//                                    print(employee.valueForKey("firstName"))
//                                    print(employee.valueForKey("lastName"))
//                                    print(employee.valueForKey("employeeID"))
//                                    if let department = employee.valueForKey("department") as? NSManagedObject {
//                                        print(department.valueForKey("departmentName"))
//                                        print(department.valueForKey("departmentID"))
//                                    }
//                                    print("-----------------------------------------\n")
//                                }
//                            }
//                        }
//                        
//                    } else {
//                        print(error?.description)
//                    }
//                })
//            }
//        }
        
        
        persistanceManager.getAllEmployessFromDepartment("1234fert34") { (employess, error) in
            
            if let employess = employess {
                for employee in employess {
                    print("\n-----------------------------------------")
                    print(employee.valueForKey("firstName"))
                    print(employee.valueForKey("lastName"))
                    print(employee.valueForKey("employeeID"))
                    if let department = employee.valueForKey("department") as? NSManagedObject {
                        print(department.valueForKey("departmentName"))
                        print(department.valueForKey("departmentID"))
                    }
                    print("-----------------------------------------\n")
                }
            } else {
                print(error?.description)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

        
    }


}

