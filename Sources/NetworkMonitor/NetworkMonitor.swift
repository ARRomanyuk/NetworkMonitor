// The Swift Programming Language
// https://docs.swift.org/swift-book

import Network
import SwiftUI

public class NetworkMonitor: ObservableObject {

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")

    public var isConnected: Bool = false
    public var isExpensive: Bool = false
    public var isConstrained: Bool = false
    public var connetctType: NWInterface.InterfaceType = .other
    
    public init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.isExpensive = path.isExpensive
                self.isConstrained = path.isConstrained

                let conectionType: [NWInterface.InterfaceType] = [.wifi, .wiredEthernet, .cellular]
               
                self.connetctType = conectionType.first(where: path.usesInterfaceType) ?? .other
                
                self.objectWillChange.send()
            }
        }
        monitor.start(queue: queue)
    }
}
