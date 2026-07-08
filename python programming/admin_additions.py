import json
import math

# Initialize data as an empty list
data = []

# Function to load data from file or initialize an empty list
def load_Data():
    try:
        with open("data.txt", "r") as file:
            data = json.load(file)
    except (FileNotFoundError, json.JSONDecodeError):
        data = []
    return data

# Function to save data to file
def saveData(data):
    with open("data.txt", "w") as file:
        json.dump(data, file)

# Initialize data at the start of the program
data = load_Data()

#input functions 
def inputInt(prompt):
     while True:
        user_input = input(prompt)
        try:
            value = int(user_input)
            return value
        except ValueError:
            print("Invalid input. Please enter a valid integer.")

def inputFloat(prompt):
    while True:
        user_input = input(prompt)
        try:
            value = float(user_input)
            return value
        except ValueError:
            print("Invalid input. Please enter a valid number.")

def inputSomething(prompt):
      while True:
        user_input = input(prompt).strip()
        if user_input:
            return user_input
        else:
            print("Input cannot be empty. Try again.")


# Print welcome message and enter the main loop
print('Welcome to the Fruit Test Admin Program.')

while True:
    print('\nChoose [a]dd, [l]ist, [s]earch, [v]iew, [d]elete, [o]verview or [q]uit.')
    choice = input('> ').lower()

    if choice == ('a'):
        # Add fruit to the data list variable
        name = inputSomething("Enter the name of the fruit: ").lower()
        if any(fruit['name'].lower() == name for fruit in data): #check if fruit already exists within list
            print("Fruit already exists.")
        else:
            calories = inputFloat("Enter the calories (per 100 grams): ")
            fibre = inputFloat("Enter the fibre (per 100 grams): ")
            sugar = inputFloat("Enter the sugar (per 100 grams): ")
            vitamin_c = inputFloat("Enter the vitamin C (per 100 grams): ")

            kilojoules = math.ceil(calories * 4.184) #converting the calories to kilojoules
            #create the dictionary of the new fruit
            fruit = {
                "name": name,
                "calories": calories,
                "fibre": fibre,
                "sugar": sugar,
                "vitamin C": vitamin_c,
                }
            #Add the fruit dictionary to the data list and save it to a file
            data.append(fruit)
            saveData(data)
            print("Fruit added successfully!")
            
    #List of all the fruits saved
    elif choice == 'l':
        if data:
            print("List of fruits:")
            for i, fruit in enumerate(data, start=1):
                print(f"{i}: {fruit['name']}")
        else:
            print("No fruit saved.")
            
    #Search for fruits based on the names
    elif choice.startswith('s'):
        search_term = choice.split(maxsplit=1)[-1].lower() #splits the search term into words once and takes last part of split word as the search term    
        found = False #keep track of any results found
        if data:
            print("Search results:")
            for i, fruit in enumerate(data, start=1): #use a for loop and the enumerate function to cycle through each fruit index in the dictionary
                if search_term in fruit['name'].lower():
                    print(f"{i}: {fruit['name']}")
                    found = True
            if not found:
                print("No results found.")
        else:
            print("No fruit saved.")
            
    #View the details of the fruits
    elif choice.startswith('v'):
        index = int(choice.split(maxsplit=1) [-1]) -1 #splits the search term so takes v as the start and index number as the second part of what is entered
        if 0 <= index < len(data): #check if the index number is valid
            fruit = data[index] #Display the information of the fruit if index number is valid
            kilojoules = math.ceil(fruit['calories'] * 4.184)
            print(f"Name: {fruit['name']}")
            print(f"Calories (per 100 grams): {fruit['calories']} ({kilojoules} kJ)")
            print(f"Fibre (per 100 grams): {fruit['fibre']}")
            print(f"Sugar (per 100 grams): {fruit['sugar']}")
            print(f"Vitamin C (per 100 grams): {fruit['vitamin C']}")
        else:
            print("Invalid index number.")
  
            
    #Delete a fruit via it's index number        
    elif choice.startswith('d'):
        index = int(choice.split(maxsplit=1)[-1]) - 1 #splits the search term so it takes d and then the index number the user wants to delete
        if 0 <= index < len(data): #checks if index number is valid
            deleted_fruit = data.pop(index - 1) #removes the index number
            saveData(data) #saves the updated data
            print(f"{deleted_fruit['name']} deleted.")
        else:
            print("Invalid index number.")
            
    #overview of fruits nutritional information       
    elif choice == 'o':
        if data:
            num_fruits = len(data)
            min_calories_fruit = min(data, key=lambda x: x['calories']) #calculates min calories
            avg_sugar = sum(fruit['sugar'] for fruit in data) / num_fruits #calculates average sugar of the fruits
            max_vitamin_c_fruit = max(data, key=lambda x: x['vitamin C']) #calculates the fruit with max vit C 
            print(f"Number of fruits: {num_fruits}")
            print(f"Name of fruit with least calories: {min_calories_fruit['name']} ({min_calories_fruit['calories']} calories)")
            print(f"Average sugar content: {avg_sugar} grams")
            print(f"Name of fruit with most Vitamin C: {max_vitamin_c_fruit['name']} ({max_vitamin_c_fruit['vitamin C']} mg)")
        else:
            print("No fruit saved.")
            
    #Quit the program
    elif choice == 'q':
        print("Goodbye!")
        break #Break out of endless loop
    else:
        print("Invalid choice. Please try again.")
