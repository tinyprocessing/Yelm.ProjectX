//
//  map.swift
//  Yelm.ProjectX
//
//  Created by Michael on 08.01.2021.
//

import Foundation
import MapKit
import YandexMapKit
import YandexMapKitSearch
import SwiftUI


var map_move = false

struct MapCreatePoint: UIViewRepresentable {

 
    
    class Coordinator: NSObject, YMKMapCameraListener, YMKUserLocationObjectListener, CLLocationManagerDelegate {
        
        func onObjectRemoved(with view: YMKUserLocationView) {
            
        }
        
        func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
            
        }
        
        
        @Binding var change_location : Bool
        

        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let userLocation = YMKPoint(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
            let TARGET_LOCATION = userLocation

            if (change_location == false){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    MapControll.mapWindow.map.move(
                              with: YMKCameraPosition(target: TARGET_LOCATION, zoom: 15, azimuth: 0, tilt: 0),
                        animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.4),
                              cameraCallback: nil)
                }
                
                change_location = true
            }

        }
        
        
        
        @Binding var MapControll: YMKMapView
        
        func onObjectAdded(with view: YMKUserLocationView) {
            view.arrow.setIconWith(UIImage(named:"UserArrow")!)
            let pinPlacemark = view.pin.useCompositeIcon()

            
            
            pinPlacemark.setIconWithName(
                           "pin",
                           image: UIImage(named:"SearchResult")!,
                           style:YMKIconStyle(
                               anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                               rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                               zIndex: 1,
                               flat: true,
                               visible: true,
                               scale: 1,
                               tappableArea: nil))


            view.accuracyCircle.fillColor = UIColor(red: 133/255, green: 193/255, blue: 233/255, alpha: 0.3)
            
        }

        
        
        var searchManager: YMKSearchManager?
        var searchSession: YMKSearchSession?
        @ObservedObject var service: MapService = GlobalMapService

        
        
        init(mapView: Binding<YMKMapView>, change_location: Binding<Bool>) {
            searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
            _MapControll = mapView
            _change_location = change_location
        }
        
        func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateSource: YMKCameraUpdateSource, finished: Bool) {
            
            
            if (finished){
                
              
                self.service.objectWillChange.send()
                self.service.found = true
                map_move = false
            
                let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
                              if let response = searchResponse {

                                if let res = response.collection.children[0].obj{

                                    self.service.objectWillChange.send()
                                    self.service.name = res.name!
                                    let position_to_server = "lat="+String(cameraPosition.target.latitude) + "&lon=" + String(cameraPosition.target.longitude)
                                    

                                    self.service.point = position_to_server
                                        
                                }


                              } else {
                                  print("error")
                              }
                          }
                
                searchSession = searchManager?.submit(with: cameraPosition.target, zoom: map.cameraPosition.zoom as NSNumber, searchOptions: YMKSearchOptions(), responseHandler: responseHandler)
                

            }else{
                
                if (map_move == false){
                    self.service.objectWillChange.send()
                    self.service.found = false
                    self.service.point = ""
                    map_move = true
                }

            }
        }
        
        
     
      
        
        
    }


    @Binding var YandexMap : YMKMapView
    @Binding var nativeLocationManagerNewValue : CLLocationManager
    @Binding var location_update_allow : Bool
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapView: $YandexMap, change_location: $location_update_allow)
    }
    func makeUIView(context: Context) -> YMKMapView {
        
     

        
        
      
        
        YandexMap.mapWindow.map.isRotateGesturesEnabled = false
        
        let objects = YandexMap.mapWindow.map.mapObjects
        print(objects)
        
//        YandexMap.mapWindow.map.addInertiaMoveListener(with: context.coordinator)

        YandexMap.mapWindow.map.addCameraListener(with: context.coordinator)

        
//        let scale = UIScreen.main.scale
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationLayer = mapKit.createUserLocationLayer(with: YandexMap.mapWindow)

        
        
//        let locationManager = mapKit.createLocationManager()
//
//        locationManager.requestSingleUpdate(withLocationListener: context.coordinator)
//        locationManager.subscribeForLocationUpdates(withDesiredAccuracy: 0, minTime: 10, minDistance: 0, allowUseInBackground: true, filteringMode: .on, locationListener: context.coordinator)
//        locationManager.resume()
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setObjectListenerWith(context.coordinator)
        
//        userLocationLayer.setAnchorWithAnchorNormal(CGPoint(x: 0.5 * YandexMap.frame.size.width * scale, y: 0.5 * YandexMap.frame.size.height * scale), anchorCourse: CGPoint(x: 0.5 * YandexMap.frame.size.width * scale, y: 0.83 * YandexMap.frame.size.height * scale))
       
        let TARGET_LOCATION_new = YMKPoint(latitude: 54.782635, longitude: 32.045251)
        
        YandexMap.mapWindow.map.move(
                  with: YMKCameraPosition(target: TARGET_LOCATION_new, zoom: 15, azimuth: 0, tilt: 0),
                  animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),
                  cameraCallback: nil)
        
       
        
        nativeLocationManagerNewValue.requestAlwaysAuthorization()
        nativeLocationManagerNewValue.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("CLLocationManager.locationServicesEnabled() ")
               
            
            #if targetEnvironment(simulator)
                let TARGET_LOCATION = YMKPoint(latitude: 54.782635, longitude: 32.045251)

                
                YandexMap.mapWindow.map.move(
                          with: YMKCameraPosition(target: TARGET_LOCATION, zoom: 15, azimuth: 0, tilt: 0),
                          animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
                          cameraCallback: nil)
            #else
            print(" nativeLocationManager.delegate = context.coordinator")
                nativeLocationManagerNewValue.delegate = context.coordinator
                nativeLocationManagerNewValue.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                nativeLocationManagerNewValue.requestAlwaysAuthorization()
                nativeLocationManagerNewValue.startUpdatingLocation()
            
            #endif
                
            
        }else{
            
            let TARGET_LOCATION = YMKPoint(latitude: 54.782635, longitude: 32.045251)

            
            YandexMap.mapWindow.map.move(
                      with: YMKCameraPosition(target: TARGET_LOCATION, zoom: 15, azimuth: 0, tilt: 0),
                      animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
                      cameraCallback: nil)
            
        }

        
        return YandexMap
    }




     func updateUIView(_ uiView: YMKMapView, context: Context) {
        

    }

}



struct MapHistory: UIViewRepresentable {

 
    
    class Coordinator: NSObject, YMKMapCameraListener, YMKUserLocationObjectListener {
        
        func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateSource: YMKCameraUpdateSource, finished: Bool) {
            
        }
        
        
        func onObjectRemoved(with view: YMKUserLocationView) {
            
        }
        
        func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
            
        }
        
        
        @Binding var MapControll: YMKMapView
        
        func onObjectAdded(with view: YMKUserLocationView) {
            
        }

        
        
        var searchManager: YMKSearchManager?
        var searchSession: YMKSearchSession?
        @ObservedObject var service: MapService = GlobalMapService

        
        
        init(mapView: Binding<YMKMapView>) {
            _MapControll = mapView
        }
        
        
        
    }


    @Binding var YandexMap : YMKMapView
    @Binding var location_update_allow : Bool
    @Binding var point : YMKPoint
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapView: $YandexMap)
    }
    func makeUIView(context: Context) -> YMKMapView {
        

        YandexMap.mapWindow.map.isRotateGesturesEnabled = false
        

        YandexMap.mapWindow.map.addCameraListener(with: context.coordinator)

        
        YandexMap.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width+20, height: 295)

        let mapKit = YMKMapKit.sharedInstance()
        

        let TARGET_LOCATION = YMKPoint(latitude: point.latitude, longitude: point.longitude)
        
        YandexMap.mapWindow.map.move(
                  with: YMKCameraPosition(target: TARGET_LOCATION, zoom: 13, azimuth: 0, tilt: 0),
                  animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),
                  cameraCallback: nil)
        
    
        
        return YandexMap
    }




     func updateUIView(_ uiView: YMKMapView, context: Context) {
        

    }

}
