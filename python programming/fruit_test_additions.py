# Name:  Grace Pettigrew

# Import the required modules.
import tkinter as tk
from tkinter import messagebox
import json
import random
import threading
import time

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
        self.root.minsize(400, 250)  # Set minimum window size

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
        self.components = ["calories", "fibre", "sugar", "vitamin C"]

        #Create the widgets
        
        self.question_label = tk.Label(self.root, text="", font=("Arial", 14))  # Larger font
        self.question_label.pack(pady=20)

        self.true_button = tk.Button(self.root, text="True", command=lambda: self.checkAnswer(True))
        self.true_button.pack(pady=10, padx=20)  # Added padding and spacing

        self.false_button = tk.Button(self.root, text="False", command=lambda: self.checkAnswer(False))
        self.false_button.pack(pady=10, padx=20)  # Added padding and spacing

        # Added labels to display the score
        self.score_label = tk.Label(self.root, text="Score: 0", font=("Arial", 12))  # Larger font
        self.score_label.pack(pady=10)

        self.timer_label = tk.Label(self.root, text="", font=("Arial", 12))
        self.timer_label.pack(pady=10)

        # Add a variable to store the countdown time
        self.countdown_time = 6
        self.start_running = False
        
        self.root.protocol("WM_DELETE_WINDOW", self.handleClose)

        self.current_fruits = []
        self.current_component = None
        self.questions_asked = 0 #This will track the number of questions asked
        self.correct_answers = 0 #This will track the number of correct answers
        self.timer_running = False #Added the timer running attribute
        self.timer_id = None  #to keep track of the timer

        self.showQuestion()

        #Start the main loop
        self.root.mainloop()



    def showQuestion(self):
        # This method randomly selects two fruit and a nutritional component and displays them as a True/False question.
        # See Point 1 of the "Methods in the GUI class of fruit_test.py" section of the assignment brief.
        if not self.timer_running:
            # Start the timer only if it's not running already
            self.start_timer()
            self.timer_running = True
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

        #restart the timer and start it for each new question
        self.reset_timer()
        self.start_timer()
        
        #Increment questions asked counter
        self.questions_asked += 1

    def checkAnswer(self, answer):
        if self.timer_running:
            self.timer_label.config(text="")  # Clear the timer label when answering
        if self.timer_id is not None:
            self.root.after_cancel(self.timer_id)  # Cancel the timer
            self.timer_id = None

    
        fruit1_value = self.current_fruits[0].get(self.current_component, 0)
        fruit2_value = self.current_fruits[1].get(self.current_component, 0)

        is_true = fruit1_value > fruit2_value

        if answer == is_true:
            result = "Correct!"
            comparison = f"{self.current_fruits[0]['name']} has {fruit1_value} grams {self.get_component_name()}, while {self.current_fruits[1]['name']} has {fruit2_value} grams {self.get_component_name()}."
            self.correct_answers += 1
        else:
            result = "Incorrect!"
            comparison = f"{self.current_fruits[0]['name']} has {fruit1_value} grams {self.get_component_name()}, while {self.current_fruits[1]['name']} has {fruit2_value} grams {self.get_component_name()}."

        messagebox.showinfo("Result", f"{result}\n{comparison}")

        self.update_score()

        self.root.after(2000, self.showQuestion)

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

    def start_timer(self):
        if self.countdown_time > 0:
            self.timer_label.config(text=f"Time left: {self.countdown_time} seconds")
            self.countdown_time -= 1
            self.root.after(1000, self.start_timer)
        elif not self.timer_running:
            self.timer_label.config(text="Time's up!")
            self.timer_running = True #Set the timer running to true 
            messagebox.showinfo("Time's Up!", "Time's up! Click OK to continue.") #show the time's up message in a box
            self.timer_id = None #reset the timer ID
            self.showQuestion() #move onto the next question 

    def reset_timer(self):
        # Reset the timer
        self.countdown_time = 6
        self.timer_running = False

            
    def update_score(self):
        self.score_label.config(text= f"Score: {self.correct_answers}/{self.questions_asked}")

        
# Create an object of the ProgramGUI class to begin the program.
if __name__ == "__main__":
    gui = ProgramGUI()


