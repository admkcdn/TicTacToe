//
//  TicTacToe.swift
//  BasicsApp
//
//  Created by Adem Koçdoğan on 26.03.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var game: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    
    @State private var queue: Bool = false;
    
    @State private var winText: String="";
    
    
    var body: some View {
        VStack{
            Spacer()
            Text("Tic Tac Toe")
                .padding()
                .font(.largeTitle)
            Text((queue ?"❌":"⭕️") + " Turn").font(.title3).bold()
            ForEach(0..<3){row in
                HStack{
                    ForEach(0..<3){column in
                        
                        Button(action: {
                            self.game[row][column] = queue ?"❌":"⭕️";
                            queue.toggle();
                            check()
                        }){
                            ZStack{
                                Image(systemName:game[row][column] != "" ? "" : "square.dashed")
                                    .resizable()
                                    .aspectRatio( contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.purple)
                                Text(game[row][column])
                            }
                        }.disabled(game[row][column] != "" || winText != "")
                        
                    }
                }
            }
            Spacer()
            Text("\(winText) Has Won! 🎉").opacity(winText != "" ? 1 : 0).font(.largeTitle).bold();
            Spacer()
            Button(action: {
                game = Array(repeating: Array(repeating: "", count: 3), count: 3)
                winText = "";
            }, label: {
                Text("New Game")
                    .font(.largeTitle)
            })
        }
    }
    
    func check() {
        for i in 0..<3{
            if game[i][0] != "" && game[i][0] == game[i][1] && game[i][0] == game[i][2]{
                //                 Win
                print("Row Win")
                winText = !queue ?"❌":"⭕️";
                return
            }
            if game[0][i] != "" && game[0][i] == game[1][i] && game[0][i] == game[2][i]{
                //                 Win
                print("Column Win")
                winText = !queue ?"❌":"⭕️";
                return
            }
        }
        if game[0][0] != "" && game[0][0] == game[1][1] && game[0][0] == game[2][2]{
            //             Win
            print("Cross Win")
            winText = !queue ?"❌":"⭕️";
        }
        if game[0][2] != "" && game[0][2] == game[1][1] && game[0][2] == game[2][0]{
            //             Win
            print("Reverse Cross Win")
            winText = !queue ?"❌":"⭕️";
        }
    }
}

#Preview {
    ContentView()
}
