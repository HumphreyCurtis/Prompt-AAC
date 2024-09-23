//
//  ContentView.swift
//  PromptAAC
//
//  Created by Humphrey Curtis on 22/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    
    //MARK: - Properties
    @State private var layout = [
        GridItem(.flexible()),
//        GridItem(.flexible())
    ]
    
    var voices = ["male", "female", "personal"]
    @State private var personalVoiceRequested = "male"
    
    //MARK: - Body
    var body: some View {
        
        NavigationStack {
            LazyVGrid(columns: layout, spacing: 20) {
                NavigationLink {
                    AudioPromptView(personalVoiceRequested: personalVoiceRequested)
                } label: {
                    VStack {
                        Image(systemName: "waveform.circle.fill")
                            .symbolRenderingMode(.monochrome)
                            .resizable()
                            .padding(10)
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.black)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(15)
                            .overlay {
                                Text("Audio Prompts")
                                    .fontWeight(.bold)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 10)
                                    .background(.ultraThinMaterial)
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                                    .padding()
                            }
                    }
                }
                
                Picker("Please choose a color", selection: $personalVoiceRequested) {
                    ForEach(voices, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                Text("You selected: \(personalVoiceRequested)")
                    .fontWeight(.bold)
        
//                List {
//                    Picker("Voice Chosen", selection: $personalVoiceRequested) {
//                        ForEach(voices, id: \.self) {
//                            Text($0)
//                        }
//                    }
//                }
                
//                NavigationLink {
//                    AudioPromptView(expressions: ["Good Morning Tim", "How was your trip to Canada?", "I hope you had a good time!"], personalVoiceRequested: "male")
//                } label: {
//                    Image(systemName: "tortoise")
//                        .resizable()
//                        .padding(10)
//                        .scaledToFit()
//                        .frame(width: 150, height: 150)
//                        .foregroundColor(.blue)
//                        .background(Color.gray.opacity(0.5))
//                        .cornerRadius(15)
//                        .overlay {
//                            Text("Settings")
//                                .fontWeight(.bold)
//                                .fixedSize(horizontal: true, vertical: false)
//                                .foregroundColor(.blue)
//                                .multilineTextAlignment(.leading)
//                                .padding(.horizontal, 10)
//                                .background(.ultraThinMaterial)
//                                .frame(maxHeight: .infinity, alignment: .bottom)
//                                .padding()
//                        }
//                }
//                
            }
        }
        
    }
}

//MARK: - Preview
#Preview {
    ContentView()
}
