//
//  WSViewController.swift
//  WebShell
//
//  Created by Randy on 15/12/19.
//  Copyright © 2018 WebShell. All rights reserved.
//
//  Wesley de Groot (@wdg), Added Notification and console.log Support

import AppKit
import AudioToolbox
import Cocoa
import CoreLocation
import Darwin
import Foundation
import IOKit.ps
import WebKit

// @wdg Clean up code base
// Issue: #43
class WSViewController: NSViewController, WebFrameLoadDelegate, WebUIDelegate, WebResourceLoadDelegate, WebPolicyDelegate, CLLocationManagerDelegate, WebDownloadDelegate, NSURLDownloadDelegate, WebEditingDelegate {
    @IBOutlet var mainWindow: NSView!
    @IBOutlet var mainWebview: WebView!
    @IBOutlet var launchingLabel: NSTextField!
    @IBOutlet var progressBar: NSProgressIndicator!
    
    var settings: Settings? = Settings.shared
    var firstLoadingStarted = false
    var firstAppear = true
    var notificationCount = 0
    var lastURL: URL!
    var IElement = NSMenuItem()
    let locationManager = CLLocationManager()
    var MustCloseWindow = true
    var WSgestureLog: [CGFloat] = [0, 0]
    var twoFingersTouches: [String: NSTouch]?
    
    override func viewDidAppear() {
        if firstAppear {
            initWindow()
        }
    }
    
    // @wdg Possible fix for Mavericks
    // Issue: #18
    override func awakeFromNib() {
        if !NSViewController().responds(to: #selector(NSViewController.viewWillAppear)) {
            checkSettings()
            
            if firstAppear {
                initWindow()
            }
            
            mainWebview.uiDelegate = self
            mainWebview.resourceLoadDelegate = self
            mainWebview.downloadDelegate = self
            mainWebview.editingDelegate = self
            mainWebview.policyDelegate = self
            
            addObservers()
            initSettings()
            if let startUrl = settings?.startURL() {
                loadUrl(startUrl)
            }
            WSMediaLoop(self)
            WSinitSwipeGestures()
        }
    }
    
    override func viewDidLoad() {
        checkSettings()
        super.viewDidLoad()
        
        mainWebview.uiDelegate = self
        mainWebview.resourceLoadDelegate = self
        mainWebview.downloadDelegate = self
        mainWebview.editingDelegate = self
        mainWebview.policyDelegate = self
        
        checkSettings()
        addObservers()
        initSettings()
        if let startUrl = settings?.startURL() {
            loadUrl(startUrl)
        }
        WSMediaLoop(self)
        WSinitSwipeGestures()
    }
}
