//
//  SavableStore.swift
//  OAuthTest
//
//  Created by Feliciaan De Palmenaer on 28/02/2016.
//  Copyright © 2016 Zeus WPI. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

let TIME_BETWEEN_REFRESH: NSTimeInterval = 60 * 15

class SavableStore: NSObject {

    let storagePath: String

    var storageOutdated = false

    var currentRequests = Set<String>()

    func markStorageOutdated() {
        storageOutdated = true
    }

    func syncStorage() {
        if !self.storageOutdated {
            return
        }

        // Immediately mark the cache as being updated, as this is an async operation
        self.storageOutdated = false

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let isSuccesfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: self.storagePath)

            if !isSuccesfulSave {
                print("Saving the object failed")
            }
        }
    }

    init(storagePath: String) {
        self.storagePath = storagePath
    }

    func doLater(timeSec: Int = 10, function: (()->Void)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(timeSec)*Double(NSEC_PER_SEC))), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            function()
        }

    }

    // For array based objects
    internal func updateResource<T: Mappable>(resource: String, notificationName: String, lastUpdated: NSDate, forceUpdate: Bool, keyPath: String? = nil, completionHandler: ([T]-> Void)) {
        if lastUpdated.timeIntervalSinceNow > -TIME_BETWEEN_REFRESH && !forceUpdate {
            return
        }

        if currentRequests.contains(resource) {
            return
        }
        currentRequests.insert(resource)
        Alamofire.request(.GET, resource).responseArray(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), keyPath: keyPath) { (response: Response<[T], NSError>) -> Void in
            if let value = response.result.value where response.result.isSuccess {
                completionHandler(value)
                self.markStorageOutdated()
                self.syncStorage()
            } else {
                //TODO: Handle error
                self.handleError(response.result.error!)
            }
            self.postNotification(notificationName)
            self.doLater(function: { () -> Void in
                if self.currentRequests.contains(resource) {
                    self.currentRequests.remove(resource)
                }
            })
        }
    }


    func saveLater(timeSec: Int = 10) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(timeSec)*Double(NSEC_PER_SEC))), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            self.syncStorage()
        }
    }

    func postNotification(notificationName: String) {
        let center = NSNotificationCenter.defaultCenter()
        center.postNotificationName(notificationName, object: self)
    }

    func handleError(error: NSError?) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.handleError(error)
    }
}