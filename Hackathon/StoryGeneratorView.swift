//
//  DetailView.swift
//  Hackathon
//
//  Created by 周亮 on 2023/7/10.
//

import Alamofire
import AVFoundation
import Speech
import SwiftUI

class AudioRecorderDelegate: NSObject, AVAudioRecorderDelegate, ObservableObject {
    @Published var audioURL: URL?
    @Published var recognizedText: String = ""
    var finalChapters: Binding<[String]>?
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.audioURL = recorder.url
            self.recognizeSpeech(url: recorder.url)
        } else {
            print("Failed to record audio.")
        }
    }
    
    func recognizeSpeech(url: URL) {
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh_CN"))
        let request = SFSpeechURLRecognitionRequest(url: url)
        var started = false
        
        recognizer?.recognitionTask(with: request) { result, error in
            guard let result = result else {
                print("Recognition failed: \(error?.localizedDescription ?? "")")
                return
            }
            
            self.recognizedText = result.bestTranscription.formattedString
            if started {
                self.finalChapters?.last?.wrappedValue = self.recognizedText
            } else {
                self.finalChapters?.wrappedValue.append(self.recognizedText)
                started = true
            }
            print("\(self.recognizedText)\(result.isFinal)")
        }
    }
}

struct TextEditorView: View {
    struct ViewHeightKey: PreferenceKey {
        static var defaultValue: CGFloat { 0 }
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = value + nextValue()
        }
    }
    
    @Binding var string: String
    @State var textEditorHeight: CGFloat = 20
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(string)
                .font(.system(.body))
                .foregroundColor(.clear)
                .padding(14)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
            
            TextEditor(text: $string)
                .font(.system(.body))
                .frame(height: max(40, textEditorHeight))
                .cornerRadius(10.0)
                .shadow(radius: 1.0)
        }.onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
    }
}

struct StoryGeneratorView: View {
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder!
    @StateObject private var audioRecorderDelegate = AudioRecorderDelegate()
    @State private var waveformSamples: [Float] = []
    @State private var finalChapters = [String]()
    private var defaultMessage = "这是一个平行宇宙，每个人都可能在特定条件下觉醒一项超能力，但大部分人不会觉醒。主角是一个程序员，在长达三十年的人生中，并没有觉醒超能力，只能靠打工赚取微薄的薪水，因此背上了高额的房贷，但是遇到经济危机，为了不断贷，只好借高利贷。后来在高利贷的暴力催收中，意外觉醒超能力。他的超能力是一把键盘，用这把键盘可以敲出任何想要的代码。靠着这项能力，他成为知名科学家，即为人类创造了多项跨时代的技术，又为自己创造了巨额财富。最终他携带巨额财富，携带家人隐居山林，过上了幸福的生活。"
    private var request = OpenAIRequest()
    @State private var dataRequest: DataRequest?
    @State private var message = ""
    @State private var selectedShotCount = 4
    @State private var showShotList = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var shots: [ShotListView.Shot] = []
    @State private var isTextEditor = true

    @State private var inputText: String = ""
       
    var body: some View {
        VStack {
            HStack {
                Stepper(value: $selectedShotCount, in: 4 ... 20) {
                    Text("分镜数量: \(selectedShotCount)")
                }
                   
                Button(action: {
                    // 点击按钮的操作
                    generateShots()
                }) {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                }
            }
            .padding()
               
            List {
                ForEach(finalChapters, id: \.self) { chapter in
                    Text(chapter)
                }
            }
            .padding()
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
               
            HStack {
                Button(action: {
                    isTextEditor.toggle()
                }) {
                    Image(systemName: isTextEditor ? "mic.fill" : "keyboard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                }.padding(.bottom, 10)
                    .padding(.leading, 10)
                
                Spacer()
                   
                if isTextEditor {
                    TextEditorView(string: $inputText)
                        .padding()
                       
                    Button(action: {
                        finalChapters.append(inputText)
                        inputText = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                    }
                } else {
                    if isRecording {
                        Button(action: {
                            self.stopRecording()
                        }) {
                            Image(systemName: "stop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                            Text("点击停止录音")
                                .font(.caption)
                        }
                    } else {
                        Button(action: {
                            self.startRecording()
                        }) {
                            Image(systemName: "play.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                            Text("点击开始录音")
                                .font(.caption)
                        }
                    }
                    Spacer()
                }
            }
            .padding()
        }
        .onAppear {
            audioRecorderDelegate.finalChapters = $finalChapters
            checkMicrophonePermission()
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("提示"), message: Text("生成分镜失败"), dismissButton: .default(Text("确定")))
        }
        .sheet(isPresented: $showShotList) {
            ShotListView(shots: self.shots)
        }
    }
    
    func checkMicrophonePermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            break
        case .denied:
            print("Microphone access denied.")
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if !granted {
                    print("Microphone access denied.")
                }
            }
        @unknown default:
            print("Unknown microphone permission status.")
        }
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            try audioSession.setActive(true)
            
            let audioURL = self.getDocumentsDirectory().appendingPathComponent("recording.wav")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            self.audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            self.audioRecorder.delegate = self.audioRecorderDelegate
            self.audioRecorder.isMeteringEnabled = true
            self.audioRecorder.record()
            
            self.isRecording = true
            self.audioRecorderDelegate.audioURL = nil
            self.waveformSamples = []
            
            // Create a timer to update the waveform
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.updateWaveform()
            }
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        self.audioRecorder.stop()
        self.audioRecorder = nil
        self.isRecording = false
    }
    
    func playAudio(url: URL) {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }
    
    func updateWaveform() {
        guard let audioRecorder = self.audioRecorder else {
            return
        }
        
        audioRecorder.updateMeters()
        let decibel = audioRecorder.averagePower(forChannel: 0)
        let normalizedValue = pow(10, decibel / 20)
        self.waveformSamples.append(normalizedValue)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func generateShots() {
        self.isLoading = true
        var prompt = self.message
        if prompt.isEmpty {
            prompt = self.defaultMessage
        }
        self.dataRequest = self.request.startRequest(prompt: prompt, chapterNumber: self.selectedShotCount) { success, chapters in
            isLoading = false
            if success, let tempChapters = chapters {
                parseShots(chapters: tempChapters)
                showShotList = true
            } else {
                showAlert = true
            }
        }
    }

    // 解析分镜的数据
    func parseShots(chapters: [String]) {
        self.shots.removeAll()
        var index = 0
        for chapter in chapters {
            index += 1
            let short = ShotListView.Shot(title: "第\(index)章节", description: chapter)
            self.shots.append(short)
        }
    }
}

struct WaveformView: View {
    let samples: [Float]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                let stepX = width / CGFloat(self.samples.count - 1)
                let stepY = height / 2
                
                let centerY = height / 2
                
                path.move(to: CGPoint(x: 0, y: centerY))
                
                for (index, sample) in self.samples.enumerated() {
                    let x = CGFloat(index) * stepX
                    let y = CGFloat(sample) * stepY
                    
                    path.addLine(to: CGPoint(x: x, y: centerY - y))
                    path.addLine(to: CGPoint(x: x, y: centerY + y))
                }
            }
            .stroke(Color.black, lineWidth: 2)
        }
    }
}

struct StoryGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        StoryGeneratorView()
    }
}
