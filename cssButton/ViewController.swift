//
//  ViewController.swift
//  cssButton
//
//  Created by sewakeyasumasa on 2016/05/01.
//  Copyright © 2016年 Yasumasa Sewake. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var buttonFadeIn: cssButton!
  @IBOutlet weak var buttonFadeInBorder: cssButton!
  @IBOutlet weak var button_split_v: cssButton!
  @IBOutlet weak var button_split_h: cssButton!
  @IBOutlet weak var button_slide_u: cssButton!
  @IBOutlet weak var button_slide_ul: cssButton!
  @IBOutlet weak var button_zoom: cssButton!
  @IBOutlet weak var button_spin: cssButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    buttonFadeIn.buttonStyle( .FadeIn )  //       = .FadeIn
    buttonFadeInBorder.buttonStyle(.FadeIn_Border)
    button_split_v.buttonStyle(.Split_Vertical)
    button_split_h.buttonStyle(.Split_Horizontal)
    button_slide_u.buttonStyle(.Slide_Upper)
    button_slide_ul.buttonStyle(.Slide_UpperLeft)
    button_zoom.buttonStyle(.Zoom)
    button_spin.buttonStyle(.Spin)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

