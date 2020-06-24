//
//  Extensions.swift
//  Cluster
//
//  Created by Lasha Efremidze on 4/15/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import MapKit

extension MKMapRect {
    init(minX: Double, minY: Double, maxX: Double, maxY: Double) {
        self.init(x: minX, y: minY, width: abs(maxX - minX), height: abs(maxY - minY))
    }
    init(x: Double, y: Double, width: Double, height: Double) {
        self.init(origin: MKMapPoint(x: x, y: y), size: MKMapSize(width: width, height: height))
    }
    var minX: Double { return self.minX }
    var minY: Double { return self.minY }
    var midX: Double { return self.midX }
    var midY: Double { return self.midY }
    var maxX: Double { return self.maxX }
    var maxY: Double { return self.maxY }
    func intersects(_ rect: MKMapRect) -> Bool {
        return self.intersects(rect)
    }
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        return self.contains(MKMapPoint.init(coordinate))
    }
}

let CLLocationCoordinate2DMax = CLLocationCoordinate2D(latitude: 90, longitude: 180)
let MKMapPointMax = MKMapPoint.init(CLLocationCoordinate2DMax)

extension CLLocationCoordinate2D: Hashable, Equatable {
    public var hashValue: Int {
        return latitude.hashValue ^ longitude.hashValue
    }
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

typealias ZoomScale = Double
extension ZoomScale {
    func zoomLevel() -> Double {
        let totalTilesAtMaxZoom = MKMapSize.world.width / 256
        let zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom)
        return max(0, zoomLevelAtMaxZoom + floor(log2(self) + 0.5))
    }
    func cellSize() -> Double {
        switch self {
        case 13...15:
            return 64
        case 16...18:
            return 32
        case 19 ..< .greatestFiniteMagnitude:
            return 16
        default: // Less than 13
            return 88
        }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
