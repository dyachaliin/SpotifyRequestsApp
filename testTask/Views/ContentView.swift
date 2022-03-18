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
                    controller.offset = 0
                    controller.tracks = []
                    
                   let firstreq = controller.appServerClient.makeTracksReq(name: searchText, offset: controller.offset).debug().do(onNext: { el in
                        if var items = el.tracks.items{
                            for index in 0..<items.count {
                                items[index].thread = 1
                            }
                            controller.tracks += items
                        }}, onError: {_ in
                            controller.failedDownloading = true
                        }, onCompleted: {
                            print("req1 has been completed in first stream")
                            if controller.offset < 20 {
                                controller.offset += 20
                                controller.appServerClient.makeTracksReq(name: searchText, offset: controller.offset).do(onNext: { el in
                                    if var items = el.tracks.items{
                                        for index in 0..<items.count {
                                            items[index].thread = 1
                                        }
                                        controller.tracks += items
                                    }}, onError: { _ in
                                        controller.failedDownloading = true
                                    }).subscribe().disposed(by: controller.disposeBag)

                                    } else {
                                        controller.offset += 10
                                        controller.appServerClient.makeTracksReq(name: searchText, offset: controller.offset).do(onNext: { el in
                                            if var items = el.tracks.items{
                                                for index in 0..<items.count {
                                                    items[index].thread = 1
                                                }
                                                controller.tracks += items
                                            }}, onError: { _ in
                                                controller.failedDownloading = true
                                            }).subscribe().disposed(by: controller.disposeBag)
                                            }
                        })
//
                   let secreq = controller.appServerClient.makeTracksReq(name: searchText, offset: controller.offset + 10).debug().do(onNext: { el in
                        if var items = el.tracks.items{
                            for index in 0..<items.count {
                                items[index].thread = 2
                            }
                            controller.tracks += items
                        }}, onError: {_ in
                            controller.failedDownloading = true
                        }, onCompleted: {
                            print("req2 has been completed in second stream")
                            if controller.offset < 20 {
                                controller.offset += 20
                                controller.appServerClient.makeTracksReq(name: searchText, offset: controller.offset).do(onNext: { el in
                                    if var items = el.tracks.items{
                                        for index in 0..<items.count {
                                            items[index].thread = 2
                                        }
                                        controller.tracks += items
                                    }}, onError: { _ in
                                        controller.failedDownloading = true
                                    }).subscribe().disposed(by: controller.disposeBag)

                                    } else {
                                        controller.offset += 10
                                        controller.appServerClient.makeTracksReq(name: searchText, offset: controller.offset).do(onNext: { el in
                                            if var items = el.tracks.items{
                                                for index in 0..<items.count {
                                                    items[index].thread = 2
                                                }
                                                controller.tracks += items
                                            }}, onError: { _ in
                                                controller.failedDownloading = true
                                            }).subscribe().disposed(by: controller.disposeBag)
                                            }
                        })
                    
                    
                    let finalSequence = Observable.zip(firstreq, secreq)
                    finalSequence.debug().subscribe().disposed(by: controller.disposeBag)
                    
                }) {
                    Text("Search")
                }
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                .foregroundColor(.white)
                .background(Color.green)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1.0).foregroundColor(.green))
                .padding(.bottom, 40)
                .alert(isPresented: $controller.failedDownloading) {
                    Alert(title: Text("Error"), message: Text("Downloading data is failed. Enter the text correctly."), dismissButton: .default(Text("Ok")))
                }
                
    
                List(controller.tracks) { track in
                    NavigationLink(destination:
                                    DetailView(controller: DetailViewController(detailUrl: track.href ?? "") )
                                   
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
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
