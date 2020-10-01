//
//  PointingView.swift
//  EyeTrackKit SwiftUI
//
//  Created by Yuki Yamato on 2020/10/01.
//

import SwiftUI

struct PointingView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.5))
                .frame(width: 25, height: 25)
                .position(x: 100, y: 100)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

struct PointingView_Previews: PreviewProvider {
    static var previews: some View {
        PointingView()
    }
}
