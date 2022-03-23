//
//  ContentView.swift
//  testTask
//
//  Created by Алина Дьяченко on 06.03.2022.
//

import SwiftUI
import RxSwift

struct ContentView: View {
    
    @EnvironmentObject var controller: ContentViewController
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter some text to search", text: $searchText)
                    .frame(width: 300, height: 0, alignment: .center)
                    .padding(EdgeInsets(top: 20, leading: 6, bottom: 20, trailing: 6))
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1.0))
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                
                Button(action: {
                    controller.appServerClient.name = searchText
                    controller.offset = 10
                    controller.tracks = []
                    
                    getAsyncTracks()
                    
                }) {
                    Text("Search")
                }
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                .foregroundColor(.white)
                .background(Color.green)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1.0).foregroundColor(.green))
                .padding(.bottom, 40)
                .alert(isPresented: $controller.failedDownloading) {
                    Alert(title: Text("Error"), message: Text("Downloading data is failed. There are no such tracks."), dismissButton: .default(Text("Ok")))
                }
                
                
                List(controller.tracks) { track in
                    NavigationLink(destination:
                                    DetailView(controller: DetailViewController(detailUrl: track.href ?? ""))
                                   , label: {
                        if track.thread == 1 {
                            Text("\(track.name)")
                                .background(Color.mintGreenColor)
                        } else if track.thread == 2 {
                            Text("\(track.name)")
                                .background(Color.yellowColor)
                        }
                        
                    })
                }
                
            }
            .onAppear {
                guard
                    let data = UserDefaults.standard.data(forKey: "tracks"),
                    let savedItems = try? JSONDecoder().decode([Item].self, from: data)
                else {return}
                controller.tracks = savedItems
                
            }
        }
        .navigationTitle("List of tracks")
        
    }
    
    
    func parallelReq(offset: Int, thread: Int) {
        controller.appServerClient.makeTracksReq(name: searchText, offset: offset) {result in
            switch result {
            case .success(var tracks):
                for index in 0..<tracks.count {
                    tracks[index].thread = thread
                }
                controller.tracks += tracks
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                controller.failedDownloading = true
            }
        }
    }
    
    func getAsyncTracks() {
        DispatchQueue.global().async {
            parallelReq(offset: 0, thread: 1)
            controller.offset += 10
            parallelReq(offset: controller.offset, thread: 1)
        }
        
        DispatchQueue.global().async {
            parallelReq(offset: 10, thread: 2)
            controller.offset += 10
            parallelReq(offset: controller.offset, thread: 2)
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
