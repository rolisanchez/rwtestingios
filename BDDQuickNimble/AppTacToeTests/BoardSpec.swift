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

import Quick
import Nimble
@testable import AppTacToe

class BoardSpec: QuickSpec {
  override func spec() {
    var board: Board!
    
    beforeEach {
        board = Board()
    }
    
    describe("playing") {
        context("a single move") {
            it("should switch to nought") {
                try! board.playRandom()
                expect(board.state).to(equal(.playing(.nought)))
            }
        }
        context("two moves") {
            it("should switch back to cross") {
                try! board.playRandom()
                try! board.playRandom()
                expect(board.state) == .playing(.cross)
            }
        }
        context("a winning move") {
            it("should switch to won state") {
                // Arrange
                try! board.play(at: 0)
                try! board.play(at: 1)
                try! board.play(at: 3)
                try! board.play(at: 2)
                
                // Act
                try! board.play(at: 6)
                
                // Assert
//                expect(board.state) == .won(.cross)
                // MARK: Replace by custom predicate
                expect(board).to(beWon(by: .cross))
            }
        }
        context("a move leaving no remaining moves") {
            it("should switch to draw state") {
                // Arrange
                try! board.play(at: 0)
                try! board.play(at: 2)
                try! board.play(at: 1)
                try! board.play(at: 3)
                try! board.play(at: 4)
                try! board.play(at: 8)
                try! board.play(at: 6)
                try! board.play(at: 7)
                
                // Act
                try! board.play(at: 5)
                
                // Assert
                expect(board.state) == Board.State.draw
            }
        }
        context("a move that was already played") {
            it("should throw an error") {
                try! board.play(at: 0)
                
                expect { try board.play(at: 0) }
                    .to(throwError(Board.PlayError.alreadyPlayed))
            }
        }
        context("a move while the game was already won") {
            it("should throw an error") {
                // Arrange
                try! board.play(at: 0)
                try! board.play(at: 1)
                try! board.play(at: 3)
                try! board.play(at: 2)
                try! board.play(at: 6)
                
                // Act & Assert
                expect { try board.play(at: 7) }
                    .to(throwError(Board.PlayError.noGame))
            }
        }


    }

  }
}
