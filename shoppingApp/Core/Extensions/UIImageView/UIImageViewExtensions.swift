//
//  UIImageViewExtensions.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 23.06.2022.
//

import Foundation
import UIKit

extension UIImageView{
    
    /*
    func giveGradient(withBackgroundColor backgroundColor : UIColor?) {
        
        let finalColor = backgroundColor ?? UIColor.systemBackground
        let initialColor = finalColor.withAlphaComponent(0.0)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.colors = [initialColor.cgColor, finalColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect(
            x: self.bounds.origin.x,
            y: self.bounds.origin.y + self.bounds.height / 2,
            width: self.bounds.width,
            height: self.bounds.height / 2)
        self.layer.addSublayer(gradientLayer)
    }
     */
    
    func animateImage() {
        UIView.animate(withDuration: 0.1, animations: {
            //let newImage = isFavourited ? UIImage(named: "bookmark.fill"): UIImage(named: "bookmark")
            self.transform = self.transform.scaledBy(x: 1.3, y: 1.3)
            //self.image = newImage
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
    
    /*
    func setImage(withPath imagePath: String?, cornerRadius: CGFloat? = nil, placeholder : UIImage? = nil) {
        
        guard let imagePath = imagePath else {
            if let placeholder = placeholder {
                self.image = placeholder
                print("Job failed: Image on path does not exist. Placeholder used instead.")
            } else{
                print("Job failed: Image on path does not exist.")
            }
            return
        }
        
        guard let url = URL(string: imagePath) else {
            if let placeholder = placeholder {
                self.image = placeholder
                print("Job failed: URL does not exist. Placeholder used instead.")
            } else{
                print("Job failed: URL does not exist.")
            }
            return
        }
        
        var processor: ImageProcessor
        if let cornerRadius = cornerRadius {
            processor = DownsamplingImageProcessor(size: self.bounds.size)
                         |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
        }
        else{
            processor = DownsamplingImageProcessor(size: self.bounds.size)
        }
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            //placeholder: UIImage(named: "placeholderImage"), //Placeholder to use when image is being downloaded
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                if let placeholder = placeholder {
                    self.image = placeholder
                    print("Job failed: \(error.localizedDescription) Placeholder used instead.")
                } else{
                    self.image = UIImage.emptyImage
                    print("Job failed: \(error.localizedDescription) Empty image used instead.")
                }
            }
        }
        
    }
     */
}
