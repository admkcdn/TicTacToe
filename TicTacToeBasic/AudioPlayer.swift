//
//  AudioPlayer.swift
//  TicTacToeBasic
//
//  Created by Adem Koçdoğan on 25.05.2024.
//

import AVFAudio


class AudioPlayer: ObservableObject {
    var audioPlayer: AVAudioPlayer?

    func playSound() {
        if let path = Bundle.main.path(forResource: "smile", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error: Could not play the sound file.")
            }
        }
    }
}
