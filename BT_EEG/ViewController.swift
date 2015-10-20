//
//  ViewController.swift
//  BT_EEG
//
//  Created by Daniel Acker on 10/20/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, ORSSerialPortDelegate
{
  
  @IBOutlet weak var graph: DynamicGraph!
  
  var graphTimer = NSTimer()
  var graphData = [CGFloat](count: 1000, repeatedValue: 100)
  var dataBuffer = NSMutableData()
  var serialReadNumber = 0
  let serialPort = ORSSerialPort(path: "/dev/tty.HC-06-DevB")
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    serialBegin()
    graphTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateGraph", userInfo: nil, repeats: true)
  }
  
  // MARK : ORSSerialPortDelegate
  
  func serialBegin()
  {
    serialPort?.delegate = self
    serialPort!.baudRate = 9600
    serialPort!.open()
  }
  
  func serialEnd()
  {
    serialPort!.close()
  }
  
  func serialPort(serialPort: ORSSerialPort, didReceiveData data: NSData)
  {
    dataBuffer.appendData(data)
    serialReadNumber = (serialReadNumber + 1) % 10
    if serialReadNumber == 0
    {
      parseSerialData(dataBuffer)
      dataBuffer = NSMutableData()
    }
  }
  
  func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
    
  }
  
  func serialPortWasClosed(serialPort: ORSSerialPort) {
    
  }
  
  func serialPortWasOpened(serialPort: ORSSerialPort) {
    
  }
  
  func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
    
  }
  
  // MARK : Custom functions
  
  // parse serial port data into integers
  func parseSerialData(data: NSData)
  {
    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
    let splitDataString = dataString?.componentsSeparatedByCharactersInSet(.newlineCharacterSet())
    var newPoints: [CGFloat] = []
    for char in splitDataString!
    {
      if let integerValue = (char as! String).toInt()
      {
        newPoints.append(CGFloat(integerValue))
      }
    }
    updateGraphData(newPoints)
  }
  
  // update the plot data source
  func updateGraphData(newPoints: [CGFloat])
  {
    var newGraphData = graphData
    newGraphData.removeRange(0...newPoints.count - 1)
    newGraphData.extend(newPoints)
    graphData = newGraphData
  }
  
  // update the plot
  
  func updateGraph()
  {
    graph.points = graphData
    graph.setNeedsDisplayInRect(graph.bounds)
  }
  
}

