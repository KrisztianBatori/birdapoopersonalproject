//
//  CloudManager.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 05. 05..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import CloudKit

class CloudManager {
    private static let userDatabase = CKContainer.default().privateCloudDatabase
    static var savedRecords: [CKRecord] = []
    static var savingCompleted = true
    
    static func isICloudContainerAvailable() -> Bool {
        if let _ = FileManager.default.ubiquityIdentityToken {
            return true
        }
        else {
            return false
        }
    }
    
    static func saveToCloud(data: String, dataKey: String) {
        if isICloudContainerAvailable() {
            
            savingCompleted = false
            
            let query = CKQuery(recordType: "Data", predicate: NSPredicate(value: true))
            userDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                
                guard let records = records else { return }
                print("records queried")
                if let userRecord = records.first(where: {$0.recordID == CKRecord.ID.init(recordName: dataKey)}) {
                    userRecord.setValue(data, forKey: dataKey)
                    userDatabase.save(userRecord, completionHandler: { (record, error) in
                        guard record != nil else { savingCompleted = true; return }
                        savingCompleted = true
                    })
                }
                else {
                    let newData = CKRecord(recordType: "Data", recordID: .init(recordName: dataKey))
                    newData.setValue(data, forKey: dataKey)
                    userDatabase.save(newData, completionHandler: { (record, error) in
                        guard record != nil else { savingCompleted = true; return }
                        savingCompleted = true
                    })
                }
                
            })
        }
        
    }
    
    static func attemptToRetrieveData(for dataKey: String) -> String? {
        var retrievedData: String? = nil
        
        if let userRecord = GameViewController.userDataFromCloud.first(where: {$0.recordID == CKRecord.ID.init(recordName: dataKey)}) {
            retrievedData = userRecord.value(forKey: dataKey) as? String
        }
        
        return retrievedData
    }
    
    static func loadFromCloud() -> [CKRecord] {
        var queryInProgress = true
        let query = CKQuery(recordType: "Data", predicate: NSPredicate(value: true))
        userDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
            guard let records = records else { return }
            savedRecords = records
            queryInProgress = false
        })
        while queryInProgress {
            // This loop is for "freezing" any background activities while this function completes.
        }
        return savedRecords
    }
    
    static func deleteContainer() {
        
        // This function is for testing only
        
        userDatabase.delete(withRecordZoneID: CKRecordZone.default().zoneID, completionHandler: { (records, _) in
        })
    }
    
    static func isUserSignedToiCloud() -> Bool {
        var isUserSignedIn = true
        CKContainer.default().accountStatus(completionHandler: { accountStatus, error in
            if accountStatus == .noAccount {
                isUserSignedIn = false
            }
        })
        return isUserSignedIn
    }
}
