# Name:  Grace Pettigrew

# This file is provided to you as a starting point for the "English Test" program of Assignment 1
# of Programming Principles in Semester 2, 2023.  


# Import the random module to allow us to select words and questions at random.
import random

#Import the inputInt function
from english_test_additions import inputInt


# This function receives a word as a parameter and should return the number of vowels in the word.
# See the assignment brief for details of this function's requirements.
def countVowels(word):
    vowels = 'AEIOUaeiou'
    return sum(1 for char in word if char in vowels)


# Print the welcome message to the program
print('Welcome to the English Tester Pro!')

# A list of words to choose from for the test.
candidateWords = ['HELLO', 'GOODBYE', 'NAME', 'DAY', 'NIGHT', 'HOUR', 'POTATO', 'BIG', 'SMALL', 'GOOD', 'BAD', 'YES', 'NO', 'HOUSE', 'QUESTION', 'BALLOON', 'CAT', 'DUCK', 'PIGEON', 'POSTER', 'TELEVISION', 'SPY', 'RIPPLE', 'SUBSTANTIAL', 'SNOW', 'MAGNET', 'TOWEL', 'WALKING', 'SPEAKER', 'UNCHARACTERISTICALLY']

#Create a loop so you can play the game as many times as you want
while True:
    
    #Initialize the other variables
    numWords = 0
    wordList = []
    score = 0

    #Loop to get a valid number of words to continue the program 
    while numWords <1 or numWords > len(candidateWords):
        numWords = inputInt('How many words would you like the test to contain? ')
        if numWords <1 or numWords > len(candidateWords):
            print('Invalid input. Please enter a valid number of words between 1 and', len(candidateWords))

    #Create a list of randomly chosen words
    wordList = random.sample(candidateWords, numWords)

    #Define the question types
    questionTypes = [1, 2, 3, 4]

    #shuffle so that each question are asked once but still randomly
    random.shuffle(questionTypes)

    # Loop through each word in the wordList
    for i, word in enumerate(wordList, start=1):

        questionChoice = questionTypes[(i - 1) % 4]  # Cycle through question types

        print(f"Word {i}/{numWords}: {word}")  # Print current word and number

        if questionChoice == 1:
            userAnswer = inputInt("How many letters does the word contain? ")
            if userAnswer == len(word):
                print("Correct!")
                score += 1
            else:
                print("Incorrect!")
    
        elif questionChoice == 2:
            userAnswer = inputInt("How many vowels does the word contain? ")
            if userAnswer == countVowels(word):
                print("Correct!")
                score += 1
            else:
                print("Incorrect!")

        elif questionChoice == 3:
            userAnswer = inputInt("How many consonants does the word contain? ")
            if userAnswer == len(word) - countVowels(word):
                print("Correct!")
                score += 1
            else:
                print("Incorrect!")

        elif questionChoice == 4:
            randomPosition = random.randint(1, len(word))
            userAnswer = input(f"What is the {randomPosition}{'st' if randomPosition == 1 else 'nd' if randomPosition == 2 else 'rd' if randomPosition == 3 else 'th'} letter of the word? Please note your answer should be in uppercase ")
            if userAnswer == word[randomPosition - 1]:
                print("Correct!")
                score += 1
            else:
                print("Incorrect!")


    # Print the final score
    print(f"Game Over. Your score: {score} out of {numWords}")

    #Ask if they want to play the game again
    play_again = input('Do you want to play again?(y/n)')
    if play_again != 'y':
        print('Thanks for playing! Goodbye!')
        break
    
