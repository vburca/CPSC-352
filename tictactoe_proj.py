""" 
Author: Vlad Burca
		Nicolae Dragu
Date: 12/15/2011
File: tictactoe_proj.py
Name: TicTacToe using MiniMax Algorithm
"""

import random
import time


class MinMax(object):
    
    def __init__(self, maxdepth):
        """ Initializes the MinMax algorithm with a dummy move 
            and the maximum depth of the look-ahead tree. """
        
        self.bestmove = -1
        self.maxdepth = maxdepth

    def buildtree_(self, board, curr_player, depth):
        """ Builds the look-ahead (min-max) tree. """

        if depth > self.maxdepth:
            return 0
    
        # assigns the other player
        other_player = TicTacToe_Board.O if curr_player == TicTacToe_Board.X else TicTacToe_Board.X
        
        winner = board.check_winner()
       
        # check if we have a winner  
        if winner == curr_player:
            return 1
        elif winner == other_player:
            return -1
        elif board.check_filled():
            return 0
        
        # generates list of possible moves
        moves_list = board.get_possible_moves()
        
        # sets the initial weight
        weight = -1
        
        subweights = []
        
        # for each possible move, generate the minmax subtrees using the weights
        for i in moves_list:
            board2 = board.duplicate()
            board2.fill_move(curr_player,i)
            subweight = -self.buildtree_(board2, other_player, depth + 1)
            if weight < subweight:
                weight = subweight
            
            if depth == 0:
                subweights.append(subweight)
        
        # start choosing the best possible moves from the available ones
        if depth == 0:
            possible_moves = []
            for i in range(len(subweights)):
                if subweights[i] == weight:
                    possible_moves.append(moves_list[i])
            # pick a random one from the best moves
            rand_move = random.randint(0,len(possible_moves)-1)
            self.bestmove = possible_moves[rand_move]

        return weight        
        
    def buildtree(self, board, player):
        """ Initializes the bestmove with dummy value and calls the buildtree_ . """
        
        self.bestmove = -1
        weight = self.buildtree_(board, player, 0)
        return self.bestmove
        

class TicTacToe_Board(list):
    """ Defines a TicTacToe board. """    

    EMPTY = 0   # mark for empty space on board
    X = 1       # mark for X on board
    O = 2       # mark for O on board
    
    def __init__(self):
        """ Initializes an empty TicTacToe board. """
        for i in range(9):
            self.append(TicTacToe_Board.EMPTY)

    def duplicate(self):
        """ Duplicates the current board. """
        
        board2 = TicTacToe_Board()
        for i in range(9):
            board2[i] = self[i]
        return board2

    def fill_move(self, mark, position):
        """ Fills in the Board with the corresponding mark 
            at the corresponding position. """

        self[position]= mark

    def get_possible_moves(self):
        """ Returns a list of possible moves. """

        pos_moves = []
        for i in range(9):
            if self[i] == TicTacToe_Board.EMPTY:
                pos_moves.append(i)
        return pos_moves

    def check_filled(self):
        """ Check if the board has been filled. """

        for i in range(9):
            if self[i] == TicTacToe_Board.EMPTY:
                return False
        return True

    def check_winner(self):
        """ Checks which player has the winning line. """    
    
        if self[0] != TicTacToe_Board.EMPTY:
            # top horizontal line, left vertical line, first diagonal
            if (
               (self[0] == self[1] and 
                self[1] == self[2]) or
               (self[0] == self[3] and 
                self[3] == self[6]) or
               (self[0] == self[4] and 
                self[4] == self[8])
               ): 
                return self[0]
        if self[1] != TicTacToe_Board.EMPTY:
            # middle horizontal line
            if (self[1] == self[4] and
                self[4] == self[7]):
                return self[1]
        if self[2] != TicTacToe_Board.EMPTY:
            # second diagonal
            if (self[2] == self[4] and
                self[4] == self[6]):
                return self[2]
        if self[3] != TicTacToe_Board.EMPTY:
            # middle vertical line
            if (self[3] == self[4] and
                self[4] == self[5]):
                return self[3]
        if self[8] != TicTacToe_Board.EMPTY:
            # right vertical line, bottom horizontal line
            if (
               (self[8] == self[7] and
                self[7] == self[6]) or
               (self[8] == self[5] and
                self[5] == self[2])
               ):
                return self[8]
        return TicTacToe_Board.EMPTY

    def __str__(self):
        """ Display the TicTacToe board. """

        line = ' '

        for i in range(9):
            if self[i] == TicTacToe_Board.EMPTY:
                line = line + '-' + ' '
            elif self[i] == TicTacToe_Board.X:
                line = line + 'X' + ' '
            elif self[i] ==  TicTacToe_Board.O:
                line = line + 'O' + ' '
            if i in [2,5,8]:
                line = line + '\n '
        
        return line

    def user_print(self):
        """ Display the TicTacToe board along with a help 
            board for the user input. """

        line = ' '
        
        for i in range(9):
            if self[i] == TicTacToe_Board.EMPTY:
                line = line + '-' + ' '
            elif self[i] == TicTacToe_Board.X:
                line = line + 'X' + ' '
            elif self[i] ==  TicTacToe_Board.O:
                line = line + 'O' + ' '
            if i in [2,5,8]:
                line = line + '    |    '
                if i == 2:                                             
                    rrange = [0,1,2]
                elif i == 5:
                    rrange = [3,4,5]
                else:
                    rrange = [6,7,8]
                for j in rrange:
                    if self[j] == TicTacToe_Board.EMPTY:
                        line = line + str(j + 1) + ' '
                    else:
                        line = line + '-' + ' '
            if i in [2,5,8]:
                line = line + '\n '
        print(line)


def comp_vs_comp():
    """ Computer vs Computer module. """
    
    n = raw_input(" Enter the depth level (\"intelligence\"): ")
    print('\n')
    n = int(n)
    
    board = TicTacToe_Board()
    minmax = MinMax(n)

    curr_player = TicTacToe_Board.X

    end = False

    print(" The game has started. \n")
    print(board)

    while not end:
        if board.check_filled():
            end = True
            print(" Tie game. \n")
            continue
        if curr_player == TicTacToe_Board.X:
            print(" Computer 1 is moving. \n")
        else:
            print(" Computer 2 is moving. \n")
        move = minmax.buildtree(board, curr_player)

        if move >= 0:
            board.fill_move(curr_player, move)
            time.sleep(0.75)
            print(board)
            winner = board.check_winner()
            if winner == TicTacToe_Board.X:
                print(" Computer 1 (X) wins! \n")
                end = True
            elif winner == TicTacToe_Board.O:
                print(" Computer 2 (O) wins! \n")
                end = True
        
        if curr_player == TicTacToe_Board.X:
            curr_player = TicTacToe_Board.O
        else:
            curr_player = TicTacToe_Board.X
            
def human_vs_comp():
    print(" Set difficulty level. \n" \
                  " 1 - Beginner \n" \
                  " 2 - Easy \n" \
                  " 3 - Moderate \n" \
                  " 4 - Hard \n" \
                  " 5 - Harder \n" \
                  " 6 - Impossible \n")
    n = raw_input(" Your selection: ")
    print('\n')
    n = int(n)
    board = TicTacToe_Board()
    minmax = MinMax(n)
    
    option = raw_input(" 1 - Human starts first \n" \
                       " 2 - Computer starts first \n" \
                       " Your Option: ")
    while option != '1' and option != '2':
        option = raw_input(" 1 - Human starts first \n" \
                           " 2 - Computer starts first \n" \
                           " Your Option: ")
    print('\n')
    if option == '1':
        curr_player = TicTacToe_Board.X
    else:
        curr_player = TicTacToe_Board.O

    end = False

    print(" The game has started. \n")
    if curr_player == TicTacToe_Board.X:
        board.user_print()
    else:
        print(board)

    while not end:
        if board.check_filled():
            end = True
            print("Tie game!\n")
            continue

        if curr_player == TicTacToe_Board.X:
            incorrect_input = True
            while incorrect_input:
                move = input(" Your move: ")
                print('\n')
                move = move - 1
                if move >= 0 and move <= 8 and board[move] == TicTacToe_Board.EMPTY:
                    incorrect_input = False
        else:
            print(" Computer is moving. \n")
            move = minmax.buildtree(board, curr_player)
            time.sleep(0.75)
        
        if move >= 0:
            board.fill_move(curr_player,move)
            if curr_player == TicTacToe_Board.O:
                board.user_print()
            else:
                print(board)
        
        winner = board.check_winner() 
        if winner == TicTacToe_Board.X:
            print(" Human (X) wins! \n")
            end = True
        elif winner == TicTacToe_Board.O:
            print(" Computer (O) wins! \n")
            end = True
    
        if curr_player == TicTacToe_Board.X:
            curr_player = TicTacToe_Board.O
        else:
            curr_player = TicTacToe_Board.X



option = raw_input(" 1 - Computer vs Computer \n" \
                   " 2 - Human vs Computer \n" \
                   " 3 - Exit \n" \
                   " Your Option: ")
while option != '1' and option != '2' and option != '3':
    option = raw_input(" 1 - Computer vs Computer \n" \
                       " 2 - Human vs Computer \n" \
                       " 3 - Exit \n" \
                       " Your Option: ")

print('\n')

if option == '1':
    comp_vs_comp()
elif option == '2':
    human_vs_comp()
elif option == '3':
    print(" Goodbye!\n")















              
            





















        
