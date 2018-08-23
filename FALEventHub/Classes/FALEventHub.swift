//
//  FALEventHub.swift
//  FALEventHub
//
//  Created by Javier González Ovalle on 08-08-18.
//  Copyright © 2018 Adessa Falabella. All rights reserved.
//

import Foundation

public class EventHub: NSObject {

    // Singleton
    static let sharedManager = EventHub()
    private override init() { }
    
    public typealias EventDictionary = [String : Any]
    public typealias EventFunction = (EventDictionary?) -> Void
    public typealias SubscriberDictionary = [String : [EventFunction]] //|id|array of functions|
    
    private var serialSubscribers = [String : SubscriberDictionary]() //|message|id|array of functions|
    private var asyncSubscribers = [String : SubscriberDictionary]()

    // MARK: - utility
    
    func getIdForAnInstance(object : NSObject) -> String {
        let instanceId = ObjectIdentifier(object).hashValue
        let idNumber = NSNumber.init(value: instanceId)
        let theId = idNumber.stringValue
        return theId
    }
    
    class func descriptionOfAllEvents() {
        print("ASYNC: ")
        sharedManager.describeEvents(forSubscribers: sharedManager.asyncSubscribers)
        print("SERIAL: ")
        sharedManager.describeEvents(forSubscribers: sharedManager.serialSubscribers)
    }
    
    private func describeEvents(forSubscribers eventsDict: [String : SubscriberDictionary]) {
        for message in eventsDict.keys {
            print("• \(message):")
            if let funcDict = eventsDict[message] {
                for id in funcDict.keys {
                    if let array = funcDict[id] {
                        print("id: \(id) --> \(array)")
                    }
                }
            }
        }
    }
    
    /**
     All the events registered in the EventHub
     - returns: Set of Strings with the event message.
    */
    class func registeredEvents() -> Set<String> {
        let regEvents = Set<String>.init(sharedManager.serialSubscribers.keys)
        let asyncEvents = Set<String>.init(sharedManager.asyncSubscribers.keys)
        return regEvents.union(asyncEvents)
    }
    
    /**
     Returns the Events an instance is subscribed for.
     - returns: an optional Set<String> with the event messages.
     - Parameter forInstance: the object could be listening to the messages
     */
    class func eventsSubscribedTo(forInstance possibleSubscriber : NSObject) -> Set<String>? {
        
        var registeredMessages = Set<String>()
        let pSubId = sharedManager.getIdForAnInstance(object: possibleSubscriber)
        for message in sharedManager.serialSubscribers.keys {
            if let funcIdDict = sharedManager.serialSubscribers[message] {
                for instanceId in funcIdDict.keys {
                    if pSubId == instanceId {
                        registeredMessages.insert(message)
                    }
                }
            }
        }
        if registeredMessages.count > 0 {
            return registeredMessages
        } else {
            return nil
        }
    }
    
    /**
     Trigger an event by its message name
     - returns: nothing
     - Parameter eventMessage: the name of the event that triggers the message.
     - Parameter optionalInfo: an optional EventDictionary = [String, Any]     
     */
    public class func trigger(eventMessage message :String, optionalInfo messageDict: EventDictionary? = nil) {

        if let asyncIds = sharedManager.asyncSubscribers[message] {
            let backgroundQueue = DispatchQueue.global(qos:.background)
            for functionsForEvent in asyncIds.values {
                for subscriberFunction in functionsForEvent {
                    backgroundQueue.async {
                        subscriberFunction(messageDict)
                    }
                }
            }
        }
        if let idsFollowing = sharedManager.serialSubscribers[message] {
            for functionsForEvent in idsFollowing.values {
                for subscriberFunction in functionsForEvent {
                    subscriberFunction(messageDict)
                }
            }
        }
    }
    
    // MARK: - Subscription, with ID
    
    /**
     Subscribe an instance for a specific event. It saves the closure function to be called by its trigger message.
     - returns: The id in the data structure of this class.
     - Parameter instance: the object which wil be listening to the message
     - Parameter forEvent: the name of the event that triggers the message.
     - Parameter thenCall: the method that will be called when triggered.
     */
    public class func subscribe(instance subscriber : NSObject, forEvent message: String, async : Bool = false,thenCall closure : (@escaping EventFunction)) -> String {
        return sharedManager.subscribe(instance:subscriber, forEvent: message, async: async, thenCall: closure)
    }
    
    private func subscribe(forEvent message: String, withId sid: String, async : Bool, thenCall subscriberFunction: (@escaping EventFunction) ) {
        let newFunctionsArray = [subscriberFunction]
        _ = unsubscribe(fromEvent: message, withId: sid)
        if async {
            asyncSubscribers = updateSubscriber(event: message, withArrayOfFunctions: newFunctionsArray, pairedWith: sid, inEventDictionary: asyncSubscribers)
        } else {
            serialSubscribers = updateSubscriber(event: message, withArrayOfFunctions: newFunctionsArray, pairedWith: sid, inEventDictionary: serialSubscribers)
        }
    }

    private let subsTable = NSMapTable<NSString, NSObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)
    private func subscribe(instance subscriber : NSObject, forEvent message: String, async : Bool, thenCall closure : (@escaping EventFunction)) -> String {
        
        //let idNumber = NSNumber.init(value: ObjectIdentifier(subscriber).hashValue)
        let newId = getIdForAnInstance(object: subscriber)
        subsTable.setObject(subscriber, forKey: newId as NSString)
        subscribe(forEvent: message, withId: newId, async: async, thenCall: closure)
        //print("newid: \(newId) • \(subsTable)")
        return newId
    }

    //MARK: - Unsubscribe
    /**
     Unsubscribe for a specific message. It removes the function to be called
     - returns: True if it was removed. False if not found
     - Parameter withId: the name given when the function was subscribed.
     - Parameter fromEvent: the name of the event that triggers the message.
     */
    private func unsubscribe(fromEvent message: String, withId uid : String) -> Bool {

        var wasRemoved = false
        if serialSubscribers.keys.contains(message) {
            let unsubbed = remove(event: message, forId: uid, inEventDictionary: serialSubscribers)
            serialSubscribers = unsubbed.updatedEventDictionary
            wasRemoved = unsubbed.itWasRemoved
        } else if asyncSubscribers.keys.contains(message) {
            let unsubbed = remove(event: message, forId: uid, inEventDictionary: asyncSubscribers)
            asyncSubscribers = unsubbed.updatedEventDictionary
            wasRemoved = unsubbed.itWasRemoved
        }
        return wasRemoved
    }

    /**
     Unsubscribe for a specific message. It removes the function to be called
     - returns: True if it was removed. False if not found
     - Parameter instance: the object that is subscribed.
     - Parameter fromEvent: the name of the event that triggers the message.
     */
    @discardableResult public class func unsubscribe(instance subscriber : NSObject, fromEvent message : String) -> Bool {
        let uId = sharedManager.getIdForAnInstance(object: subscriber)
        return sharedManager.unsubscribe(fromEvent: message, withId: uId)
    }
    
    // MARK: Dictionary Management
    
    func updateSubscriber(event message : String, withArrayOfFunctions newFunctionsArray:[EventFunction],
                          pairedWith sid: String, inEventDictionary eventDict : [String : SubscriberDictionary]) -> [String : SubscriberDictionary] {
        var newEventDictionary = eventDict
        
        if let idsForTheMessage = newEventDictionary[message] {
            var includingFunctionForIDDictionary = idsForTheMessage
            // possible TODO: append the new function to the array
            //if let functionsForId = idsForTheMessage[sid] { newFunctionsArray = functionsForId + newFunctionsArray }
            includingFunctionForIDDictionary.updateValue(newFunctionsArray, forKey: sid)
            newEventDictionary.updateValue(includingFunctionForIDDictionary, forKey: message)
        }
        else {
            //add a new everything
            let idFunctionsDictionary = [sid : newFunctionsArray]
            newEventDictionary.updateValue(idFunctionsDictionary, forKey: message)
        }
        return newEventDictionary
    }
    
    /**
     Unsubscribe for a specific message. It removes the function to be called
     - returns: The modified Dictionary of messages and Ids. True if it was removed, false if not found
     - Parameter event: the name of the event that triggers the message.
     - Parameter forId: the ID the object that is subscribed.
     - Parameter inEventDictionary: the collection of subscribers.
     */
    func remove(event message : String, forId uid : String,
                inEventDictionary eventDict : [String : SubscriberDictionary]) -> (updatedEventDictionary : [String : SubscriberDictionary], itWasRemoved : Bool) {
        
        var updatedEvents = eventDict
        var removed = false
        if var idsForMessage = updatedEvents[message] {
            if idsForMessage.removeValue(forKey: uid) != nil {
                removed = true
                updatedEvents.updateValue(idsForMessage, forKey: message)
                if idsForMessage.keys.count == 0 {
                    if let emptyIndex = updatedEvents.index(forKey: message) {
                        updatedEvents.remove(at: emptyIndex)
                    }
                }
            }
        }
        return(updatedEvents, removed)
    }

// end of class
}
