//
//  UIImage.swift
//  Assignments
//
//  Created by Andrey Sak on 5/13/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation

extension UIImage {
    
    func fixOrientation() -> UIImage {
        // No-op if the orientation is already correct
        if imageOrientation == .up {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = .identity
        
        if imageOrientation == .down || imageOrientation == .downMirrored {
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        }
        
        if imageOrientation == .left || imageOrientation == .leftMirrored {
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        }
        
        if imageOrientation == .right || imageOrientation == .rightMirrored {
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -(CGFloat.pi / 2));
        }
        
        if imageOrientation == .upMirrored || imageOrientation == .downMirrored {
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if imageOrientation == .leftMirrored || imageOrientation == .rightMirrored {
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!
        
        ctx.concatenate(transform)
        
        if imageOrientation == .left || imageOrientation == .leftMirrored || imageOrientation == .right || imageOrientation == .rightMirrored {
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
    
}
