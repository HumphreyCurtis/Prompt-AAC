//
//  EditAudioView.swift
//  PromptAAC
//
//  Created by Humphrey Curtis on 22/03/2024.
//

import SwiftUI

struct EditAudioView: View {
    
    //MARK: - Properties
    @State var expressions: [Expression] = [Expression]()
    @State var enteredText: String = ""
 
    
    //MARK: - Body
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                
                Spacer()
                
                
                TextField("Enter text", text: $enteredText, axis: .horizontal)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.1)
                    .bold()
                    .submitLabel(.done)
                    .onSubmit {
                        print("Added text")
                    }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    
                    Button {
                        saveSelection(enteredText: enteredText)
                    } label: {
                        Text("Save")
                    }
                    .font(.title2)
                    .bold()
                    
                }
            }
            .navigationTitle("Edit Audio Prompt")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                load()
            }
        }
    }
    
    //MARK: - Functions
    func saveSelection(enteredText: String) {
        
        let newExpression = Expression(id: UUID(), expression: enteredText)
        print("New expression: \(newExpression)")
        
        expressions.append(newExpression)
        print("Saving selection - Edit Audio: \(expressions)")
        
        save()
        
        self.enteredText = ""
    }
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    
    func save() {
        do {
            print("Saving - Edit Audio: \(expressions)")
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
                print("Loading - Edit Audio: \(expressions)")
                
            } catch {
                print("All expressions deleted or unable to load")
                // Do nothing -- if all notes deleted or no notes yet
            }
        }
    }
    
}

//MARK: - Preview
#Preview {
    EditAudioView()
}
