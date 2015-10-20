//
//  DynamicGraph.swift
//  Bluetooth EEG
//
//  Created by Daniel Acker on 10/19/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Cocoa

class DynamicGraph: NSView
{

  var points = [CGFloat](count: 1000, repeatedValue: 0)
  
  override func drawRect(dirtyRect: NSRect)
  {
    NSColor.whiteColor().setFill()
    NSRectFill(dirtyRect)
    super.drawRect(dirtyRect)

    // Drawing code here.
    let height = self.bounds.height
    let width = self.bounds.width
    let path = NSBezierPath()
    let pointCount = CGFloat(points.count)
    path.moveToPoint(CGPointMake(width / pointCount, points[1]))
    for (var i = 1; i < points.count; i++)
    {
      let remappedPoint = (points[i] / 1024) * height // map the newPoint to the graph's size
      let nextPoint = CGPointMake(CGFloat(i) * width / pointCount, remappedPoint)
      path.lineToPoint(nextPoint)
    }
    path.stroke()
    
    // Draw axes
    let xAxisPath = NSBezierPath()
    xAxisPath.moveToPoint(CGPoint(x: 0, y: height / 2))
    xAxisPath.lineToPoint(CGPoint(x: width, y: height / 2))
    xAxisPath.setLineDash([5, 5], count: 2, phase: 0)
    xAxisPath.lineWidth = 2
    xAxisPath.stroke()
  }
    
}
