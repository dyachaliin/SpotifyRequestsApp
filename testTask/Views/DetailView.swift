//
//  DetailView.swift
//  testTask
//
//  Created by Алина Дьяченко on 15.03.2022.
//

import SwiftUI

struct DetailView: View {
    
    
    @ObservedObject var controller: DetailViewController
        
    var body: some View {
        GeometryReader{ geometry in

            VStack {
                Text("Detail information:")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.lightColor)
                    .padding(.bottom, 6)
                
//                    .font(.system(size: 30, weight: .bold))
//                    .italic()
//                    .foregroundColor(Color(red: 254/255, green: 254/255, blue: 254/255))
//                    .frame(width: geometry.size.width - 10, height: 15, alignment: .center)
                VStack {
                    Text("Type of album: \(controller.albumtype)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.yellowColor)
                        .padding(.bottom, 3)
                        .multilineTextAlignment(.center)
                    Text("Name of album: \(controller.albumName)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.yellowColor)
                        .padding(.bottom, 3)
                        .multilineTextAlignment(.center)
                    Text("Name of artist: \(controller.artistName)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.yellowColor)
                        .padding(.bottom, 3)
                        .multilineTextAlignment(.center)
                    Text("Date of release: \(controller.releaseDate)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.yellowColor)
                        .padding(.bottom, 3)
                        .multilineTextAlignment(.center)
                    
                }
                .padding()
                .padding(.horizontal, 20)
                .background(Color.mintGreenColor)
                .cornerRadius(40)
                .offset(y: 10)
                
                Text("Album cover:")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.lightColor)
                    .padding()
                    .multilineTextAlignment(.center)
                AsyncImage(url: URL(string: controller.imageURL))
                    .padding(.top, 12)
                
            }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
//                    .padding()
//                    .padding(.horizontal, 10)
                .background(Color.mintGreenColor.opacity(0.6))
                    .cornerRadius(40)

           

        }
        .onAppear{
            
            controller.appServerClient.makeHREFReq(href: controller.detailUrl, onResult: { result in
                controller.albumtype = result.album.albumType
                controller.artistName = result.artists.first?.name ?? "There was no name"
                controller.imageURL = result.album.images[1].url ?? ""
                controller.releaseDate = result.album.releaseDate
                controller.albumName = result.album.name
            }, onFailure: {_ in
                controller.failedDownloading = true
            })
              
        }
        .alert(isPresented: $controller.failedDownloading) {
            Alert(title: Text("Error"), message: Text("Downloading data is failed"), dismissButton: .default(Text("Ok")))
        }
       
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(controller: DetailViewController(detailUrl:""))
    }
}
