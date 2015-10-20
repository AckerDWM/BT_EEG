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
  var graphData = [CGFloat](count: 800, repeatedValue: 0)
  var dataBuffer = NSMutableData()
  var serialReadNumber = 0
  let serialPort = ORSSerialPort(path: "/dev/tty.HC-06-DevB")
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    serialPort?.delegate = self
    serialPort!.baudRate = 9600
  }
  
  // MARK : ORSSerialPortDelegate
  
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
  
  func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError)
  {
    let alert = NSAlert()
    alert.messageText = "Serial connection error"
    alert.addButtonWithTitle("OK")
    alert.informativeText = "The bluetooth EEG device could not be found. Make sure that it is turned on and paired with this computer."
    alert.beginSheetModalForWindow(self.view.window!, completionHandler: nil )
  }
  
  func serialPortWasClosed(serialPort: ORSSerialPort)
  {
    
  }
  
  func serialPortWasOpened(serialPort: ORSSerialPort)
  {
    
  }
  
  func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort)
  {
    
  }
  
  // MARK : Button actions
  
  @IBAction func recordBtn(sender: AnyObject)
  {
    serialPort!.open()
    graphTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateGraph", userInfo: nil, repeats: true)
  }
  
  @IBAction func stopBtn(sender: AnyObject)
  {
    graphTimer.invalidate()
    serialPort!.close()
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

