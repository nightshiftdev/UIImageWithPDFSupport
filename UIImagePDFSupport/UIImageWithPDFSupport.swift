//
//  UIImageWithPDFSupport.swift
//  CloudFoundryApps
//
//  Created by Pawel Kijowski Silver on 3/7/17.
//  Copyright © 2017 Pawel Kijowski. All rights reserved.
//

import UIKit
import CoreImage
import ImageIO

extension UIImage {
    
    public convenience init?(pdfFileName: String, desiredSize: CGSize) {
        if desiredSize.width <= 0 || desiredSize.height <= 0 { return nil; }
        guard let pdfDocument = UIImage.createPDFDocumentWith(name: pdfFileName) else { return nil; }
        guard let image = UIImage.imageFrom(pdfDocument: pdfDocument, desiredSize: desiredSize) else { return nil; }
        guard let cgImage = image.cgImage else { return nil; }
        self.init(cgImage: cgImage, scale: CGFloat(Float(cgImage.width)/Float(desiredSize.width)), orientation: .up)
    }
    
    private static func imageFrom(pdfDocument: CGPDFDocument, desiredSize: CGSize) -> UIImage? {
        var image: UIImage? = nil
        guard let firstPage = pdfDocument.page(at: 1) else { return image; }
        let firstPageBox = firstPage.getBoxRect(.cropBox)
        
        let imageWidth: size_t = size_t(ceilf(Float(desiredSize.width)))
        let imageHeight: size_t = size_t(ceilf(Float(desiredSize.height)))
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        
        guard let cgContext: CGContext = UIGraphicsGetCurrentContext() else { return image; }
        
        cgContext.saveGState()
        
        cgContext.translateBy(x: 0, y: desiredSize.height)
        cgContext.scaleBy(x: 1.0, y: -1.0)
        cgContext.translateBy(x: firstPageBox.minX, y: firstPageBox.minY)
        cgContext.scaleBy(x: desiredSize.width/firstPageBox.size.width, y: desiredSize.height/firstPageBox.size.height)
        
        cgContext.drawPDFPage(firstPage)
        
        cgContext.restoreGState()
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private static func createPDFDocumentWith(name: String) -> CGPDFDocument? {
        guard let pdfPath = Bundle.main.path(forResource: name, ofType: "pdf") else { return nil; }
        let url = URL(fileURLWithPath: pdfPath)
        let document = CGPDFDocument(url as CFURL)
        return document
    }
}
