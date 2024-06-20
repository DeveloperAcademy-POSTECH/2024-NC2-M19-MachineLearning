//
//  MosuViewfinderView.swift
//  Nugunyang
//
//  Created by 원주연 on 6/18/24.
//

import SwiftUI

struct MosuViewfinderView: View {
    @Binding var image: Image?

    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct ViewfinderView_Previews: PreviewProvider {
    static var previews: some View {
        MosuViewfinderView(image: .constant(Image(systemName: "pencil")))
    }
}

