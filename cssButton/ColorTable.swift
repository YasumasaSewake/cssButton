//
//  ColorTable.swift
//  cssButton
//
//  Created by sewake on 2016/05/01.
//  Copyright © 2016年 Yasumasa Sewake. All rights reserved.
//

import Foundation
import UIKit

struct RGBA {
  var r : CGFloat
  var g : CGFloat
  var b : CGFloat
  var a : CGFloat
}

class ColorMap {
  
  static var blue : RGBA {
    get {
      return RGBA( r:0.1, g:0.8, b:1.0, a:1.0)
    }
  }

  static var white : RGBA {
    get {
      return RGBA( r:1.0, g:1.0, b:1.0, a:1.0)
    }
  }

  static var black : RGBA {
    get {
      return RGBA( r:0.2, g:0.2, b:0.2, a:1.0)
    }
  }

  static var clear : RGBA {
    get {
      return RGBA(r:1.0, g:1.0, b:1.0, a:0.0)
    }
  }
}