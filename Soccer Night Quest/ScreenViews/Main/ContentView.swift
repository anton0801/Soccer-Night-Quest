import SwiftUI

struct ContentView: View {
    
    @State var boardingShowed = false
    
    @State var soundsActive = false
    @State var vibroActive = false
    
    @State var rulesVisible = false
    @State var dailyReward = false
    @State var dailyRewardDouble = false
    @State var dailyRewardDoubleWin = false
    @State var dailyRewardNotAvailableAlert = false
    
    @State var balanceOfCoins = 0
    
    var body: some View {
        VStack {
            if !boardingShowed {
                boardingView
            } else {
                mainContent
            }
        }
        .onAppear {
            boardingShowed = UserDefaults.standard.bool(forKey: "boarding_view_was_presented")
            soundsActive = UserDefaults.standard.bool(forKey: "soundsActive")
            vibroActive = UserDefaults.standard.bool(forKey: "vibroActive")
            balanceOfCoins = UserDefaults.standard.integer(forKey: "balance_coins")
        }
        .onChange(of: soundsActive) { new in
            UserDefaults.standard.set(new, forKey: "soundsActive")
        }
        .onChange(of: vibroActive) { new in
            UserDefaults.standard.set(new, forKey: "vibroActive")
        }
        .onChange(of: balanceOfCoins) { new in
            UserDefaults.standard.set(new, forKey: "balance_coins")
        }
        .alert(isPresented: $dailyRewardNotAvailableAlert) {
            Alert(title: Text("Daily Bonus not available!"), message: Text("Daily bonus currently not available! You can claim new daily bonus in 24 hours!"))
        }
    }
    
    private var mainContent: some View {
        ZStack {
            VStack {
                Spacer()
                Image("main_coala")
            }
            VStack {
                HStack {
                    Button {
                        withAnimation(.linear) {
                            soundsActive = !soundsActive
                        }
                    } label: {
                        if soundsActive {
                            Image("sounds_active")
                        } else {
                            Image("sounds_inactive")
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.linear) {
                            vibroActive = !vibroActive
                        }
                    } label: {
                        if vibroActive {
                            Image("vibro_active")
                        } else {
                            Image("vibro_inactive")
                        }
                    }
                }
                .padding(.horizontal)
                
                Text("Soccer Night\nQUEST")
                    .font(.custom("SuezOne-Regular", size: 42))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                HStack {
                    Image("currency")
                    Text("\(balanceOfCoins)")
                        .font(.custom("SuezOne-Regular", size: 24))
                        .foregroundColor(.white)
                }
                .background(
                    Image("value_bg")
                )
                .padding(.bottom)
                
                NavigationLink(destination: GameView(grid: "3x3" )
                    .navigationBarBackButtonHidden()) {
                    Image("play_btn")
                }
                
                Button {
                    rulesContentIndex = 0
                    withAnimation(.easeInOut) {
                        rulesVisible = true
                    }
                } label: {
                    Image("rules_btn")
                }
                .padding(.bottom)
                
                HStack {
                    Spacer()
                    NavigationLink(destination: GamePhasesView()
                        .navigationBarBackButtonHidden()) {
                        Image("levels_btn")
                    }
                    Spacer()
                    Button {
                        if isBonusAvailable() {
                            dailyReward = true
                        } else {
                            dailyRewardNotAvailableAlert = true
                        }
                    } label: {
                        Image("daily_btn")
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            if rulesVisible {
                rulesContent
            }
            
            if dailyReward {
                if dailyRewardDouble {
                    dailyRewardDoubleView
                } else {
                    dailyRewardView
                }
            }
        }
        .preferredColorScheme(.dark)
        .background(
            Image("loading_splash_image")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
    private var boardingTexts = [
        "Hi there! I'm Leo, and football is my life.",
        "I'm known for my incredible technique and ability to score goals, but one day, something unexpected happened.",
        "During a training session, all my footballs disappeared!",
        "I was in despair, as without my footballs, I couldn't train and prepare for upcoming matches.",
        "At that moment, my loyal friend, a koala named Coco, came to the rescue.",
        "Here he is!",
        "Let’s help leo find his football balls!"
    ]
    @State var boardingIndex = 0
    
    private var boardingView: some View {
        VStack {
            Text("WHAT\nHAPPENED!")
                .font(.custom("SuezOne-Regular", size: 42))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Text(boardingTexts[boardingIndex])
                .font(.custom("SuezOne-Regular", size: 20))
                .foregroundColor(Color.init(red: 253/255, green: 51/255, blue: 135/255))
                .frame(width: 230)
                .offset(x: 40)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut) {
                    if boardingIndex < boardingTexts.count - 1 {
                        boardingIndex += 1
                    } else {
                        boardingShowed = true
                        UserDefaults.standard.set(true, forKey: "boarding_view_was_presented")
                    }
                }
            } label: {
                Image("next_btn")
            }
            .offset(x: 30)
            
            Spacer()
        }
        .background(
            Image("boarding_bg")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
    private var rulesData = [
        "You begin with a 4x4 grid that has two footballs, each with a value of 2.",
        "You can move the footballs in one of four directions: up, down, left, or right.",
        "All footballs on the board will move in the chosen direction until they hit an obstacle, such as another football or the edge of the board.",
        "If two footballs with the same value collide, they combine, and their value doubles. For example, 2 + 2 = 4, 4 + 4 = 8, and so on.",
        "After each move, a new football with a value of 2 or 4 (with a 90% and 10% chance, respectively) appears on the board."
    ]
    @State var rulesContentIndex = 0
    
    private var rulesContent: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Image("footballer")
                    Spacer()
                }
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        withAnimation(.linear) {
                            rulesVisible = false
                        }
                    } label: {
                        Image("back_btn")
                    }
                    Spacer()
                }
                
                Spacer()
                
                Text(rulesData[rulesContentIndex])
                    .font(.custom("SuezOne-Regular", size: 20))
                    .foregroundColor(Color.init(red: 253/255, green: 51/255, blue: 135/255))
                    .frame(width: 230)
                    .offset(x: 40)
                    .multilineTextAlignment(.center)
                    .background(
                        Image("cloud")
                    )
                
                Button {
                    withAnimation(.linear) {
                        if rulesContentIndex < rulesData.count - 1 {
                            rulesContentIndex += 1
                        } else {
                            rulesVisible = false
                        }
                    }
                } label: {
                    Image("next_btn")
                }
                .offset(x: 40, y: 40)
                
                Spacer()
            }
        }
        .background(
            Rectangle()
                .fill(.black)
                .opacity(0.5)
        )
    }
    
    private var dailyRewardView: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("man")
                }
            }
            .ignoresSafeArea()
            
            VStack {
                Text("DAILY\nREWARD!")
                    .font(.custom("SuezOne-Regular", size: 42))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Image("currency")
                    Text("\(balanceOfCoins)")
                        .font(.custom("SuezOne-Regular", size: 24))
                        .foregroundColor(.white)
                }
                .background(
                    Image("value_bg")
                )
                
                Spacer()
                
                HStack {
                    Text("+100")
                        .font(.custom("SuezOne-Regular", size: 72))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Image("currency")
                        .resizable()
                        .frame(width: 62, height: 62)
                }
                
                Spacer()
                
                Button {
                    balanceOfCoins += 100
                    withAnimation(.linear) {
                        dailyReward = false
                    }
                } label: {
                    Image("take")
                }
                .padding(.bottom)
                
                Button {
                    withAnimation(.easeInOut) {
                        dailyRewardDouble = true
                    }
                } label: {
                    Image("double")
                }
            }
        }
        .background(
            Rectangle()
                .fill(.black)
                .opacity(0.5)
        )
    }
    
    @State private var rotationAngle: Double = 0
    @State private var isSpinning = false
    
    private var dailyRewardDoubleView: some View {
        ZStack {
            
            VStack {
                Text("DAILY\nREWARD!")
                    .font(.custom("SuezOne-Regular", size: 42))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Image("currency")
                    Text("\(balanceOfCoins)")
                        .font(.custom("SuezOne-Regular", size: 24))
                        .foregroundColor(.white)
                }
                .background(
                    Image("value_bg")
                )
                
                Spacer()
                
                if !dailyRewardDoubleWin {
                    HStack {
                        Text("+100")
                            .font(.custom("SuezOne-Regular", size: 72))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Image("currency")
                            .resizable()
                            .frame(width: 62, height: 62)
                    }
                } else {
                    HStack {
                        Text("+400")
                            .font(.custom("SuezOne-Regular", size: 72))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Image("currency")
                            .resizable()
                            .frame(width: 62, height: 62)
                    }
                    
                    Spacer()
                    
                    Button {
                        balanceOfCoins += 400
                        markBonusAsReceived()
                        withAnimation(.linear) {
                            dailyRewardDoubleWin = false
                            dailyRewardDouble = false
                            dailyReward = false
                        }
                    } label: {
                        Image("take")
                    }
                }
                
                Spacer()
            }
            
                
            if !dailyRewardDoubleWin {
                VStack {
                    HStack {
                        Spacer()
                    }
                    Spacer()
                    
                    ZStack {
                        Image("double_roulette")
                            .resizable()
                            .frame(width: 400, height: 400)
                            .rotationEffect(.degrees(rotationAngle))
                            .animation(.easeOut(duration: 2), value: rotationAngle)
                        Image("arrow_indicator")
                            .offset(y: -165)
                        Button {
                            spinRoulette()
                        } label: {
                            Image("spin_btn")
                        }
                        .offset(y: -40)
                        .opacity(isSpinning ? 0 : 1)
                        .disabled(isSpinning ? true : false)
                    }
                    .offset(y: 200)
                }
                .ignoresSafeArea()
            } else {
                VStack {
                    HStack {
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .background(
            Rectangle()
                .fill(.black)
                .opacity(0.5)
        )
    }
    
    private let lastBonusKey = "lastBonusReceivedDate"
    private let bonusInterval: TimeInterval = 24 * 60 * 60
    
    private func spinRoulette() {
        guard !isSpinning else { return } // Не даем крутить рулетку снова, пока она вращается
        
        isSpinning = true
        
        // Увеличиваем угол вращения на 5 полных оборотов + случайное значение для остановки
        let fullRotations = 360 * 5
        rotationAngle += Double(fullRotations)

        // Устанавливаем задержку после завершения вращения
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSpinning = false
            withAnimation(.linear) {
                dailyRewardDoubleWin = true
            }
        }
    }
    
    func isBonusAvailable() -> Bool {
        if let lastBonusDate = UserDefaults.standard.object(forKey: lastBonusKey) as? Date {
            let currentTime = Date()
            let timeSinceLastBonus = currentTime.timeIntervalSince(lastBonusDate)
            return timeSinceLastBonus >= bonusInterval
        }
        return true // Если бонус никогда не получали, он доступен
    }
    
    // Метод для записи времени получения бонуса
    func markBonusAsReceived() {
        let currentTime = Date()
        UserDefaults.standard.set(currentTime, forKey: lastBonusKey)
    }
    
}

#Preview {
    ContentView()
}
