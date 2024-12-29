import SwiftUI

struct GameLoadingView: View {
    
    @State var loadingProgress = 0.0
    @State var loadedgame = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                Text("LOADING...")
                    .font(.custom("SuezOne-Regular", size: 42))
                    .foregroundColor(.white)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 42, style: .continuous)
                        .fill(.black)
                        .frame(width: 300, height: 30)
                    
                    RoundedRectangle(cornerRadius: 42, style: .continuous)
                        .fill(
                            LinearGradient(colors: [
                                Color.init(red: 253/255, green: 51/255, blue: 135/255),
                                Color.init(red: 233/255, green: 58/255, blue: 189/255)
                            ], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: 290 * loadingProgress, height: 28)
                        .padding(.leading, 5)
                }
                
                NavigationLink(destination: ContentView()
                    .navigationBarBackButtonHidden(), isActive: $loadedgame) {
                        
                    }
            }
            .preferredColorScheme(.dark)
            .background(
                Image("loading_splash_image")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
                    .opacity(loadingProgress)
            )
            .onAppear {
                withAnimation(.linear(duration: 5)) {
                    loadingProgress = 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                    loadedgame = true
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    GameLoadingView()
}
