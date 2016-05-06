//
//  AnimationLayer.swift
//  cssButton
//
//  Created by sewake on 2016/05/01.
//  Copyright © 2016年 Yasumasa Sewake. All rights reserved.
//

import Foundation
import UIKit


class AnimationLayer : CALayer {
  
  var baseColor   : RGBA = RGBA( r:0.0, g:0.0, b:0.0, a:1.0)
  var botColor    : RGBA = RGBA( r:0.0, g:0.0, b:0.0, a:1.0)
  
  private var _buttonStyle : Style = .FadeIn

  var progress : CGFloat = 0 // 0は初期状態, 1が最終
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)
    
    _init()
  }
  
  override init() {
    super.init()
    _init()
  }
  
  override init(layer: AnyObject)
  {
    super.init(layer: layer)
  }
  
  func _init()
  {
    let bgColor : UIColor = UIColor(red:baseColor.r, green:baseColor.g, blue:baseColor.b, alpha:baseColor.a)
    self.backgroundColor = bgColor.CGColor
  }
    
  override func drawInContext(ctx: CGContext)
  {
    super.drawInContext(ctx)

    switch ( _buttonStyle ) {
      
    case .Spin:
      _Spin_background()
      break;

    default:
      _fadeOut_background()
    }
  }
  
  func buttonStyle( style : Style )
  {
    _buttonStyle = style
    switch ( _buttonStyle ) {
    case .Slide_Upper:
      baseColor = ColorMap.clear
    case .Slide_UpperLeft:
      baseColor = ColorMap.clear
    case .Zoom:
      baseColor = ColorMap.clear
    case .Spin:
      baseColor = ColorMap.black
      _Spin_background()
      return
    default:
      baseColor = ColorMap.black
    }
    
    _init()
  }
  
  private func _Spin_background()
  {
    let alpha : CGFloat = baseColor.a * progress
    let bgColor : UIColor = UIColor(red:baseColor.r, green:baseColor.g, blue:baseColor.b, alpha:alpha)
    
    // 回転
    let transform = CATransform3DMakeRotation(progress * CGFloat(M_PI), 0.0, 0.0, 1.0);           // 回転
    self.transform = transform
    
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanFalse, forKeyPath: kCATransactionDisableActions)
    self.backgroundColor = bgColor.CGColor
    CATransaction.commit()
  }
  
  private func _fadeOut_background()
  {
    let alpha : CGFloat = baseColor.a - ( 1 * progress )
    let bgColor : UIColor = UIColor(red:baseColor.r, green:baseColor.g, blue:baseColor.b, alpha:alpha)
    
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanFalse, forKeyPath: kCATransactionDisableActions)
    self.backgroundColor = bgColor.CGColor
    CATransaction.commit()
  }
  
}
