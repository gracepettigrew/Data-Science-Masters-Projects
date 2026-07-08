# Name:  Grace Pettigrew
# Student Number:  10635748

# This file is provided to you as a starting point for the "fruit_test.py" program of Project
# of Programming Principles in Semester 2, 2023.  It aims to give you just enough code to help ensure
# that your program is well structured.  Please use this file as the basis for your assignment work.
# You are not required to reference it.


# The "pass" command tells Python to do nothing.  It is simply a placeholder to ensure that the starter files run smoothly.
# They are not needed in your completed program.  Replace them with your own code as you complete the assignment.

# Import the required modules.
import tkinter as tk
from tkinter import messagebox
import json
import random

class ProgramGUI:

    def __init__(self):
        # This is the constructor of the class.
        # It is responsible for loading and reading the data from the text file and creating the user interface.
        # See the "Constructor of the GUI Class of fruit_test.py" section of the assignment brief.  
        # Create the main window
        self.root = tk.Tk()
        if not self.root:
            messagebox.showerror("Error", "Failed to create the main window")
            return
        self.root.title("Fruit Test")
        self.root.minsize(300, 200)  # Set minimum window size

        try:
            # Try to open and load the JSON data from "data.txt"
            with open("data.txt", "r") as file:
                self.data = json.load(file)
        except (FileNotFoundError, json.JSONDecodeError):
            # Handle file not found or invalid JSON data
            messagebox.showerror("Error", "Missing/Invalid file")
            self.root.destroy()
            return

        # Check if self.data contains fewer than two items
        if len(self.data) < 2:
            messagebox.showerror("Error", "Not enough fruit")
            self.root.destroy()
            return

        # Create a list of nutritional components
        self.components = ["calories", "fibre", "sugar", "vitamin_c"]

        #Create the widgets

        self.question_label = tk.Label(self.root)
        self.question_label.pack(pady=20)

        self.true_button = tk.Button(self.root, text="True", command=lambda: self.checkAnswer(True))
        self.true_button.pack(pady=10)

        self.false_button = tk.Button(self.root, text = "False", command=lambda: self.checkAnswer(False))
        self.false_button.pack(pady=10)

        self.root.protocol("WM_DELETE_WINDOW", self.handleClose)

        self.current_fruits = []
        self.current_component = None
        #Display the first question
        self.showQuestion()

        #Start the main loop
        self.root.mainloop()



    def showQuestion(self):
        # This method randomly selects two fruit and a nutritional component and displays them as a True/False question.
        # See Point 1 of the "Methods in the GUI class of fruit_test.py" section of the assignment brief.
  
        # Randomly select two different fruits and a nutritional component
        self.current_fruits = random.sample(self.data, 2)
        self.current_component = random.choice(self.components)

        # Pluralize the fruit names based on the component
        fruit1_name = self.pluralize(self.current_fruits[0]['name'], 100)
        fruit2_name = self.pluralize(self.current_fruits[1]['name'], 100)

        # Format the question text
        question_text = f"100 grams of {fruit1_name} contains more {self.get_component_name()} than 100 grams of {fruit2_name}."

        # Update the question label
        self.question_label.config(text=question_text)
        
        

    def checkAnswer(self, answer):
        # This method determines whether the user clicked the correct button and shows a Correct/Incorrect messagebox.
        # See Point 2 of the "Methods in the GUI class of fruit_test.py" section of the assignment brief.

        #Determine if the answer is correct
        fruit1_value = self.current_fruits[0].get(self.current_component, 0)
        fruit2_value = self.current_fruits[1].get(self.current_component, 0)

        #compare the values to determine if the question is true
        is_true = fruit1_value > fruit2_value

        #Logic for checking the answer
        if answer:
            result = "Correct!"
        else:
            result = "Incorrect!"

        messagebox.showinfo("Result", result)
        self.showQuestion()


    def handleClose(self):
        #Handle window close
        if messagebox.askokcancel("Quit", "Do you want to quit?"):
            self.root.destroy()

    def get_component_name(self):
        if self.current_component == "vitamin_c":
            return "Vitamin C"
        else:
            return self.current_component
        
    def pluralize(self, word, count):
        if count == 1:
            return word
        else:
            return word + 's'


# Create an object of the ProgramGUI class to begin the program.
if __name__ == "__main__":
    gui = ProgramGUI()

