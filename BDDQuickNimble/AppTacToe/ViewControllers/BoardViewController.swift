/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class BoardViewController: UIViewController {
  @IBOutlet private var tiles: [UIButton]!
  public private(set) var board: Board! {
    didSet {
      board.delegate = self
    }
  }

  @IBOutlet weak private var imgCurrent: UIImageView!
  @IBOutlet weak private var lblCurrent: UILabel!

  private var markCross: UIImage!
  private var markNought: UIImage!

  override func viewDidLoad() {
    super.viewDidLoad()
    startGame()
  }

  @IBAction private func didTapTile(_ tile: UIButton) {
    // guard let position = tiles.index(of: tile) else { return }
    guard let position = tiles.firstIndex(of: tile) else { return }

    do {
      try board.play(at: position)
    } catch let err as Board.PlayError {
      switch err {
      case .alreadyPlayed: print("⚠️ This position has already been played")
      case .noGame: print("⚠️ There's no ongoing game at the moment")
      }
    } catch let err {
      fatalError("Unexpected error occured: \(err)")
    }
  }

  private func startGame() {
    markCross = [#imageLiteral(resourceName: "iOS1"), #imageLiteral(resourceName: "iOS2"), #imageLiteral(resourceName: "iOS3"), #imageLiteral(resourceName: "iOS4"), #imageLiteral(resourceName: "iOS5")].random()
    markNought = [#imageLiteral(resourceName: "android1"), #imageLiteral(resourceName: "android2"), #imageLiteral(resourceName: "android3"), #imageLiteral(resourceName: "android4"), #imageLiteral(resourceName: "android5")].random()
    board = Board()
    tiles.forEach { $0.setImage(nil, for: .normal) }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let gameOver = segue.destination as? GameOverViewController else { return }

    gameOver.delegate = self

    if case .won(let mark) = board.state {
      gameOver.winner = mark == .cross ? markCross : markNought
    }
  }
}

extension BoardViewController: BoardDelegate {
  func gameEnded(_ board: Board, state: Board.State) {
    switch state {
    case .won(let mark):
      print("🎉 Game won by \(mark), Congrats!")
      print(board)
    case .draw:
      print("🤝 Game ended with a Draw")
      print(board)
    default: break
    }

    performSegue(withIdentifier: "GameOver", sender: self)
  }

  func markPlayed(_ board: Board, mark: Board.Mark, position: Board.Position) {
    let tile = tiles[position]
    tile.setImage(mark == .cross ? markCross : markNought,
                  for: .normal)

  }

  func markChanged(_ board: Board, mark: Board.Mark) {
    imgCurrent.image = mark == .cross ? markCross : markNought
    lblCurrent.text = mark == .cross ? "You" : "Computer"
    print("🎲 Currently playing: \(mark)")

    // If mark is Nought, make the computer Play.
    // Also delay the auto-play so it visually makes sense.
    view.isUserInteractionEnabled = mark == .cross
    if mark == .nought {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
        guard let `self` = self else { return }

        do {
          try self.board.playRandom()
        } catch let err {
          fatalError("An unexpected error occured. Playing at random should never throw an error: \(err)")
        }
      }
    }
  }
}

extension BoardViewController: GameOverDelegate {
  func didDismiss(_ gameOverViewController: GameOverViewController) {
    print("♻️ Restarting game!")
    startGame()
  }
}
