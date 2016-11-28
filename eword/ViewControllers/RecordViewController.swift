//
//  ViewController.swift
//  eword
//
//  Created by Admin on 24/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import MBProgressHUD

class RecordViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var recordTime: UILabel!
    @IBOutlet weak var recordingText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var playTime: UILabel!
    
    @IBOutlet weak var playBackView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var resumeView: UIView!
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet var progressViews: [UIView]!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var eraseButton: UIButton!
    
    var leftButton, rightButton: UIBarButtonItem?
    var loadingIndicator: MBProgressHUD?
    var imagePicker = UIImagePickerController()
    
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).getManagedObjectContext()
    
    var isEdit = false
    var isCamera = false
    var isContinueRecord = false
    var masterURL: URL?
    var combinedURL: URL?
    var recordedData: Data?
    var flag: String?
    var meterTimer, playTimer, recordTimer: Timer?
    var ticks = 0.0
    var fileType, name: String?
    var recording: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController!.navigationBar.tintColor = UIColor.white
        
        leftButton = UIBarButtonItem(title: "Gallery", style: .plain, target: self, action: #selector(onGallery))
        navigationItem.leftBarButtonItem = leftButton
        rightButton = UIBarButtonItem(title: "Camera", style: .plain, target: self, action: #selector(onCamera))
        navigationItem.rightBarButtonItem = rightButton
        
        setBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (!isCamera) {
            getReadyForRecord();
            updateProgressWithTag(0)
        }
        else {
            isCamera = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isContinueRecord = false
        if (isEdit) {
            isContinueRecord = true
            _ = DirectoryManager.instance.listAllFilesForType(type: KFolder)
            let source = DirectoryManager.instance.getPathForFileWithType(type: KFolder, name: recording!.fileName!)
            let destination = DirectoryManager.instance.getPathForFileWithType(type: nil, name: KMaster)
            DirectoryManager.instance.copyFrom(source: source, destination: destination)
            masterURL = URL(fileURLWithPath: destination)
            setupPlayer()
            pauseRecording()
            name = recording!.fileName!
            playButton.setBackgroundImage(UIImage(named: "PlayIcon"), for: .normal)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isEdit = false
        isContinueRecord = false
        meterTimer?.invalidate()
        playTimer?.invalidate()
        recordTimer?.invalidate()
        
        if (recorder != nil && recorder!.isRecording) {
            recorder!.pause()
        }
        recorder = nil
        
        if (player != nil && player!.isPlaying) {
            player!.stop()
        }
        player = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setBadge() {
        let fetchRequest = NSFetchRequest<Record>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Record", in: managedObjectContext!)
        fetchRequest.includesSubentities = false
        do {
            let count = try managedObjectContext!.count(for: fetchRequest)
            if (count > 0) {
                tabBarController!.tabBar.items![1].badgeValue = String(count)
            }
            else {
                tabBarController!.tabBar.items![1].badgeValue = nil
            }
        }
        catch {
            
        }
    }
    
    func onGallery() {
        showImagePicker(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    func onCamera() {
        showImagePicker(UIImagePickerControllerSourceType.camera)
    }
    
    func getReadyForRecord() {
        imageView.image = nil
        loadingIndicator?.hide(animated: true)
        updateProgressWithTag(0)
        eraseButton.isHidden = true
        if (isContinueRecord) {
            deleteFileWithName(KUpdate, type: "")
            setUpRecorderWithName(KUpdate)
            ticks = Double(lengthForUrl(masterURL!))
            recordTime.text = Util.timeForTicks(ticks)
        }
        else {
            deleteFileWithName(KMaster, type: "")
            setUpRecorderWithName(KMaster)
            masterURL = recorder!.url
            ticks = 0
            recordTime.text = Util.timeForTicks(ticks)
        }
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        recordButton.isEnabled = true
        recordingText.isHidden = true
        progressView.isHidden = true
        recordButton.setTitle("Record", for: .normal)
        recordButton.isHidden = false
        recordTime.isHidden = false
        playTime.isHidden = true
        seekBar.isHidden = true
        saveButton.isHidden = true
        submitButton.isHidden = true
        playButton.isHidden = true
        resumeView.isHidden = true
        playBackView.isHidden = true
        playButton.setBackgroundImage(UIImage(named: "PlayIcon"), for: .normal)
    }
    
    func updateProgressWithTag(_ index: Int) {
        for i in 0 ... 14 {
            if (i < index) {
                progressViews[i].isHidden = false
            }
            else {
                progressViews[i].isHidden = true
            }
        }
    }
    
    func lengthForUrl(_ url: URL) -> Float {
        let audioAsset = AVURLAsset(url: url, options: nil)
        let audioDuration = audioAsset.duration
        var audioDurationSeconds = CMTimeGetSeconds(audioDuration)
        if (audioDurationSeconds == 0) {
            audioDurationSeconds = Float64(lengthFromPlayer(url))
        }
        
        return Float(audioDurationSeconds)
    }
    
    func lengthFromPlayer(_ url: URL) -> Float {
        do {
            let avAudioPlayer = try AVAudioPlayer(contentsOf: url)
            let duration = avAudioPlayer.duration
            return Float(duration)
        }
        catch {
            print(error)
            return 0
        }
    }
    
    func setUpRecorderWithName(_  fileName: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let soundOneNew = (documentsDirectory as NSString).appendingPathComponent(fileName)
        let outputFileUrl = URL(fileURLWithPath: soundOneNew)
        
        //  Setup Audio Session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        }
        catch {
            print(error)
            return
        }
        
        var recordSetting = [String : AnyObject]()
        recordSetting[AVFormatIDKey] = NSNumber(value: kAudioFormatMPEG4AAC)
        recordSetting[AVSampleRateKey] = NSNumber(value: 44100.0)
        recordSetting[AVNumberOfChannelsKey] = NSNumber(value: 1)
        recordSetting[AVEncoderBitDepthHintKey] = NSNumber(value: 16)
        
        do {
            recorder = try AVAudioRecorder(url: outputFileUrl, settings: recordSetting)
            recorder!.delegate = self
            recorder!.isMeteringEnabled = true
            recorder!.prepareToRecord()
        }
        catch {
            print(error)
            return
        }
    }
    
    func playerTimer() {
        seekBar.value = Float(player!.currentTime)
        playTime.text = Util.timeForTicks(player!.currentTime) + "/" + Util.timeForTicks(Double(lengthForUrl(masterURL!)))
    }
    
    //////////////////////////////
    
    @IBAction func onRecord(_ sender: AnyObject) {
        if (recorder!.isRecording) {
            recorder!.stop()
            recordButton.isEnabled = false
            meterTimer!.invalidate()
            recordTimer!.invalidate()
            updateProgressWithTag(0)
        }
        else {
            recorder!.record()
            recordButton.setTitle("Pause", for: .normal)
            recordingText.isHidden = false
            progressView.isHidden = false
            meterTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(RecordViewController.setSoundMeter), userInfo: nil, repeats: true)
            recordTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(RecordViewController.updateRecordingDuration), userInfo: nil, repeats: true)
        }
    }
    
    func setSoundMeter() {
        recorder!.updateMeters()
        let lowPassResults = pow(10, (0.05 * recorder!.peakPower(forChannel: 0)))
        var tag = 1
        for i in 1...15 {
            let b = Float(i) / 15.0
            if (lowPassResults <= b) {
                tag = i
                break
            }
        }
        updateProgressWithTag(tag)
    }
    
    func updateRecordingDuration() {
        ticks = ticks + 1
        recordTime.text = Util.timeForTicks(ticks)
    }
    
    @IBAction func onPlay(_ sender: AnyObject) {
        if (player!.isPlaying) {
            player!.pause()
            playTimer!.invalidate()
            playButton.setBackgroundImage(UIImage(named: "PlayIcon"), for: .normal)
        }
        else {
            player!.play()
            playTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(RecordViewController.playerTimer), userInfo: nil, repeats: true)
            playButton.setBackgroundImage(UIImage(named: "PauseIcon"), for: .normal)
        }
    }
    
    func setupPlayer() {
        do {
            player = try AVAudioPlayer(contentsOf: masterURL!)
            player!.delegate = self
            seekBar.maximumValue = Float(player!.duration)
            ticks = Double(lengthForUrl(masterURL!))
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func continueRecord(_ sender: AnyObject) {
        if (player != nil) {
            player!.stop()
            player = nil
        }
        playTimer?.invalidate()
        isContinueRecord = true
        getReadyForRecord()
        playButton.setBackgroundImage(UIImage(named: "PlayIcon"), for: .normal)
        onRecord(recordButton)
    }
    
    @IBAction func onErase(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Eword", message: "Want to delete this file and start a new recording?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.eraseToEnd()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func eraseToEnd() {
        if (player != nil && player!.isPlaying) {
            player!.stop()
        }
        isContinueRecord = false
        deleteFileWithName(KMaster, type: "")
        deleteFileWithName(KUpdate, type: "")
        deleteFileWithName(Kcombined, type: "")
        deleteFileWithName(name!, type: KFolder)
        deleteFromCoreDataWithName()
        setBadge()
        getReadyForRecord()
    }
    
    @IBAction func onPlayBack(_ sender: AnyObject) {
        player!.currentTime = player!.currentTime - 5
        seekBar.value = Float(player!.currentTime)
        playTime.text = Util.timeForTicks(player!.currentTime) + "/" + Util.timeForTicks(Double(lengthForUrl(masterURL!)))
    }
    
    @IBAction func onSubmit(_ sender: AnyObject) {
        if (recording != nil && recording!.submitted!.intValue == 1) {
            Util.showAlertMessage(title: "Eword", message: "File is already submitted.", parent: self)
        }
        else {
            playTimer?.invalidate()
            let path = DirectoryManager.instance.getPathForFileWithType(type: KFolder, name: name!)
            let url = URL(fileURLWithPath: path)
            
            let secondTabNavigationController = tabBarController!.viewControllers![2] as! UINavigationController
            secondTabNavigationController.popToRootViewController(animated: true)
            let settingsViewController = secondTabNavigationController.viewControllers[0] as! SettingsViewController
            settingsViewController.urlSelectedFile = url
            tabBarController!.selectedIndex = 2
        }
    }
    
    @IBAction func onSave(_ sender: AnyObject) {
        if (player != nil && player!.isPlaying) {
            player!.stop()
        }
        
        let alertController = UIAlertController(title: "Eword", message: "Please enter a name.", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            let trimmedComment = textField.text!.trimmingCharacters(in: .whitespaces)
            if (trimmedComment.lengthOfBytes(using: .utf8) > 0) {
                let isAlreadyPresent = DirectoryManager.instance.doesFileExistAtPath(folderName: KFolder, fileName: textField.text!)
                if (!isAlreadyPresent) {
                    self.updateFileFrom(self.name!, destination:textField.text!)
                    self.saveInCoreDataWithName(textField.text!)
                    self.name = textField.text!
                }
                else {
                    Util.showAlertMessage(title: "Eword", message: "Name already exist.\nPlease try another one.", parent: self)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = self.name
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func slider(_ sender: AnyObject) {
        player!.currentTime = TimeInterval(seekBar.value)
        playTime.text = Util.timeForTicks(Double(seekBar.value)) + "/" + Util.timeForTicks(ticks)
    }
    
    //////////////////////////////
    
    //  UIImagePicker
    
    func showImagePicker(_ source: UIImagePickerControllerSourceType) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = source
        if (source == UIImagePickerControllerSourceType.camera) {
            imagePicker.cameraCaptureMode = .photo
            imagePicker.showsCameraControls = true
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismissPicker()
        let rawImage = info[UIImagePickerControllerOriginalImage]
        imageView.image = rawImage as! UIImage?
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissPicker()
    }
    
    func dismissPicker() {
        isCamera = true
        imagePicker.dismiss(animated: false, completion: nil)
    }
    
    //////////////////////////////
    
    func pauseRecording() {
        recordTime.isHidden = true
        playTime.isHidden = false
        recordButton.isHidden = true
        saveButton.isHidden = false
        playBackView.isHidden = false
        playButton.isHidden = false
        resumeView.isHidden = false
        seekBar.isHidden = false
        submitButton.isHidden = false
        eraseButton.isHidden = false
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        loadingIndicator?.hide(animated: true)
        setSliderAndLabel()
    }
    
    func setSliderAndLabel() {
        seekBar.value = 0
        playTime.text = "00:00:00/" + Util.timeForTicks(Double(lengthForUrl(masterURL!)))
    }
    
    //////////////////////////////
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordingText.isHidden = true
        progressView.isHidden = true
        print(recorder.url)
        print(masterURL!)
        if (recorder.url != masterURL!) {
            recordButton.isEnabled = false
            _ = combineFilesFor(recorder.url)
        }
        else {
            getName()
            saveFile()
            saveInCoreDataWithName(name!)
            setBadge()
            pauseRecording()
            setupPlayer()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        setSliderAndLabel()
        playTimer!.invalidate()
        playButton.setBackgroundImage(UIImage(named: "PlayIcon"), for: .normal)
    }
    
    //////////////////////////////
    
    func combineFilesFor(_ url: URL) -> Bool {
        loadingIndicator = MBProgressHUD.showAdded(to: self.view.window!, animated: true)
        loadingIndicator!.mode = .text
        loadingIndicator!.label.text = "Loading..."
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let soundOneNew = (documentsDirectory as NSString).appendingPathComponent(Kcombined)
        let out_url = URL(fileURLWithPath: soundOneNew)
        
        if FileManager.default.fileExists(atPath: soundOneNew) {
            print("error")
        }
        
        print("Output URL: \(out_url)")
        print("Original URL: \(masterURL!)")
        print("Original URL: \(url)")
        let existingAudioDurationSeconds = self.lengthForUrl(self.masterURL!)
        let newAudioDurationSeconds = self.lengthForUrl(url)
        _ = existingAudioDurationSeconds + newAudioDurationSeconds
        let sourceUrls = [masterURL!, url]
        
        var nextClipStartTime = kCMTimeZero
        let composition = AVMutableComposition()
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)

        for url in sourceUrls {
            
            let avAsset = AVURLAsset(url: url, options: nil)
            let tracks = avAsset.tracks(withMediaType: AVMediaTypeAudio)
            if (tracks.count == 0) {
                
            }
            let timeRangeInAsset = CMTimeRangeMake(kCMTimeZero, avAsset.duration)
            let clipAudioTrack = avAsset.tracks(withMediaType: AVMediaTypeAudio)[0]
            do {
                _ = try compositionAudioTrack.insertTimeRange(timeRangeInAsset, of: clipAudioTrack, at: nextClipStartTime)
            }
            catch {
                print(error)
            }
            nextClipStartTime = CMTimeAdd(nextClipStartTime, timeRangeInAsset.duration)
        }
        
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        if (exportSession == nil) {
            return false
        }
        
        exportSession!.outputURL = out_url
        exportSession!.outputFileType = AVFileTypeAppleM4A
        exportSession!.exportAsynchronously(completionHandler: {
            if (exportSession!.status == AVAssetExportSessionStatus.completed) {
                let time = self.lengthForUrl(URL(fileURLWithPath: soundOneNew))
                print(time)
                self.deleteFileWithName(KUpdate, type: "")
                self.deleteFileWithName(KMaster, type: "")
                self.replaceFileAtPath(KMaster, data:NSData(contentsOfFile: soundOneNew))
                self.deleteFileWithName(Kcombined, type: "")
            }
            else if (exportSession!.status == AVAssetExportSessionStatus.failed) {
                
            }
            
            DispatchQueue.main.async {
                self.loadingIndicator?.hide(animated: true)
                self.pauseRecording()
                self.setupPlayer()
                self.recordButton.isEnabled = true
            }
        })
        
//        DispatchQueue.global(qos: .default).async {
//            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//            let documentsDirectory = paths[0]
//            let soundOneNew = (documentsDirectory as NSString).appendingPathComponent(Kcombined)
//            let out_url = URL(fileURLWithPath: soundOneNew)
//            let existingAudioDurationSeconds = self.lengthForUrl(self.masterURL!)
//            let newAudioDurationSeconds = self.lengthForUrl(url)
//            _ = existingAudioDurationSeconds + newAudioDurationSeconds
//            let sourceUrls = [self.masterURL!, url]
//            
//            var afIn: ExtAudioFileRef? = nil
//            var afOut: ExtAudioFileRef? = nil
//            var inputFileFormat = AudioStreamBasicDescription()
//            var outputFileFormat = AudioStreamBasicDescription()
//            var converterFileFormat = AudioStreamBasicDescription()
//            var propertySize = UInt32(MemoryLayout<AudioStreamBasicDescription>.size)
//            var buffer: UnsafeMutableRawPointer
//            
//            for inUrl in sourceUrls {
//                var status = ExtAudioFileOpenURL(inUrl as CFURL, &afIn)
//                print(afIn!)
//                
//                bzero(&inputFileFormat, MemoryLayout<AudioStreamBasicDescription>.size)
//                status = ExtAudioFileGetProperty(afIn!, kExtAudioFileProperty_FileDataFormat, &propertySize, &inputFileFormat)
//                
//                memset(&converterFileFormat, 0, MemoryLayout<AudioStreamBasicDescription>.size);
//                converterFileFormat.mFormatID = kAudioFormatLinearPCM
//                converterFileFormat.mSampleRate = inputFileFormat.mSampleRate
//                converterFileFormat.mChannelsPerFrame = 1
//                converterFileFormat.mBytesPerPacket = 2
//                converterFileFormat.mFramesPerPacket = 1
//                converterFileFormat.mBytesPerFrame = 2
//                converterFileFormat.mBitsPerChannel = 16
//                converterFileFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger
//                
//                status = ExtAudioFileSetProperty(afIn!, kExtAudioFileProperty_ClientDataFormat, UInt32(MemoryLayout<AudioStreamBasicDescription>.size), &converterFileFormat)
//                if (status != 0) {
//                    
//                }
//                
//                if (afOut == nil) {
//                    memset(&outputFileFormat, 0, MemoryLayout<AudioStreamBasicDescription>.size);
//                    outputFileFormat.mFormatID = kAudioFormatMPEG4AAC
//                    outputFileFormat.mFormatFlags = AudioFormatFlags(MPEG4ObjectID.aac_Main.rawValue)
//                    outputFileFormat.mSampleRate = inputFileFormat.mSampleRate
//                    outputFileFormat.mChannelsPerFrame = inputFileFormat.mChannelsPerFrame
//                    var outStatus = ExtAudioFileCreateWithURL(out_url as CFURL, kAudioFileM4AType, &outputFileFormat, nil, AudioFileFlags.eraseFile.rawValue, &afOut)
//                    outStatus = ExtAudioFileSetProperty(afOut!, kExtAudioFileProperty_ClientDataFormat, UInt32(MemoryLayout<AudioStreamBasicDescription>.size), &converterFileFormat)
//                    print(outStatus)
//                }
//                
//                buffer = malloc(4096)
//                
//                var conversionBuffer = AudioBufferList()
//                conversionBuffer.mNumberBuffers = 1
//                conversionBuffer.mBuffers.mNumberChannels = inputFileFormat.mChannelsPerFrame
//                conversionBuffer.mBuffers.mData = buffer
//                conversionBuffer.mBuffers.mDataByteSize = 4096
//                
//                while (true) {
//                    conversionBuffer.mBuffers.mDataByteSize = 4096
//                    var frameCount: UInt32 = UInt32(INT_MAX)
//                    
//                    if (inputFileFormat.mBytesPerFrame > 0) {
//                        frameCount = conversionBuffer.mBuffers.mDataByteSize / inputFileFormat.mBytesPerFrame
//                    }
//                    
//                    var err = ExtAudioFileRead(afIn!, &frameCount, &conversionBuffer)
//                    if (err > 0) {
//                        
//                    }
//                    else {
//                        
//                    }
//                    
//                    if (frameCount == 0) {
//                        break
//                    }
//                    
//                    err = ExtAudioFileWrite(afOut!, frameCount, &conversionBuffer)
//                    if (err > 0) {
//                        
//                    }
//                    else {
//                        
//                    }
//                }
//                ExtAudioFileDispose(afIn!)
//            }
//            ExtAudioFileDispose(afOut!)
//            
//            let time = self.lengthForUrl(URL(fileURLWithPath: soundOneNew))
//            print(time)
//            self.deleteFileWithName(KUpdate, type: "")
//            self.deleteFileWithName(KMaster, type: "")
//            self.replaceFileAtPath(KMaster, data:NSData(contentsOfFile: soundOneNew))
//            self.deleteFileWithName(Kcombined, type: "")
//            
//            DispatchQueue.main.async {
//                self.loadingIndicator?.hide(animated: true)
//                self.pauseRecording()
//                self.setupPlayer()
//                self.recordButton.isEnabled = true
//            }
//        }
        
        return true
    }
    
    func getName() {
        let userDefaults = UserDefaults.standard
        let count = userDefaults.integer(forKey: "count")
        name = "Recording" + String(count)
        if (isEdit) {
            name = recording!.fileName
        }
        userDefaults.set(count + 1, forKey: "count")
        userDefaults.synchronize()
    }
    
    func updateIfEditWith(_ context: NSManagedObjectContext) -> Record? {
        let feedFetch = NSFetchRequest<Record>.init(entityName: "Record")
        let predicate = NSPredicate.init(format: "fileName = %@", name!)
        feedFetch.predicate = predicate
        do {
            let array = try context.fetch(feedFetch) as [Record]
            return array.last
        }
        catch {
            return nil
        }
    }
    
    func saveInCoreDataWithName(_ name: String) {
        let length = Int(lengthForUrl(masterURL!))
        let rec = updateIfEditWith(managedObjectContext!)
        if (rec != nil) {
            rec!.setValue(fileType, forKey: "type")
            rec!.setValue(Date(), forKey: "date")
            rec!.setValue(0, forKey: "submitted")
            rec!.setValue(length, forKey: "length")
            rec!.setValue(name, forKey: "fileName")
        }
        else {
            let recObj = NSEntityDescription.insertNewObject(forEntityName: "Record", into: managedObjectContext!)
            recObj.setValue(fileType, forKey: "type")
            recObj.setValue(Date(), forKey: "date")
            recObj.setValue(0, forKey: "submitted")
            recObj.setValue(length, forKey: "length")
            recObj.setValue(name, forKey: "fileName")
        }
        do {
            try managedObjectContext!.save()
        }
        catch {
            print(error)
        }
    }
    
    func saveFile() {
        do {
            try DirectoryManager.instance.saveDataAtDirectoryForType(type: KFolder, name: name!, fileData: Data.init(contentsOf: masterURL!) as NSData)
        }
        catch {
            print(error)
        }
    }
    
    
    func deleteFileWithName(_ name: String, type: String) {
        DirectoryManager.instance.deleteFileAtPath(folderName: type, fileName: name)
    }
    
    func replaceFileAtPath(_ path: String, data: NSData?) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let filePath = (documentsPath! as NSString).appendingPathComponent(path)
        data!.write(toFile: filePath, atomically: true)
        saveFile()
        saveInCoreDataWithName(name!)
    }
    
    func deleteFromCoreDataWithName() {
        var results = [Record]()
        let fetchRequest = NSFetchRequest<Record>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Record", in: managedObjectContext!)
        fetchRequest.predicate = NSPredicate.init(format: "fileName = %@", name!)
        do {
            results = try managedObjectContext!.fetch(fetchRequest)
            let record = results.last
            if (record != nil) {
                managedObjectContext!.delete(record!)
                do {
                    try managedObjectContext!.save()
                }
                catch {
                    
                }
            }
        }
        catch {
            
        }
    }
    
    func updateFileFrom(_ source: String, destination: String) {
        DirectoryManager.instance.renameFileWithName(srcName: source, dstName: destination)
    }
    
    //////////////////////////////
}

