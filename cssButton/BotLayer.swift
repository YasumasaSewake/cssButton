//
//  BotLayer.swift
//  cssButton
//
//  Created by sewake on 2016/05/01.
//  Copyright © 2016年 Yasumasa Sewake. All rights reserved.
//

import Foundation
import UIKit

class BotLayer : CALayer {
  private static let _borderWidth : CGFloat = 2.0
  var progress : CGFloat = 0 // 0は初期状態, 1が最終

  var _buttonStyle : Style   = .FadeIn
  var background : RGBA = RGBA( r:0.0, g:0.0, b:0.0, a:0.0)
  var border     : RGBA = RGBA( r:0.0, g:0.0, b:0.0, a:0.0)
  var layerColor : RGBA = RGBA( r:0.0, g:0.0, b:0.0, a:1.0)

  var commonLayer1 : CALayer = CALayer() // 汎用レイヤー
  var commonLayer2 : CALayer = CALayer() // 汎用レイヤー
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)

    _init()
  }
  
  override init() {
    super.init()
    
    _init()
  }

  func _init()
  {
    self.addSublayer(commonLayer1)
    self.addSublayer(commonLayer2)
  }

  override init(layer: AnyObject)
  {
    super.init(layer: layer)
  }
  
  override func drawInContext(ctx: CGContext)
  {
    super.drawInContext(ctx)
    
    switch ( _buttonStyle ) {
    case .Split_Vertical:
      _animation_SplitVertical()
    case .Split_Horizontal:
      _animation_SplitHorizontal()
    case .Slide_Upper:
      _animation_SlideUpper()
    case .Slide_UpperLeft:
      _animation_SlideUpperLeft()
    case .Zoom:
      _animation_Zoom(ctx)
    case .Spin:
      break;
    default:
      break;
    }
    
  }
  
  private func _animation_SplitVertical()
  {
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanFalse, forKeyPath: kCATransactionDisableActions)
    commonLayer1.frame = CGRectMake(0 - self.frame.width/2 * progress, 0, self.frame.width / 2, self.frame.height)
    commonLayer2.frame = CGRectMake(self.frame.width / 2 + self.frame.width/2 * progress, 0, self.frame.width / 2, self.frame.height)
    CATransaction.commit()
  }

  private func _animation_SplitHorizontal()
  {
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanFalse, forKeyPath: kCATransactionDisableActions)
    commonLayer1.frame = CGRectMake(0, 0 - self.frame.height / 2 * progress, self.frame.width, self.frame.height / 2)
    commonLayer2.frame = CGRectMake(0, self.frame.height / 2 + self.frame.height / 2 * progress, self.frame.width, self.frame.height / 2)
    CATransaction.commit()
  }
  
  private func _animation_SlideUpper()
  {
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanFalse, forKeyPath: kCATransactionDisableActions)
    commonLayer1.frame = CGRectMake(0, -self.frame.height + self.frame.height * progress, self.frame.width, self.frame.height)
    commonLayer1.opacity = Float(progress)
    CATransaction.commit()
  }
  
  private func _animation_SlideUpperLeft()
  {
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanFalse, forKeyPath: kCATransactionDisableActions)
    commonLayer1.frame = CGRectMake(-self.frame.width + self.frame.width * progress,
                                    -self.frame.height + self.frame.height * progress,
                                    self.frame.width,
                                    self.frame.height)
    commonLayer1.opacity = Float(progress)
    CATransaction.commit()
  }

  private func _animation_Zoom(ctx: CGContext)
  {
    // クリアカラーでの塗りつぶし
    if progress <= 0
    {
      return
    }
    
    CGContextSetRGBStrokeColor(ctx, layerColor.r, layerColor.g, layerColor.b, layerColor.a);
    let rect = _zoomRect()
    CGContextFillRect(ctx, rect);
  }

  private func _animation_Spin()
  {
  }

  private func _zoomRect() -> CGRect {
    let offsetX : CGFloat = (self.frame.width  / 4 * progress)
    let offsetY : CGFloat = (self.frame.height / 4 * progress)
    let sizeX   : CGFloat = (self.frame.width  / 2 * progress)
    let sizeY   : CGFloat = (self.frame.height / 2 * progress)
    
    let rect : CGRect = CGRectMake(
                          self.frame.width/4  - offsetX,
                          self.frame.height/4 - offsetY,
                          self.frame.width/2  + sizeX,
                          self.frame.height/2 + sizeY );

    return rect
  }

  override func layoutSublayers() {
    super.layoutSublayers()
    
    switch ( _buttonStyle ) {
    case .Split_Vertical:
      commonLayer1.frame = CGRectMake(0, 0, self.frame.width / 2, self.frame.height)
      commonLayer2.frame = CGRectMake(self.frame.width / 2, 0, self.frame.width / 2, self.frame.height)
    case .Split_Horizontal:
      commonLayer1.frame = CGRectMake(0, 0, self.frame.width, self.frame.height / 2)
      commonLayer2.frame = CGRectMake(0, self.frame.height / 2, self.frame.width, self.frame.height / 2)
    case .Slide_Upper:
      commonLayer1.frame = CGRectMake(0, -self.frame.height, self.frame.width, self.frame.height)
    case .Slide_UpperLeft:
      commonLayer1.frame = CGRectMake(-self.frame.width, -self.frame.height, self.frame.width, self.frame.height)
    case .Zoom:
      commonLayer1.frame = self.bounds
    case .Spin:
      commonLayer1.frame = self.bounds
    default:
      break;
    }
  }
  
  func buttonStyle( style : Style )
  {
    _buttonStyle = style
    
    switch ( _buttonStyle ) {
    case .FadeIn:
      layerColor = ColorMap.clear
      background = ColorMap.blue
      border     = ColorMap.blue
    case .FadeIn_Border:
      layerColor = ColorMap.clear
      background = ColorMap.white
      border     = ColorMap.blue
    case .Split_Vertical:
      layerColor = ColorMap.blue
      background = ColorMap.white
      border     = ColorMap.blue
    case .Split_Horizontal:
      layerColor = ColorMap.blue
      background = ColorMap.white
      border     = ColorMap.blue
    case .Slide_Upper:
      layerColor = ColorMap.black
      background = ColorMap.white
      border     = ColorMap.black
    case .Slide_UpperLeft:
      layerColor = ColorMap.black
      background = ColorMap.white
      border     = ColorMap.black
    case .Zoom:
      layerColor = ColorMap.black
      background = ColorMap.white
      border     = ColorMap.black
      commonLayer1.removeFromSuperlayer()
      commonLayer2.removeFromSuperlayer()
    case .Spin:
      layerColor = ColorMap.black
      background = ColorMap.white
      border     = ColorMap.black
      commonLayer1.removeFromSuperlayer()
      commonLayer2.removeFromSuperlayer()
    }
    
    setupColor()
  }
  
  func setupColor()
  {
    let bgColor : UIColor = UIColor(red:background.r, green:background.g, blue:background.b, alpha:background.a)
    let bdColor : UIColor = UIColor(red:border.r, green:border.g, blue:border.b, alpha:border.a)
    
    self.backgroundColor  = bgColor.CGColor
    self.borderColor = bdColor.CGColor
    self.borderWidth = BotLayer._borderWidth

    let color = UIColor(red:layerColor.r, green:layerColor.g, blue:layerColor.b, alpha:layerColor.a)
    commonLayer1.backgroundColor = color.CGColor
    commonLayer2.backgroundColor = color.CGColor
  }
}