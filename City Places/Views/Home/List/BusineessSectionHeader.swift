//
//  BusineessSectionHeader.swift
//  City Places
//
//  Created by Juan Hernandez Pazos on 02/08/22.
//

import SwiftUI

struct BusineessSectionHeader: View {
    
    var title: String
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.white)
            
            Text(title)
                .font(.headline)
        }
    }
}

struct BusineessSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        BusineessSectionHeader(title: "Sights")
    }
}
