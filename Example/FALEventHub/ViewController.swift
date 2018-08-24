//
//  ViewController.swift
//  FALEventHub
//
//  Created by Javier González Ovalle on 08/23/2018.
//  Copyright © 2018 Adessa Falabella. All rights reserved.
//

import UIKit
import FALEventHub

enum Example {
    static let message = "Event Message"
    static let infoKey = "exampleValue"
    static let infoValue = 777
}

class ViewController: UIViewController {

    @IBAction func exampleButtonActions(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            _ = EventHub.subscribe(instance: self, forEvent: Example.message, async : false) {(eventInfo : EventHub.EventDictionary?) in
                print("subscribed to: \(Example.message)")
                self.serialFunction(eventInfo)
            }
        case 2:
            EventHub.subscribe(instance: self, forEvent: Example.message, async: true, thenCall: asyncFunction)
            
        case 3:
            EventHub.unsubscribe(instance: self, fromEvent: Example.message)
        case 4:
            EventHub.trigger(eventMessage: Example.message)
        case 5:
            EventHub.trigger(eventMessage: Example.message, optionalInfo: [Example.infoKey : Example.infoValue])
        default:
            print("button not tagged")
        }
    }
    
    func serialFunction(_ param : Any?) {
        print("• function called on the same thread")
        if let extraInfo = param, extraInfo is EventHub.EventDictionary {
            print("this event came with extra information: \(extraInfo)")
        }
    }
    
    func asyncFunction(_ param : Any?) {
        print("• function called from a background thread")
        if let extraInfo = param, extraInfo is EventHub.EventDictionary {
            print("this event came with extra information: \(extraInfo)")
        }
    }
}

