//
//  ContentView.swift
//  arsimplesea
//
//  Created by Yasuhito NAGATOMO on 2022/03/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ARContainerView()
            .background(Color.blue)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
