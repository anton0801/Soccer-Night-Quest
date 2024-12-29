import SwiftUI
import SpriteKit

class GameScene: SKScene {
    
    var grid: String
    
    var balanceCoins = UserDefaults.standard.integer(forKey: "balance_coins")
    
    private var pauseBtn: SKSpriteNode!
    private var cellSize: CGSize!
    
    private var gridValues: [[Int?]] = [] {
        didSet {
            checkGrid()
        }
    }
    
    private func checkGrid() {
        let gridSize = gridValues.count

        // Проверяем наличие пустых клеток (их можно использовать для движения)
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if gridValues[row][col] == nil {
                    return // Есть пустая клетка, игра продолжается
                }
            }
        }

        // Проверяем возможные слияния по строкам и столбцам
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if col < gridSize - 1, gridValues[row][col] == gridValues[row][col + 1] {
                    return // Можно слить плитки в строке
                }
                if row < gridSize - 1, gridValues[row][col] == gridValues[row + 1][col] {
                    return // Можно слить плитки в столбце
                }
            }
        }

        // Если нет ни пустых клеток, ни возможных слияний, игра завершена
        gameOver()
    }
    
    private func gameOver() {
        isPaused = true
        NotificationCenter.default.post(name: Notification.Name("game_lose"), object: nil)
    }
    
    private func gameWin() {
        isPaused = true
        NotificationCenter.default.post(name: Notification.Name("game_win"), object: nil)
    }
    
    func restartGame() -> GameScene {
        let newGameScene = GameScene(grid: grid)
        view?.presentScene(newGameScene)
        return newGameScene
    }
    
    private var objective = [512, 1024, 256].randomElement() ?? 512
    private var objectiveCollected = 0 {
        didSet {
            objectiveCollectLabel.text = "\(objectiveCollected)/\(objectiveCollectedCount)"
        }
    }
    private var objectiveCollectedCount = Int.random(in: 1...3)
    private var objectiveCollectLabel: SKLabelNode!
    
    init(grid: String) {
        self.grid = grid
        super.init(size: CGSize(width: 750, height: 1350))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeGrid(gridSize: Int) {
        gridValues = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "grid_3x3")
        background.size = size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        addChild(background)
        
        let balanceBg = SKSpriteNode(imageNamed: "value_bg")
        balanceBg.position = CGPoint(x: size.width - 150, y: size.height - 140)
        balanceBg.size = CGSize(width: 300, height: 100)
        addChild(balanceBg)
        
        let currencyIcon = SKSpriteNode(imageNamed: "currency")
        currencyIcon.position = CGPoint(x: size.width - 230, y: size.height - 140)
        currencyIcon.size = CGSize(width: 52, height: 52)
        addChild(currencyIcon)
        
        let balanceLabel = SKLabelNode(text: "\(balanceCoins)")
        balanceLabel.fontColor = .white
        balanceLabel.fontSize = 42
        balanceLabel.fontName = "SuezOne-Regular"
        balanceLabel.position = CGPoint(x: size.width - 130, y: size.height - 155)
        addChild(balanceLabel)
        
        pauseBtn = SKSpriteNode(imageNamed: "pause_btn")
        pauseBtn.position = CGPoint(x: 90, y: size.height - 150)
        pauseBtn.size = CGSize(width: 110, height: 100)
        addChild(pauseBtn)
        
        var fieldName = "MIAMI KICKOFF"
        if grid == "4x4" {
            fieldName = "BEACH BALL BLITZ"
        } else if grid == "5x5" {
            fieldName = "SUNSHINE SOCCER"
        }
        let fieldNameLabel = SKLabelNode(text: fieldName)
        fieldNameLabel.position = CGPoint(x: size.width / 2, y: size.height - 270)
        fieldNameLabel.fontColor = .white
        fieldNameLabel.fontSize = 62
        fieldNameLabel.fontName = "SuezOne-Regular"
        addChild(fieldNameLabel)
        
        let gridItemsBg = SKSpriteNode(imageNamed: "grid_items_bg")
        gridItemsBg.position = CGPoint(x: size.width / 2, y: size.height / 2 - 200)
        gridItemsBg.size = CGSize(width: 700, height: 600)
        addChild(gridItemsBg)
        
        setUpCollectInfo()
        setUpGame()
    }
    
    private func setUpCollectInfo() {
        let collectBg = SKSpriteNode(imageNamed: "collect_info")
        collectBg.position = CGPoint(x: size.width / 2, y: size.height - 380)
        collectBg.size = CGSize(width: 500, height: 120)
        addChild(collectBg)
        
        let objectiveText = SKLabelNode(text: "\(objective)")
        objectiveText.position = CGPoint(x: size.width / 2 + 69, y: size.height - 385)
        objectiveText.fontColor = UIColor.init(red: 253/255, green: 51/255, blue: 135/255, alpha: 1)
        objectiveText.fontSize = 20
        objectiveText.fontName = "SuezOne-Regular"
        addChild(objectiveText)
        
        objectiveCollectLabel = SKLabelNode(text: "0/\(objectiveCollectedCount)")
        objectiveCollectLabel.position = CGPoint(x: size.width / 2 + 160, y: size.height - 393)
        objectiveCollectLabel.fontColor = .white
        objectiveCollectLabel.fontSize = 42
        objectiveCollectLabel.fontName = "SuezOne-Regular"
        addChild(objectiveCollectLabel)
    }
    
    private let containerSize = CGSize(width: 600, height: 500)
    private let gridSpacing: CGFloat = 10
    
    private func setUpGame() {
        var gridSize = 3
        if grid == "4x4" {
            gridSize = 4
        } else if grid == "5x5" {
            gridSize = 5
        }
        let cellWidth = (containerSize.width - CGFloat(gridSize - 1) * gridSpacing) / CGFloat(gridSize)
        let cellHeight = (containerSize.height - CGFloat(gridSize - 1) * gridSpacing) / CGFloat(gridSize)
        cellSize = CGSize(width: cellWidth, height: cellHeight)
        createGrid(gridSize: gridSize, cellSize: cellSize)
        
        initializeGrid(gridSize: gridSize)
        
        let positions = generatePositions(gridSize: gridSize)
        for pos in positions {
            let tileValue = [2, 4].randomElement() ?? 2
            addChild(addBallTile(row: pos.0, col: pos.1, cellSize: cellSize, tileValue: tileValue))
        }
    }
    
    private func generatePositions(gridSize: Int) -> [(Int, Int)] {
        var result: [(Int, Int)] = []
        func gen() -> (Int, Int) {
            let resultGen = (Int.random(in: 0...gridSize - 1), Int.random(in: 0...gridSize - 1))
            if result.contains(where: {
                $0.0 == resultGen.0 && $0.1 == resultGen.1
            }) {
                return gen()
            }
            return resultGen
        }
        for _ in 0..<4 {
            result.append(gen())
        }
        return result
    }
    
    private func createGrid(gridSize: Int, cellSize: CGSize) {
        let startX = size.width / 2 + -containerSize.width / 2 + cellSize.width / 2
        let startY = (size.height / 2 - 200) + containerSize.height / 2 - cellSize.height / 2
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let xPosition = startX + CGFloat(col) * (cellSize.width + gridSpacing)
                let yPosition = startY - CGFloat(row) * (cellSize.height + gridSpacing)
                let cell = SKSpriteNode(imageNamed: "cell_grid")
                cell.size = cellSize
                cell.position = CGPoint(x: xPosition, y: yPosition)
                cell.name = "cell_\(row)_\(col)"
                self.addChild(cell)
            }
        }
    }
    
    private func addBallTile(row: Int, col: Int, cellSize: CGSize, tileValue: Int) -> SKSpriteNode {
        let startX = size.width / 2 + -containerSize.width / 2 + cellSize.width / 2
        let startY = (size.height / 2 - 200) + containerSize.height / 2 - cellSize.height / 2
        let xPosition = startX + CGFloat(col) * (cellSize.width + gridSpacing)
        let yPosition = startY - CGFloat(row) * (cellSize.height + gridSpacing)
        
        let resultNode = SKSpriteNode()
        resultNode.size = cellSize
        
        let tileNode = SKSpriteNode(imageNamed: "ball_tile")
        tileNode.size = cellSize
        tileNode.name = "tile_\(row)_\(col)_\(tileValue)"
        resultNode.addChild(tileNode)
        
        let tileLabelNode = SKLabelNode(text: String(tileValue))
        tileLabelNode.fontSize = 42
        tileLabelNode.fontColor = UIColor.init(red: 253/255, green: 51/255, blue: 135/255, alpha: 1)
        tileLabelNode.position = CGPoint(x: 0, y: -10)
        tileLabelNode.fontName = "SuezOne-Regular"
        resultNode.addChild(tileLabelNode)
        
        gridValues[row][col] = tileValue
        
        resultNode.position = CGPoint(x: xPosition, y: yPosition)
        resultNode.name = "tile_\(row)_\(col)_\(tileValue)"
        
        return resultNode
    }
    
    private var selectedTile: SKNode? = nil
    
    private var combinetedCount = 0
    private var movedCount = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let object = atPoint(location)
            
            if object == pauseBtn {
                isPaused = true
                NotificationCenter.default.post(name: Notification.Name("paused"), object: nil)
            }
            
            if object.name?.contains("cell") == true {
                if let selectedTile = selectedTile {
                    
                    let selectedComps = selectedTile.name!.components(separatedBy: "_")
                    let selectedTileValue = Int(selectedComps[3])
                    let targetComps = object.name!.components(separatedBy: "_")
                    
                    self.gridValues[Int(selectedComps[1]) ?? 0][Int(selectedComps[2]) ?? 0] = nil
                    self.gridValues[Int(targetComps[1]) ?? 0][Int(targetComps[2]) ?? 0] = selectedTileValue ?? 1
                    
                    selectedTile.parent?.run(SKAction.sequence([
                        SKAction.move(to: object.position, duration: 0.3),
                        SKAction.scale(to: 1, duration: 0.2)
                    ])) {
                        if self.movedCount == 3 {
                            self.movedCount = 0
                            var gridSize = 3
                            if self.grid == "4x4" {
                                gridSize = 4
                            } else if self.grid == "5x5" {
                                gridSize = 5
                            }
                            
                            let tileValue = [2, 4].randomElement() ?? 2
                            let resultGen = (Int.random(in: 0...gridSize - 1), Int.random(in: 0...gridSize - 1))
                            self.addChild(self.addBallTile(row: resultGen.0, col: resultGen.1, cellSize: self.cellSize, tileValue: tileValue))
                            self.gridValues[resultGen.0][resultGen.1] = tileValue
                        } else {
                            self.movedCount += 1
                        }
                    }
                    self.selectedTile = nil
                }
            }
            
            if object.name?.contains("tile_") == true {
                selectedTile?.run(SKAction.scale(to: 1.0, duration: 0.3))
                    
                if selectedTile != nil {
                    if selectedTile?.name != object.name {
                        // other tile
                        let selectedComps = selectedTile!.name!.components(separatedBy: "_")
                        let selectedTileValue = Int(selectedComps[3])
                        let targetComps = object.name!.components(separatedBy: "_")
                        let targetTileValue = Int(targetComps[3])
                        
                        if selectedTileValue == targetTileValue {
                            let targetRow = Int(targetComps[1]) ?? 0
                            let targetCol = Int(targetComps[2]) ?? 0
                            
                            selectedTile?.parent?.run(SKAction.sequence([
                                SKAction.move(to: object.parent?.position ?? CGPoint(x: 0, y: 0), duration: 0.4),
                                SKAction.fadeAlpha(to: 0, duration: 0.2),
                                SKAction.removeFromParent()
                            ])) {
                                object.parent?.run(SKAction.sequence([
                                    SKAction.fadeAlpha(to: 0, duration: 0.2),
                                    SKAction.removeFromParent()
                                ]))
                                self.addChild(self.addBallTile(row: targetRow, col: targetCol, cellSize: self.cellSize, tileValue: (selectedTileValue ?? 1) * 2))
                                self.gridValues[Int(selectedComps[1]) ?? 0][Int(selectedComps[2]) ?? 0] = nil
                                self.gridValues[Int(targetComps[1]) ?? 0][Int(targetComps[2]) ?? 0] = (selectedTileValue ?? 1) * 2
                                if (selectedTileValue ?? 1) * 2 == self.objective {
                                    self.gameWin()
                                }
                                self.combinetedCount += 1
                                if self.combinetedCount == 2 {
                                    self.combinetedCount = 0
                                    var gridSize = 3
                                    if self.grid == "4x4" {
                                        gridSize = 4
                                    } else if self.grid == "5x5" {
                                        gridSize = 5
                                    }
                                    
                                    let tileValue = [2, 4].randomElement() ?? 2
                                    let resultGen = (Int.random(in: 0...gridSize - 1), Int.random(in: 0...gridSize - 1))
                                    self.addChild(self.addBallTile(row: resultGen.0, col: resultGen.1, cellSize: self.cellSize, tileValue: tileValue))
                                    self.gridValues[resultGen.0][resultGen.1] = tileValue
                                }
                            }
                        } else {
                            let pos = selectedTile?.position
                            if let pos = pos {
                                selectedTile?.run(SKAction.sequence([
                                    SKAction.scale(to: 1.0, duration: 0.3),
                                    SKAction.moveTo(x: pos.x - 20, duration: 0.3),
                                    SKAction.moveTo(x: pos.x + 20, duration: 0.3),
                                    SKAction.moveTo(x: pos.x, duration: 0.3)
                                ]))
                            }
                        }
                    }
                }
                
                selectedTile = object
                selectedTile?.run(SKAction.scale(to: 1.1, duration: 0.3))
                
                
            }
        }
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let location = touch.location(in: self)
//            let object = atPoint(location)
//            
//        }
//    }
    
}

#Preview {
    VStack {
        SpriteView(scene: GameScene(grid: "3x3"))
            .ignoresSafeArea()
    }
}
