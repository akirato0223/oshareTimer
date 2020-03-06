//
//  addBackground.swift
//  TodoList
//
//  Created by あきら on 3/6/20.
//  Copyright © 2020 Akira. All rights reserved.
//

import UIKit

extension UIView {
    
    
    func addBackground(name: String) {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: name)
        
        imageViewBackground.contentMode = .scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
}
