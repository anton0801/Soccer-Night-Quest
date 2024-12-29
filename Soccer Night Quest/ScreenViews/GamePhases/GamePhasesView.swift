import SwiftUI

struct GameGridStyle {
    var fieldName: String
    var grid: String
}

struct GamePhasesView: View {
    
    @Environment(\.presentationMode) var presMode
    var gameGridStyle = [
        GameGridStyle(fieldName: "MIAMI\nKICKOFF", grid: "3x3"),
        GameGridStyle(fieldName: "BEACH BALL\nBLITZ", grid: "4x4"),
        GameGridStyle(fieldName: "SUNSHINE\nSOCCER", grid: "5x5")
    ]
    @State var gameGridIndex = 0
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("back_btn")
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                let selectedItem = gameGridStyle[gameGridIndex]
                Text("\(selectedItem.fieldName)")
                    .font(.custom("SuezOne-Regular", size: 42))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Button {
                        withAnimation(.linear) {
                            if gameGridIndex > 0 {
                                gameGridIndex -= 1
                            }
                        }
                    } label: {
                        Image("back_btn")
                    }
                    
                    Text("\(selectedItem.grid)")
                        .font(.custom("SuezOne-Regular", size: 42))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        withAnimation(.linear) {
                            if gameGridIndex < gameGridStyle.count - 1 {
                                gameGridIndex += 1
                            }
                        }
                    } label: {
                        Image("back_btn")
                            .rotationEffect(.degrees(180))
                    }
                }
                
                Spacer()
                
                Image("grid_\(gameGridStyle[gameGridIndex].grid)_preview")
                
                NavigationLink(destination: GameView(grid: gameGridStyle[gameGridIndex].grid)
                    .navigationBarBackButtonHidden()) {
                    Image("play_btn")
                }
                
                Spacer()
            }
            .background(
                Image("grid_\(gameGridStyle[gameGridIndex].grid)")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    GamePhasesView()
}
