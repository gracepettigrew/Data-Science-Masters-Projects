import json
import math

# Initialize data as an empty list
data = []

# Function to load data from file or initialize an empty list
def load_data():
    try:
        with open("data.txt", "r") as file:
            data = json.load(file)
    except (FileNotFoundError, json.JSONDecodeError):
        data = []
    return data

# Function to save data to file
def save_data(data):
    with open("data.txt", "w") as file:
        json.dump(data, file)

# Initialize data at the start of the program
data = load_data()

#input functions from admin
from admin import inputSomething
from admin import inputFloat
from admin import inputInt


# Print welcome message and enter the main loop
print('Welcome to the Fruit Test Admin Program.')

while True:
    print('\nChoose [a]dd, [l]ist, [s]earch, [v]iew, [d]elete, [o]verview or [q]uit.')
    choice = input('> ').lower()

    if choice == 'a':
        # Add fruit (with name check)
        new_fruit_name = inputSomething("Enter the name of the fruit: ").lower()
        if any(fruit['name'].lower() == new_fruit_name for fruit in data):
            print("Fruit already exists.")
        else:
            calories = inputFloat("Enter the calories (per 100 grams): ")
            fiber = inputFloat("Enter the fiber (per 100 grams): ")
            sugar = inputFloat("Enter the sugar (per 100 grams): ")
            vitamin_c = inputFloat("Enter the vitamin C (per 100 grams): ")

            kilojoules = math.ceil(calories * 4.184)
            
            fruit = {
                "name": new_fruit_name,
                "calories": calories,
                "fiber": fiber,
                "sugar": sugar,
                "vitamin C": vitamin_c,
                }
            
            data.append(fruit)
            saveData(data)
            print("Fruit added successfully!")

    elif choice == 'l':
        # List fruits
        if data:
            print("List of fruits:")
            for i, fruit in enumerate(data, start=1):
                print(f"{i}: {fruit['name']}")
        else:
            print("No fruit saved.")

    elif choice.startswith('s'):
        # Search for a fruit
        search_term = choice.split(maxsplit=1)[-1].lower()
        found = False
        if data:
            print("Search results:")
            for i, fruit in enumerate(data, start=1):
                if search_term in fruit['name'].lower():
                    print(f"{i}: {fruit['name']}")
                    found = True
            if not found:
                print("No results found.")
        else:
            print("No fruit saved.")

    elif choice.startswith('v'):
        # View details of a fruit
        index = int(choice.split(maxsplit=1)[-1]) - 1
        if 0 <= index < len(data):
            fruit = data[index]
            kilojoules = math.ceil(fruit['calories'] * 4.184)
            print(f"Name: {fruit['name']}")
            print(f"Calories (per 100 grams): {fruit['calories']} ({kilojoules} kJ)")
            print(f"Fiber (per 100 grams): {fruit['fiber']}")
            print(f"Sugar (per 100 grams): {fruit['sugar']}")
            print(f"Vitamin C (per 100 grams): {fruit['vitamin C']}")
        else:
            print("Invalid index number.")
    elif choice.startswith('d'):
        # Delete a fruit
        index = int(choice.split(maxsplit=1)[-1]) - 1
        if 0 <= index < len(data):
            deleted_fruit = data.pop(index)
            save_data(data)
            print(f"{deleted_fruit['name']} deleted.")
        else:
            print("Invalid index number.")
            

    elif choice == 'o':
        # Overview
        if data:
            num_fruits = len(data)
            min_calories_fruit = min(data, key=lambda x: x['calories'])
            avg_sugar = sum(fruit['sugar'] for fruit in data) / num_fruits
            max_vitamin_c_fruit = max(data, key=lambda x: x['vitamin C'])
            print(f"Number of fruits: {num_fruits}")
            print(f"Name of fruit with least calories: {min_calories_fruit['name']} ({min_calories_fruit['calories']} calories)")
            print(f"Average sugar content: {avg_sugar} grams")
            print(f"Name of fruit with most Vitamin C: {max_vitamin_c_fruit['name']} ({max_vitamin_c_fruit['vitamin C']} mg)")
        else:
            print("No fruit saved.")
    elif choice == 'q':
        print("Goodbye!")
        break
    else:
        print("Invalid choice. Please try again.")
