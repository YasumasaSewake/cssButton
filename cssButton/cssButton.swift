//
//  cssButton.swift
//  cssButton
//
//  Created by sewakeyasumasa on 2016/05/01.
//  Copyright © 2016年 Yasumasa Sewake. All rights reserved.
//

import Foundation
import UIKit

class cssButton : UIButton
{
  private static let speed : CGFloat = 0.1

  var annimationLayer : AnimationLayer = AnimationLayer()
  var bottomLayer     : BotLayer = BotLayer()

  var _direction : Direction = .None
  var _progress  : CGFloat = 0
  var _buttonStyle : Style = .FadeIn
  
  var defaultColor  : RGBA = RGBA( r:0.0, g:0.0, b:0.0, a:0.0)
  private var _displayLink : CADisplayLink? = nil
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)
    
    self.layer.insertSublayer(annimationLayer, atIndex:1)
    self.layer.insertSublayer(bottomLayer, atIndex:0)

    // ここをコメントアウトして動かすとおおよそがわかるかも
    self.layer.masksToBounds = true
    
    // 基準の色として保存
    self.titleLabel!.textColor!.getRed(&defaultColor.r, green:&defaultColor.g, blue:&defaultColor.b, alpha:&defaultColor.a)
    _initDisplayLink()
  }
  
  override func layoutSubviews() {

    super.layoutSubviews()

    annimationLayer.frame = self.bounds
    bottomLayer.frame = self.bounds
    
    // 回転の時に必要（この処理がないと文字色が更新されなくなる）
    self.setNeedsDisplay()
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
  {
    if nil != touches.first?.locationInView(self)
    {
      _transition( Direction.Normal )
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
  {
    if nil != touches.first?.locationInView(self)
    {
      _transition( Direction.Reverse )
    }
  }
  
  override func drawRect(rect: CGRect)
  {
    super.drawRect(rect)
    
    // タイトルカラーを変える
    // ベースの色の調整
    let p : CGFloat = _calcProgress(_progress)
    
    let baseRgb : RGBA = RGBA(r:self.defaultColor.r - (self.defaultColor.r * p),
                              g:self.defaultColor.g - (self.defaultColor.g * p),
                              b:self.defaultColor.b - (self.defaultColor.b * p),
                              a:1)

    let rgb : RGBA    = self._getTextColor()
    let goalRgb : RGBA = RGBA(r:rgb.r - (rgb.r * (1 - p)),
                              g:rgb.g - (rgb.g * (1 - p)),
                              b:rgb.b - (rgb.b * (1 - p)),
                              a:1)

    let fixColor : UIColor = UIColor(red:baseRgb.r + goalRgb.r, green:baseRgb.g + goalRgb.g, blue:baseRgb.b + goalRgb.b, alpha:1)
    self.titleLabel?.textColor = fixColor
  }
  
  func _getTextColor() -> RGBA
  {
    switch ( _buttonStyle )
    {
    case .FadeIn:
      return ColorMap.white
    case .FadeIn_Border:
      return ColorMap.blue
    case .Split_Vertical:
      return ColorMap.blue
    case .Split_Horizontal:
      return ColorMap.blue
    case .Slide_Upper:
      return ColorMap.white
    case .Slide_UpperLeft:
      return ColorMap.white
    case .Zoom:
      return ColorMap.white
    case .Spin:
      return ColorMap.white
    }
  }
  
  func _transition( direction : Direction )
  {
    self._direction = direction
    _startDisplayLink()
  }
  
  func buttonStyle( style : Style )
  {
    _buttonStyle = style
    
    annimationLayer.buttonStyle(style)
    bottomLayer.buttonStyle(style)
  }
  
//MARK:DisplayLink
  private func _initDisplayLink()
  {
    self._displayLink = CADisplayLink.init(target:self, selector:#selector(cssButton._displayRefresh(_:)))
    self._displayLink?.frameInterval = 1
    self._displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode:NSRunLoopCommonModes)
    self._displayLink?.paused = true
  }
  
  private func _startDisplayLink()
  {
    self._displayLink?.paused = false
  }
  
  private func _stopDisplayLink()
  {
    self._displayLink?.paused = true
  }
  
  @objc private func _displayRefresh(displayLink:CADisplayLink)
  {
    var stop : Bool = false
    
    if self._direction == .Normal
    {
      _progress += cssButton.speed
      if _progress >= 1.0
      {
        _progress = 1.0
        stop = true
      }
    }
    else if self._direction == .Reverse
    {
      _progress -= cssButton.speed
      if _progress <= 0.0
      {
        _progress = 0.0
        stop = true
      }
    }
    
    self.bottomLayer.progress     = _progress
    self.annimationLayer.progress = _calcProgress(_progress)
    self.annimationLayer.setNeedsDisplay()
    self.setNeedsDisplay()
    
    switch ( _buttonStyle )
    {
    case .Split_Vertical:
      bottomLayer.setNeedsDisplay()
    case .Split_Horizontal:
      bottomLayer.setNeedsDisplay()
    case .Slide_Upper:
      bottomLayer.setNeedsDisplay()
    case .Slide_UpperLeft:
      bottomLayer.setNeedsDisplay()
    case .Zoom:
      bottomLayer.setNeedsDisplay()
    case .Spin:
      bottomLayer.setNeedsDisplay()
    default:
      break;
    }

    if stop == true
    {
      _stopDisplayLink()
    }
  }
  
  func _calcProgress( x : CGFloat ) -> CGFloat
  {
    let x1 : CGFloat = 0
    let y1 : CGFloat = 0
    
    let x2 : CGFloat = 0.4
    let y2 : CGFloat = 0.7
    
    let x3 : CGFloat = 1
    let y3 : CGFloat = 1
    
    let a : CGFloat = ((y1 - y2) * (x1 - x3) - (y1 - y3) * (x1 - x2)) / ((x1 - x2) * (x1 - x3) * (x2 - x3))
    let b : CGFloat = (y1 - y2) / (x1 - x2) - a * (x1 + x2);
    let c : CGFloat = y1 - a * x1 * x1 - b * x1;
    
    let y : CGFloat = a * (x * x) + b * x + c

    return y
  }
}