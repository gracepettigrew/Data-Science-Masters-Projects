# Name:  Grace Pettigrew
# Student Number:  10635748

# This file is provided to you as a starting point for the "admin.py" program of Project
# of Programming Principles in Semester 2, 2023.  It aims to give you just enough code to help ensure
# that your program is well structured.  Please use this file as the basis for your assignment work.
# You are not required to reference it.


# The "pass" command tells Python to "do nothing".  It is simply a placeholder to ensure that the starter files run smoothly.
# They are not needed in your completed program.  Replace them with your own code as you complete the assignment.


# Import the json module to allow us to read and write data in JSON format.
import json
#initialise data as an empty list
data = []


# This function repeatedly prompts for input until an integer is entered.
# See Point 1 of the "Functions in admin.py" section of the assignment brief.
def inputInt(prompt):
     while True:
        user_input = input(prompt)
        try:
            value = int(user_input)
            return value
        except ValueError:
            print("Invalid input. Please enter a valid integer.")




# This function repeatedly prompts for input until a float is entered.
# See Point 2 of the "Functions in admin.py" section of the assignment brief.
def inputFloat(prompt):
    while True:
        user_input = input(prompt)
        try:
            value = float(user_input)
            return value
        except ValueError:
            print("Invalid input. Please enter a valid number.")



# This function repeatedly prompts for input until something other than whitespace is entered.
# See Point 3 of the "Functions in admin.py" section of the assignment brief.
def inputSomething(prompt):
      while True:
        user_input = input(prompt).strip()
        if user_input:
            return user_input
        else:
            print("Input cannot be empty. Try again.")




# This function opens "data.txt" in write mode and writes the data to it in JSON format.
# See Point 4 of the "Functions in admin.py" section of the assignment brief.
def saveData(dataList):
    with open("data.txt", "w") as file:
        json.dump(data, file)





# Here is where you attempt to open data.txt and read the data into a "data" variable.
# If the file does not exist or does not contain JSON data, set "data" to an empty list instead.
# This is the only time that the program should need to read anything from the file.
# See Point 1 of the "Requirements of admin.py" section of the assignment brief.

# Function to load data from file or initialize an empty list
def load_data():
    try:
        with open("data.txt", "r") as file:
            data = json.load(file)
    except (FileNotFoundError, json.JSONDecodeError):
        data = []
    return data



# Print welcome message, then enter the endless loop which prompts the user for a choice.
# See Point 2 of the "Details of admin.py" section of the assignment brief.
# The rest is up to you.
print('Welcome to the Fruit Test Admin Program.')

while True:
    print('\nChoose [a]dd, [l]ist, [s]earch, [v]iew, [d]elete, or [q]uit.')
    choice = input('> ').lower()
    #Adding fruit to the data list variable
    if choice == 'a':
        print("Adding a new fruit:")
        name = inputSomething("Enter the name of the fruit: ")
        calories = inputFloat("Enter the calories (per 100 grams): ")
        fibre = inputFloat("Enter the fibre (per 100 grams): ")
        sugar = inputFloat("Enter the sugar (per 100 grams): ")
        vitamin_c = inputFloat("Enter the vitamin C (per 100 grams): ")
        #Creates the dictionary of the new fruit    
        fruit = {
            "name": name,
            "calories": calories,
            "fibre": fibre,
            "sugar": sugar,
            "vitamin C": vitamin_c,
            }
        #Add the new fruit dictionary to the data list and save it to a file    
        data.append(fruit)
        saveData(data)
        print("Fruit added successfully!")


    #List of all the saved the fruits
    elif choice == 'l':
        if data:
                print("List of fruits:")
                for i, fruit in enumerate(data, start=1): #use a for loop and the enumerate function to cycle through each fruit index in the dictionary
                    print(f"{i}: {fruit['name']}")
        else:
                print("No fruit saved.")


     #Search for the fruits based on their names
    elif choice == 's':
        if data:
                search_term = inputSomething("Enter a search term: ").lower() #Ask for a search term
                found = False #Track if any matches are found
                print("Search results:")
                for i, fruit in enumerate(data, start=1):
                    if search_term in fruit['name'].lower(): #Check if the search term is in the fruit name and make is case insensitive
                        print(f"{i}: {fruit['name']}")
                        found = True
                if not found:
                    print("No matching fruit found.")
        else:
                print("No fruit saved.")

     #View details of the fruit by its index number   
    elif choice == 'v':
        if data:
                index = inputInt("Enter the index number: ") #Ask the user for a specific index numner
                if 1 <= index <= len(data): #Check if the index number is valid
                    fruit = data[index - 1] #Display the information of the fruit if the index number is valid
                    print(f"Name: {fruit['name']}")
                    print(f"Calories (per 100 grams): {fruit['calories']}")
                    print(f"Fibre (per 100 grams): {fruit['fibre']}")
                    print(f"Sugar (per 100 grams): {fruit['sugar']}")
                    print(f"Vitamin C (per 100 grams): {fruit['vitamin C']}")
                else:
                    print("Invalid index number.")
        else:
                print("No fruit saved.")
                
     #Delete a fruit via it's index number
    elif choice == 'd':
        if data:
            index = inputInt("Enter the index number to delete: ") 
            if 1 <= index <= len(data): #Checks if index number is valid
                deleted_fruit = data.pop(index - 1) #removes the valid index number
                saveData(data) #saves the updated data 
                print(f"{deleted_fruit['name']} deleted.")
            else:
                print("Invalid index number.")
        else:
            print("No fruit saved.")

      
     #Quit the program
    elif choice == 'q':
        print("Goodbye!")
        break #break out of the endless loop
        

    else:
        print("Invalid choice. Please try again.")
