//
//  images.swift
//  Yelm.ProjectX
//
//  Created by Michael on 13.01.2021.
//

import Foundation
import SwiftUI
import Photos



struct ModalImages: View {
    
    
    @State var selected : [selected_images] = []
    @State var grid : [images] = []
    
    
    @ObservedObject var realm: RealmLocations = GlobalRealmLocations
    @ObservedObject var modal : ModalManager = GlobalModular
    @ObservedObject var location : location_cache = GlobalLocation
    
    
    @State var disabled = false
    
    
    @State var showmap : Bool = false
    
    
    
    func check(id: Int) -> Bool {
        
        let results = selected.filter { $0.id == id }
        let exists = results.isEmpty == false
        
        return exists
    }
    
    func get_images(){
        
        let options_fetch = PHFetchOptions()
        options_fetch.sortDescriptors =  [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let req = PHAsset.fetchAssets(with: .image, options: options_fetch)
        
        DispatchQueue.global().asyncAfter(deadline: .now()) {
       
            var id = 0
            req.enumerateObjects { (asset, _, _) in
                
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                options.deliveryMode = .opportunistic
                
                PHCachingImageManager.default().requestImage(for: asset, targetSize: .init(), contentMode: .default, options: options) { (image, _) in
                    
                    
                    
                    let images_data = images(id: id, image: image!, selected: false)
                    DispatchQueue.main.async {
                        self.grid.append(images_data)
                    }
                    id += 1
                    
                }
            }
            
        }
    }
    
    var body: some View {
        
        VStack(){
            Spacer()
            
            HStack{
                Spacer()
                Rectangle()
                    .background(Color.gray)
                    .cornerRadius(10)
                    .frame(width: 30, height: 5)
                    .opacity(0.4)
                Spacer()
            }.padding(.bottom, 5)
            VStack{
                VStack(){
                    Text("")
                        .frame(width: 10, height: 20)
                    HStack{
                        Text("Фотографии")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        Spacer()
                    }
                }.padding(.horizontal, 20)
                
                VStack{
//                    if (!self.grid.isEmpty){
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                
                                ForEach(self.grid, id: \.self){ image in
                                    
                                    ZStack(alignment: .topTrailing){
                                        Image(uiImage: image.image)
                                            .resizable()
                                            .cornerRadius(10)
                                            .frame(width: 80, height: 80)
                                            .padding(.trailing, 4)
                                        
                                        Image(systemName: check(id: image.id) ?  "checkmark.circle.fill" : "circle")
                                            .renderingMode(check(id: image.id) ? .original : .template)
                                            .foregroundColor(!check(id: image.id) ? Color.init(hex: "F2F3F4") : Color.theme)
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .frame(width: 20, height: 20)
                                            .offset(x: -11, y: 6)
                                            
                                    }
                                    .onTapGesture() {
                                        
                                        if (check(id: image.id)){
                                            
                                            selected.removeAll{$0.id == image.id}
                                            
                                        }else{
                                            self.selected.append(selected_images(id: image.id, image: image.image))
                                        }
                                        
                                    }
                                }
                                
                                Text("")
                                    .padding(.trailing, 10)
                                
                            }
                           
                            .padding(.leading, 20)
                        }.padding(.bottom, 10)
//                    }
                }.frame(height: 80)
                
                VStack{
                    HStack{
                        
                        Button(action: {
                            
                        }) {
                            HStack{
                                Spacer()
                                Text("Отправить: (\(selected.count))")
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }.buttonStyle(ScaleButtonStyle())
                        
                    }.padding(.bottom, 30)
                    
                    
                }.padding(.horizontal, 20)
            }
//            .frame(width: UIScreen.main.bounds.width, alignment: .center)
            .background(Color.white)
            .cornerRadius(30)
//            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 30))
        }
//        .frame(width: UIScreen.main.bounds.width)
        
        .onAppear {
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                if status == .authorized{
                    
                    self.get_images()
                    self.disabled = false
                }
                else{
                    
                    print("not authorized")
                    self.disabled = true
                }
            }
        }
        
        
    }
}

