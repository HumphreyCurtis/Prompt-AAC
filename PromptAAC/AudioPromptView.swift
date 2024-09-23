//
//  AudioPromptView.swift
//  PromptAAC
//
//  Created by Humphrey Curtis on 22/03/2024.
//

import SwiftUI
import AVFoundation

struct AudioPromptView: View {
    
    //MARK: - Properties
    @State var expressions: [Expression] = [Expression]()
    
    @State var synthesizer = AVSpeechSynthesizer()
    @State private var personalVoices: [AVSpeechSynthesisVoice] = []
    @State var personalVoiceRequested: String
    @State var voice: AVSpeechSynthesisVoice?
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            List {
                if expressions.count >= 1 {
                    ForEach(0..<expressions.count, id: \.self) { i in
                        HStack {
                            Text(expressions[i].expression)
                                .padding(.leading, 5)
                                .bold(true)
                            Image(systemName: "mic.fill")
                              
                        }
                        .onTapGesture {
                            textToSpeech(spokenCommand: expressions[i].expression)
                        }
                    }
                    .onDelete(perform: delete)
                }
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    NavigationLink(destination: EditAudioView()) {
                        Text("Add Prompt")
                            .font(.title2)
                            .bold()
                    }
                    
        
                }
            }
            .navigationTitle("Your Audio Prompts")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                load()
            }

            
        }
    }
    
    
    //MARK: - Functions
    func textToSpeech(spokenCommand: String) {
        print("Text to speech")
        
        
        // Create an utterance.
        let utterance = AVSpeechUtterance(string: spokenCommand)
//        var voice = "female";
        
        print("Personal voice requested: \(personalVoiceRequested)")
        
        switch personalVoiceRequested {
            case "male":
                voice = AVSpeechSynthesisVoice(language: "en-GB")
                break
            case "female":
                voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")
                break
            case "personal":
                processingPersonalVoices()
                voice = personalVoices.first
                break
            default :
                voice = AVSpeechSynthesisVoice(language: "en-GB")
                break
        }
        
//        if personalVoiceRequested == false {
//            voice = personalVoices.first
//        }
        
        // Configure the utterance.
        utterance.rate = 0.3
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8
        
        print(voice as Any)
        
        // Assign the voice to the utterance.
        utterance.voice = voice
        
        // Tell the synthesizer to speak the utterance.
        synthesizer.speak(utterance)

//        List available voices
//        let voices = AVSpeechSynthesisVoice.speechVoices()
//        for voiceCategory in voices {
//            print(voiceCategory)
//        }
        
    }
    
    func fetchPersonalVoice() async {
        AVSpeechSynthesizer.requestPersonalVoiceAuthorization() { status in
            
            if status == .authorized {
                personalVoices = AVSpeechSynthesisVoice.speechVoices().filter {
                    $0.voiceTraits.contains(.isPersonalVoice)
                }
                
            }
            
        }
        
    }
    
    func processingPersonalVoices() {
        Task {
            await fetchPersonalVoice()
        }
    }
    
    //MARK: - Memory Management
    func delete(at offsets: IndexSet) {
        expressions.remove(atOffsets: offsets)
        save()
    }
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
  
    func save() {
        do {
            print("Saving - Audio Prompt View: \(expressions)")
            let data = try JSONEncoder().encode(expressions)
            let url = getDocumentDirectory().appendingPathComponent("aacPrompts")
            try data.write(to: url)
    
        } catch {
            print("Saving data has failed!")
        }
    }
    
    
    func load() {
        DispatchQueue.main.async {
            do {
                let url = getDocumentDirectory().appendingPathComponent("aacPrompts")
                let data = try Data(contentsOf: url)
                expressions = try JSONDecoder().decode([Expression].self, from: data)
                print("Loading - Audio Prompt View: \(expressions)")
    
            } catch {
                print("Not loading from memory")
                    // Do nothing -- if all notes deleted or no notes yet
            }
        }
    }
    
}

//MARK: - Preview
#Preview {
    AudioPromptView(personalVoiceRequested: "female")
}
