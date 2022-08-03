//
//  BusinessSection.swift
//  City Places
//
//  Created by Juan Hernandez Pazos on 02/08/22.
//

import SwiftUI

struct BusinessSection: View {
    
    var title: String
    var businesses: [Business]
    
    var body: some View {
        Section(header: BusineessSectionHeader(title: title)) {
            ForEach(businesses) { business in
                NavigationLink(destination: BusinessDetail(business: business)) {
                    BusinessRow(business: business)
                }
            }
        }
    }
}
