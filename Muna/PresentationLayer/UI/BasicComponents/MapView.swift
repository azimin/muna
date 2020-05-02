//
//  MapView.swift
//  Muna
//
//  Created by Alexander on 5/2/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: NSViewRepresentable {
    func updateNSView(_ nsView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: 34.011286, longitude: -116.166868)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        nsView.setRegion(region, animated: true)
    }

    func makeNSView(context: Context) -> MKMapView {
        return MKMapView(frame: .zero)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
