//
//  TicTacToe.swift
//  BasicsApp
//
//  Created by Adem Koçdoğan on 26.03.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var game: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @State var currentPlayer : String = "X"
    @State var moevcCount: Int = 0
    let maxMoves = 9
    @State var isFinished: Bool = false
    
    @State private var queue: Bool = false
    
    @State private var winText: String=""
    @StateObject var audioPlayer = AudioPlayer()
    
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
                            self.game[row][column] = queue ?"❌":"⭕️"
                            queue.toggle()
                            check()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1..<6)){
                                print("selamlar sonrasında geldim ben")
                            
                                ContentView.AIMove(matrix: &game, player: queue ? "❌":"⭕️")
                                queue.toggle()
                                check()
                            }
//                            queue.toggle()
//                            ContentView.AIMove(matrix: &game, player: queue ? "❌":"⭕️")
                            
                        }){
                            ZStack{
                                Image(systemName:game[row][column] != "" ? "" : "square.dashed")
                                    .resizable()
                                    .aspectRatio( contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.purple)
                                Text(game[row][column])
                            }
                        }.disabled(game[row][column] != "" || winText != "" || queue)
                        
                    }
                }
            }
            Spacer()
            Text("\(winText) Has Won! 🎉").opacity(winText != "" ? 1 : 0).font(.largeTitle).bold()
            Spacer()
            Button(action: {
                game = Array(repeating: Array(repeating: "", count: 3), count: 3)
                winText = ""
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
                winText = !queue ?"❌":"⭕️"
                return
            }
            if game[0][i] != "" && game[0][i] == game[1][i] && game[0][i] == game[2][i]{
                //                 Win
                print("Column Win")
                winText = !queue ?"❌":"⭕️"
                return
            }
        }
        if game[0][0] != "" && game[0][0] == game[1][1] && game[0][0] == game[2][2]{
            //             Win
            print("Cross Win")
            winText = !queue ?"❌":"⭕️"
        }
        if game[0][2] != "" && game[0][2] == game[1][1] && game[0][2] == game[2][0]{
            //             Win
            print("Reverse Cross Win")
            winText = !queue ?"❌":"⭕️"
        }
        
        if(winText != ""){
            audioPlayer.playSound()
        }
    }
    
    private static func AIMove(matrix: inout [[String]], player: String){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            print("selamlar sonrasında geldim ben")
        }
        
        var winRow: Int = 0
        var winCol: Int = 0
        var blockRow: Int = 0
        var blockCol: Int = 0
        
        if(TryWinOrBlock(matrix: matrix, player: player, targetRow: &winRow, targetCol: &winCol)){
            matrix[winRow][winCol] = player
            return
        }
        
        if (TryWinOrBlock(matrix: matrix,player: (player == "X" ? "O" : "X"), targetRow: &blockRow, targetCol: &blockCol))
        {
            matrix[blockRow][blockCol] = player
            return
        }
        
        if (IsMoveValid(matrix: matrix, row: 1, col: 1))
        {
            matrix[1][1] = player
            return
        }
        
        for (row, col) in [(0, 0), (0, 2), (2, 0), (2, 2)] {
            if IsMoveValid(matrix: matrix, row: row, col: col) {
                matrix[row][col] = player
                return
            }
        }
        
        
        for row in 0..<3 {
            for col in 0..<3 {
                if IsMoveValid(matrix: matrix, row: row, col: col) {
                    matrix[row][col] = player
                    return
                }
            }
        }

    }
    
    private static func TryWinOrBlock(matrix: [[String]], player: String, targetRow: inout Int, targetCol: inout Int) -> Bool{
        for row in 0..<3{
            if(matrix[row][0] == player && matrix[row][1] == player && IsMoveValid(matrix: matrix, row: row, col: 2)){
                targetRow = row
                targetCol = 2
                return true
            }
            if (matrix[row][1] == player && matrix[row][2] == player && IsMoveValid(matrix: matrix, row: row, col: 0))
            {
                targetRow = row
                targetCol = 0
                return true
            }
            if (matrix[row][0] == player && matrix[row][2] == player && IsMoveValid(matrix: matrix, row: row, col: 1))
            {
                targetRow = row
                targetCol = 1
                return true
            }
        }
        
        for col in 0..<3{
            if (matrix[0][col] == player && matrix[1][col] == player && IsMoveValid(matrix: matrix, row: 2, col: col))
            {
                targetRow = 2
                targetCol = col
                return true
            }
            if (matrix[1][col] == player && matrix[2][col] == player && IsMoveValid(matrix: matrix, row: 0, col: col))
            {
                targetRow = 0
                targetCol = col
                return true
            }
            if (matrix[0][col] == player && matrix[2][col] == player && IsMoveValid(matrix: matrix, row: 1, col: col))
            {
                targetRow = 1
                targetCol = col
                return true
            }
        }
        
        if (matrix[0][0] == player && matrix[1][1] == player && IsMoveValid(matrix: matrix, row: 2, col: 2))
        {
            targetRow = 2
            targetCol = 2
            return true
        }
        if (matrix[1][1] == player && matrix[2][2] == player && IsMoveValid(matrix: matrix, row: 0, col: 0))
        {
            targetRow = 0
            targetCol = 0
            return true
        }
        if (matrix[0][0] == player && matrix[2][2] == player && IsMoveValid(matrix: matrix, row: 1, col: 1))
        {
            targetRow = 1
            targetCol = 1
            return true
        }
        
        if (matrix[0][2] == player && matrix[1][1] == player && IsMoveValid(matrix: matrix, row: 2, col: 0))
        {
            targetRow = 2
            targetCol = 0
            return true
        }
        if (matrix[1][1] == player && matrix[2][0] == player && IsMoveValid(matrix: matrix, row: 0, col: 2))
        {
            targetRow = 0
            targetCol = 2
            return true
        }
        if (matrix[0][2] == player && matrix[2][0] == player && IsMoveValid(matrix: matrix, row: 1, col: 1))
        {
            targetRow = 1
            targetCol = 1
            return true
        }
        
        targetRow = -1
        targetCol = -1
        return false
    }
    
    private static func IsMoveValid(matrix: [[String]], row:Int, col: Int)->Bool{
        return matrix[row][col] == ""
    }
}

#Preview {
    ContentView()
}
