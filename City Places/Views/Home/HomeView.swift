//
//  HomeView.swift
//  City Places
//
//  Created by Juan Hernandez Pazos on 02/08/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var isMapShowing = false
    
    var body: some View {
        VStack {
            if model.restaurants.count != 0 || model.sights.count != 0 {
                // Determine if we should list or map
                if !isMapShowing {
                    // Show list
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "location")
                            Text("San Francisco")
                            Spacer()
                            Text("Switch to map view")
                        }
                        Divider()
                        BusinessList()
                    }
                } else {
                    // Show map
                }
            } else {
                // Still waiting, show spinner
                ProgressView()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
