# FALEventHub

[![Version](https://img.shields.io/cocoapods/v/FALEventHub.svg?style=flat)](https://cocoapods.org/pods/FALEventHub)
[![License](https://img.shields.io/cocoapods/l/FALEventHub.svg?style=flat)](https://cocoapods.org/pods/FALEventHub)
[![Platform](https://img.shields.io/cocoapods/p/FALEventHub.svg?style=flat)](https://cocoapods.org/pods/FALEventHub)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FALEventHub is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the sources in the top of the Podfile:

```
# Sources
source 'https://github.com/CocoaPods/Specs.git'
source 'https://bitbucket.adessa.cl/scm/mobile/falpods.git' 
```

then add the following line in the same Podfile:

```ruby
pod 'FALEventHub'
```

## Examples
### Swift 4

Subscribe `self` for an event named `anEvent` in the same thread and call a function `someFunction`: 

```swift
EventHub.subscribe(instance: self, forEvent: "anEvent") 
{ (eventInfo : EventHub.EventDictionary?) in
                self.someFunction(eventInfo) 
                }
```
Subscribe `self` for event named `anEvent` in a background thread and pass the function `asyncFunction` as a parameter: 

```swift                
EventHub.subscribe(instance: self, forEvent: "anEvent", async: true, thenCall: asyncFunction)
```

Trigger an event by calling its associated `String`:

```swift
EventHub.trigger(eventMessage:"anEvent")
```
Unsubscribe `self` from a message

```swift
EventHub.unsubscribe(instance: self, fromEvent: Example.message)
```
### Objective-C
Subscribe `self` for an event named `anEvent` in the same thread and call a function `someFunction`: 

```
[EventHub subscribeWithInstance:self forEvent:@"anEvent" async:NO
                                   thenCall:^(NSDictionary *messageInfo) {
                                   [self someFunction:messageInfo];
                                   }];
```

Subscribe `self` for event named `anEvent` in a background thread and pass the block `asyncFunction` as a parameter: 

```
EventHubBlock asyncFunction = ^(NSDictionary *messageInfo) { [self someFunction: messageInfo]; };

[EventHub subscribeWithInstance:self forEvent:@"anEvent" async:YES thenCall:asyncFunction];

```

Trigger an event by calling its associated `NSString` and pass an `EventDictionary` as optional information:

```
NSDictionary *messageInfo = @{@"Key" : @777};

[EventHub triggerWithEventMessage:message optionalInfo:messageInfo];

```
Unsubscribe `self` from a message

```
[EventHub unsubscribeWithInstance:self fromEvent:@"anEvent"];
```


## Author

Javier González Ovalle, jagonzalezo@falabella.cl

## License

FALEventHub is available under the MIT license. See the LICENSE file for more info.
