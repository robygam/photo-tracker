//
//  PhotoDetail.swift
//  PhotoTracker
//
//  Created by Roberto Garcia on 27/08/2022.
//

import SwiftUI
import MapKit

struct PhotoDetailLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct PhotoDetail: View {
    var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.photo.title)
                .font(.system(size: 25, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.blue)
            AsyncImage(url: URL(string: viewModel.photo.photoURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, minHeight: 100)
                        .cornerRadius(12)
                case .failure:
                    HStack(spacing: 8) {
                        Image(systemName: "photo")
                        Text("Error fetching image")
                    }
                @unknown default:
                    EmptyView()
                }
            }
            let mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: viewModel.photo.lat, longitude: viewModel.photo.lon), span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
            let location = PhotoDetailLocation(coordinate: CLLocationCoordinate2D(latitude: viewModel.photo.lat, longitude: viewModel.photo.lon))
            Map(coordinateRegion: .constant(mapRegion), interactionModes: [], annotationItems: [location]) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Circle()
                        .strokeBorder(.white, lineWidth: 2)
                        .background(content: {
                            Circle().foregroundColor(.blue)
                            Image(systemName: "camera").foregroundColor(.white)
                        })
                        .frame(width: 44, height: 44)
                }
            }
        }
        .padding(16)
    }
}

struct PhotoDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        PhotoDetail(viewModel: PhotoDetail.ViewModel(photo: Photo(latitude: 42.40364319359173, longitude: -8.81154541729284, photoURL: "https://sp-ao.shortpixel.ai/client/q_lossy,ret_img,w_600/https://www.senderismoeuropa.com/wp-content/uploads/2014/10/trekking-senderismo-hiking-excursionismo2-600x399.jpg", title: "Test Photo")))
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
}

extension PhotoDetail {
    struct ViewModel {
        let photo: Photo
    }
}
