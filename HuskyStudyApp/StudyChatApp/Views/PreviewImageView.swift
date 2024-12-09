//
//  PreviewImageView.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/8/24.
//

import SwiftUI

struct PreviewImageView: View {
    
    let selectedImage: UIImage
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Image(uiImage: selectedImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }.overlay(alignment: .top) {
            Button {
                onCancel()
            } label: {
                Image(systemName: "multiply.circle.fill")
                    .padding([.top], 10)
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            
        }
    }
}
#Preview {
    PreviewImageView(selectedImage: UIImage(named: "sample")!, onCancel: { })
}



// Credit
/*
 Photo by <a href="https://unsplash.com/@marekpiwnicki?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Marek Piwnicki</a> on <a href="https://unsplash.com/photos/GAl1FSGVxEo?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
   
 */
