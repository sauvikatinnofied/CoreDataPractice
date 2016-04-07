//
//  AppErrors.swift
//  CoreDataPractice
//
//  Created by Sauvik Dolui on 07/04/16.
//  Copyright © 2016 VSP Vision Care. All rights reserved.
//

import Foundation


protocol AppError: ErrorType, CustomStringConvertible {
    
    var  description: String {get}
}


enum CoreDataError: Int, AppError {
    
    // General Errors
    case PersistanceStoreLoadError
    case ManagedObjectContextSaveError
    
    // Department services Errors
    case DepartmentCreationError
    case DepartmentAlreadyExistError
    case DepartmentNotFoundError
    
    
    // User Services Errors
    case UserCreationError
    case UserAlreadyExistError
    case UserNotFoundError
    
    
    case UnKnownError

    

    func errorCode() -> Int{
        
        var errorCode = 5000
        
        switch self {
        
        // --------------------------------
        //      GENERAL ERRORS
        // --------------------------------
        case .PersistanceStoreLoadError:
            errorCode += CoreDataError.PersistanceStoreLoadError.rawValue
        case .ManagedObjectContextSaveError:
            errorCode += CoreDataError.ManagedObjectContextSaveError.rawValue
            
            
        // --------------------------------
        //      DEPARTMENT SERVICES ERROR
        // --------------------------------
        case .DepartmentCreationError:
            errorCode += CoreDataError.DepartmentCreationError.rawValue
        case .DepartmentAlreadyExistError:
            errorCode += CoreDataError.DepartmentAlreadyExistError.rawValue
        case .DepartmentNotFoundError:
            errorCode += CoreDataError.DepartmentNotFoundError.rawValue
            
            
            
        // --------------------------------
        //      USER SERVICES ERROR
        // --------------------------------
        case .UserCreationError:
            errorCode += CoreDataError.UserCreationError.rawValue
        case .UserAlreadyExistError:
            errorCode += CoreDataError.UserAlreadyExistError.rawValue
        case .UserNotFoundError:
            errorCode += CoreDataError.UserNotFoundError.rawValue
            
            
          
        // --------------------------------
        //      UNKNOWN ERROR
        // --------------------------------
        case .UnKnownError:
            errorCode += CoreDataError.UnKnownError.rawValue
        }
        
        
        return errorCode
    }
    
    func errorString() -> String {
        
        var errorString = "CORE DATA ERROR: \(errorCode()) "
        
        switch self {
            
        // --------------------------------
        //      GENERAL ERRORS
        // --------------------------------
        case .PersistanceStoreLoadError:
            errorString += "Persistance coordinator load error"
        case .ManagedObjectContextSaveError:
            errorString += "Managed object context save error"
            
        // --------------------------------
        //      DEPARTMENT SERVICES ERROR
        // --------------------------------
        case .DepartmentCreationError:
            errorString += "Deptmenent creation error"
        case .DepartmentAlreadyExistError:
            errorString += "Deptmenent already exists"
        case .DepartmentNotFoundError:
            errorString += "Could not found department"
            
            
        // --------------------------------
        //      USER SERVICES ERROR
        // --------------------------------
        case .UserCreationError:
            errorString += "User addition error"
        case .UserAlreadyExistError:
            errorString += "User already exists"
        case .UserNotFoundError:
            errorString += "Could not found user"
            
        
        // --------------------------------
        //      UNKNOWN ERROR
        // --------------------------------
        case .UnKnownError:
            errorString += "Unknown error"
        }
        return errorString
    }
    
    var description: String {return "\(errorString())" }
    
    
}