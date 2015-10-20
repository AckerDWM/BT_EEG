//
//  DynamicGraph.swift
//  Bluetooth EEG
//
//  Created by Daniel Acker on 10/19/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Cocoa

@IBDesignable
class DynamicGraph: NSView
{

  var points = [CGFloat](count: 100, repeatedValue: 0)
  
  override func drawRect(dirtyRect: NSRect)
  {
    super.drawRect(dirtyRect)

    // Drawing code here.
    let height = self.bounds.height
    let width = self.bounds.width
    let path = NSBezierPath()
    let pointCount = CGFloat(self.points.count)
    path.moveToPoint(CGPointMake(width / pointCount, self.points[1]))
    for (var i = 1; i < self.points.count; i++)
    {
      let nextPoint = CGPointMake(CGFloat(i) * width / pointCount, self.points[i])
      path.lineToPoint(nextPoint)
    }
    path.stroke()
  }
    
}
