import SwiftUI
import CoreLocation.CLLocation
import MapKit.MKAnnotationView
import MapKit.MKUserLocation

struct MapView: View {
    
    @State private var userTrackingMode: MKUserTrackingMode = .none
    @EnvironmentObject var manager : WeatherManager
    var location: Location {
        return manager.weather?.location ?? Location(
        name: "Name", region: "Region", country: "Country", localtime: "Local Time"
        )
    }
    var locationText : String
    {
        return location.name + " , " + location.region + " , " + location.country;
    }
    var body: some View {
    
            ZStack(){
                MKMapViewRepresentable(userTrackingMode: $userTrackingMode)
                    .environmentObject(MapViewContainer())
                    .environmentObject(manager)
                    .edgesIgnoringSafeArea(.all)
                GeometryReader
                {
                    geometry in
                    VStack(alignment : .trailing) {

                        
                        Text(locationText)
                                .frame(width : geometry.size.width )
                                .padding(.top)
                                .padding(.bottom)
                                .background(Color(UIColor.secondarySystemBackground).clipShape(RoundedRectangle(cornerRadius:10)))
                        
                        if !(userTrackingMode == .follow || userTrackingMode == .followWithHeading) {
                                Button(action: { self.followUser() }) {
                                    Image(systemName : "location")
                                        .frame(width : 50 , height : 50 , alignment : .center)
                                        .background(Color(UIColor.secondarySystemBackground).clipShape(RoundedRectangle(cornerRadius:10)))
                                        .padding(.top)
                                    
                                }
                        
                        }
                        Spacer()
                    }
                }.padding()
        }
        
    }
    
    private func followUser() {
        userTrackingMode = .follow
    }
    
}

fileprivate struct MapButton: ViewModifier {
    
    let backgroundColor: Color
    var fontColor: Color = Color(UIColor.systemBackground)
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(self.backgroundColor.opacity(0.9))
            .foregroundColor(self.fontColor)
            .font(.title)
    }
    
}
struct MapView_Preview: PreviewProvider {
    static var previews: some View {
        
        MapView().environmentObject(WeatherManager())
    }
}
