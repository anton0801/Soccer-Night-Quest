import SwiftUI
import SpriteKit

struct GameView: View {
    
    @Environment(\.presentationMode) var presMode
    var grid: String
    
    @State var balanceOfCoins = 0
    @State var gameFootballScene: GameScene!
    
    @State var gameOver = false
    @State var pausedGame = false
    @State var gameWin = false
    
    var body: some View {
        ZStack {
            if let gameFootballScene = gameFootballScene {
                SpriteView(scene: gameFootballScene)
                    .ignoresSafeArea()
            }
            
            if gameOver {
                gameOverView
            }
            
            if pausedGame {
                pausedGameView
            }
            if gameWin {
                gameWinView
            }
        }
        .onChange(of: balanceOfCoins) { new in
            UserDefaults.standard.set(new, forKey: "balance_coins")
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("paused")), perform: { _ in
            withAnimation(.easeInOut) {
                pausedGame = true
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game_lose")), perform: { _ in
            withAnimation(.easeInOut) {
                gameOver = true
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game_win")), perform: { _ in
            withAnimation(.easeInOut) {
                gameWin = true
            }
        })
        .onAppear {
            gameFootballScene = GameScene(grid: grid)
            balanceOfCoins = UserDefaults.standard.integer(forKey: "balance_coins")
        }
    }
    
    private var gameOverView: some View {
        VStack {
            Spacer()
            ZStack {
                Image("cloud")
                VStack {
                    Text("You time is over!")
                        .font(.custom("SuezOne-Regular", size: 32))
                        .foregroundColor(Color.init(red: 253/255, green: 51/255, blue: 135/255))
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Image("currency")
                        Text("Your losses: -30")
                            .font(.custom("SuezOne-Regular", size: 32))
                            .foregroundColor(Color.init(red: 253/255, green: 51/255, blue: 135/255))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            Button {
                gameFootballScene = gameFootballScene.restartGame()
                withAnimation(.linear) {
                    gameOver = false
                }
            } label: {
                Image("retry")
            }
            Button {
                presMode.wrappedValue.dismiss()
            } label: {
                Image("menu")
            }
            
            Spacer()
            
            HStack {
                Spacer()
            }
        }
        .onAppear {
            balanceOfCoins -= 30
        }
        .background(
            Rectangle()
                .fill(.black)
                .opacity(0.5)
                .ignoresSafeArea()
        )
    }
    
    private var pausedGameView: some View {
        VStack {
            Spacer()
            ZStack {
                Image("cloud")
                VStack {
                    Text("Your game is on\npause!")
                        .font(.custom("SuezOne-Regular", size: 32))
                        .foregroundColor(Color.init(red: 253/255, green: 51/255, blue: 135/255))
                        .multilineTextAlignment(.center)
                }
            }
            Button {
                withAnimation(.linear) {
                    pausedGame = false
                }
            } label: {
                Image("continue")
            }
            Button {
                presMode.wrappedValue.dismiss()
            } label: {
                Image("menu")
            }
            
            Spacer()
            
            HStack {
                Spacer()
            }
        }
        .onAppear {
            balanceOfCoins -= 30
        }
        .background(
            Rectangle()
                .fill(.black)
                .opacity(0.5)
                .ignoresSafeArea()
        )
    }
    
    private var gameWinView: some View {
        VStack {
            Spacer()
            ZStack {
                Image("cloud")
                VStack {
                    Text("CONGRATULATION!")
                        .font(.custom("SuezOne-Regular", size: 32))
                        .foregroundColor(Color.init(red: 253/255, green: 51/255, blue: 135/255))
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Image("currency")
                        Text("You win: +30")
                            .font(.custom("SuezOne-Regular", size: 32))
                            .foregroundColor(Color.init(red: 253/255, green: 51/255, blue: 135/255))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            
            Button {
                presMode.wrappedValue.dismiss()
            } label: {
                Image("menu")
            }
            
            Spacer()
            
            HStack {
                Spacer()
            }
        }
        .onAppear {
            balanceOfCoins += 30
        }
        .background(
            Rectangle()
                .fill(.black)
                .opacity(0.5)
                .ignoresSafeArea()
        )
    }
    
}

#Preview {
    GameView(grid: "3x3")
}
