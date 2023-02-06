// SPDX-License-Identifier: MIT
pragma solidity ^0.4.0;

contract TicTacToe {

    // state variables
    uint[] board =new uint[](9);
    address player1;
    address player2;
    uint start = 0;
    uint[][] tests = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]];

    function tictactoe() public {
        player1 = msg.sender;
    }

    function joinGame() public {
        player2 = msg.sender;
    }

    function placeMarker(uint _place) public returns(string) {
        uint winner = checkWinner();
        if (winner == 1) {
            return "Player 1 (x) wins the game!";
        }
        if (winner == 2) {
            return "Player 2 (o) wins the game!";
        }
        // Check whose turn it is.
        if (start == 0) {
            if (msg.sender != player1) {
                return "You are not Player 1. It is not your turn.";
            } else if (start ==1) {
                if (msg.sender != player2) {
                    return "You are not player 2. It is not your turn.";
                }
            }
            // Has a valid position been played?
            if (_place < 0 || _place > 8) {
                return "Invalid position played. Must be 0 to 8.";
            }
            // check that a marker has not already been played in a position.
            if (board[_place] !=0) {
                return "the position you played is already occupied.";
            }
            board[_place] = start + 1;
            start = 1;
            return "Move played successfully.";
        }
    }

    function checkWinner() public view returns (uint) {
        for(uint i=0;i<8; i++) {
            uint[] memory b = tests[i];
            if (board[b[0]] != 0 && board[b[0]] == board[b[1]] && board[b[0]] == board[b[2]]) {
                return board[b[0]];
            }
        }
        return 0;
    }

    function currentBoard() public view returns(string,string) {
        string memory text = "There is no winner yet!";
        uint winner = checkWinner();
        if (winner == 1) {
            text = "Player 1 (x) has won the game!";
        }
        if (winner == 2) {
            text = "Player 2 (o) has won the game!";
        }

    bytes memory out = new bytes(11);
    byte[] memory characters = new byte[](3);
    characters[0] = "-";
    characters[1] = "X";
    characters[2] = "O";
    bytes(out)[3] = "|";
    bytes(out)[7] = "|";
    for (uint i=0; i<9; i++) {
        bytes(out)[i+i/3] = characters[board[i]];
    }
    return (text, string(out));
        
    }


}
