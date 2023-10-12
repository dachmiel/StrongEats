import tkinter as tk
from tkinter import messagebox
import sqlite3


#creates database and cursor
conn = sqlite3.connect('login_info.db')
c = conn.cursor()

# create table, current database is stored with a local file
# If you don't have this file already, uncomment this block to create it
'''c.execute("""CREATE TABLE users (
        username text,
        password text
        )
""")'''


# List of exercise options with corresponding calorie burn rates (per minute)
exercise_options = {
    "Running": 10,
    "Cycling": 8,
    "Swimming": 12,
    "Weightlifting": 5,
    "Yoga": 4,
    "Other": 6
}

#create login function for database
def login():
    conn2 = sqlite3.connect('login_info.db')
    c2 = conn2.cursor()

    c2.execute("SELECT * FROM users")
    allUsers = c2.fetchall()
    username = entry_username.get()
    password = entry_password.get()
    if (username, password) in allUsers:
        messagebox.showinfo("Login Successful", "Login Successful")
        # Close the login window
        root.destroy()
        # Open the workout tracking page
        open_home_page()
    else:
        messagebox.showerror("Login Failed", "Invalid username or password")

    conn2.commit()
    conn2.close()
    return


#create account function for database
def createAccount():
    conn2 = sqlite3.connect('login_info.db')
    c2 = conn2.cursor()

    # Insert into table
    c2.execute("SELECT username FROM users")
    allUsernames = c2.fetchall()
    username = entry_username.get()
    password = entry_password.get()
    if username == "" or password == "":
        messagebox.showerror("Cannot Create Account", "Invalid username or password")
    elif (username,) in allUsernames:
        messagebox.showerror("Cannot Create Account", "This username is already in use")
    else:
        c2.execute("INSERT INTO users VALUES (:username, :password)", 
                {
                    'username': username,
                    'password': password})
        messagebox.showinfo("Account Creation Successful", "Account Creation Successful")
        # Close the login window
        root.destroy()
        # Open the workout tracking page
        open_home_page()

    conn2.commit()
    conn2.close()
    return

def open_home_page():
    home_window = tk.Tk()
    home_window.title("Strong Eats")
    home_window.geometry("360x650")

    # Create a label for the home page title
    title_label = tk.Label(home_window, text="Welcome to Strong Eats", font=("Helvetica", 20, "bold"))
    title_label.pack(pady=20)

    # Create buttons for various actions
    start_workout_button = tk.Button(home_window, text="Start Workout", command=open_workout_page, font=("Helvetica", 16), bg="#007AFF", fg="black", relief="flat", padx=20, pady=10)
    start_workout_button.pack(pady=10)

    add_meal_button = tk.Button(home_window, text="Add Meal", command=add_meal, font=("Helvetica", 16), bg="#007AFF", fg="black", relief="flat", padx=20, pady=10)
    add_meal_button.pack(pady=10)

    update_past_workout_button = tk.Button(home_window, text="Update Past Workout", command=update_past_workout, font=("Helvetica", 16), bg="#007AFF", fg="black", relief="flat", padx=20, pady=10)
    update_past_workout_button.pack(pady=10)

    update_profile_info_button = tk.Button(home_window, text="Update Profile Information", command=update_profile_info, font=("Helvetica", 16), bg="#007AFF", fg="black", relief="flat", padx=20, pady=10)
    update_profile_info_button.pack(pady=10)


# Function to open the meal entry screen
def add_meal():
    meal_window = tk.Tk()
    meal_window.title("Meal Tracker")
    meal_window.geometry("360x650")

    # Create labels and widgets for the meal entry screen here
    label_meal = tk.Label(meal_window, text="Welcome to Meal Tracker", font=("Helvetica", 20, "bold"))
    label_meal.pack(pady=20)

    # Add meal-related widgets here (e.g., food selection, calories, etc.)

# Function to open the past workout update screen
def update_past_workout():
    past_workout_window = tk.Tk()
    past_workout_window.title("Update Past Workout")
    past_workout_window.geometry("360x650")

    # Create labels and widgets for updating past workouts here
    label_past_workout = tk.Label(past_workout_window, text="Update Past Workout", font=("Helvetica", 20, "bold"))
    label_past_workout.pack(pady=20)

    # Add widgets to update past workouts here (e.g., select date, exercises, etc.)

# Function to open the profile information update screen
def update_profile_info():
    profile_window = tk.Tk()
    profile_window.title("Update Profile Information")
    profile_window.geometry("360x650")

    # Create labels and widgets for updating profile information here
    label_profile = tk.Label(profile_window, text="Update Profile Information", font=("Helvetica", 20, "bold"))
    label_profile.pack(pady=20)



# Function to open the workout tracking page
def open_workout_page():
    workout_window = tk.Tk()
    workout_window.title("Workout Tracking")
    workout_window.geometry("360x650")

    # Add workout tracking content here
    label_workout = tk.Label(workout_window, text="Workout Tracking", font=("Helvetica", 16))
    label_workout.pack(pady=20)

    # Dropdown menu for exercise selection
    label_exercise = tk.Label(workout_window, text="Exercise:", font=("Helvetica", 12))
    label_exercise.pack(pady=10)
    exercise_var = tk.StringVar()
    exercise_dropdown = tk.OptionMenu(workout_window, exercise_var, *exercise_options.keys())
    exercise_dropdown.config(font=("Helvetica", 12))
    exercise_dropdown.pack(pady=5)
    exercise_var.set(list(exercise_options.keys())[0])  # Set the default option

    label_duration = tk.Label(workout_window, text="Duration (min):", font=("Helvetica", 12))
    label_duration.pack(pady=10)
    entry_duration = tk.Entry(workout_window, font=("Helvetica", 12))
    entry_duration.pack(pady=5)

    label_calories = tk.Label(workout_window, text="Calories Burned:", font=("Helvetica", 12))
    label_calories.pack(pady=10)
    calories_var = tk.StringVar()
    label_calories_value = tk.Label(workout_window, textvariable=calories_var, font=("Helvetica", 12))
    label_calories_value.pack(pady=5)

    # Function to calculate calories based on exercise and duration
    def calculate_calories():
        exercise = exercise_var.get()
        duration = entry_duration.get()
        try:
            duration = float(duration)
            if exercise in exercise_options:
                calorie_burn_rate = exercise_options[exercise]
                calories_burned = duration * calorie_burn_rate
                calories_var.set(f"{calories_burned:.2f} calories")
            else:
                calories_var.set("Unknown Exercise")
        except ValueError:
            calories_var.set("Invalid Duration")

    # Button to calculate calories
    calculate_button = tk.Button(workout_window, text="Calculate Calories", command=calculate_calories, font=("Helvetica", 14), bg="#007AFF", fg="black", relief="flat", padx=20, pady=10)
    calculate_button.pack(pady=20)

    workout_window.mainloop()

# Create the main login window
root = tk.Tk()
root.title("iPhone Login Screen")
root.geometry("360x650")
root.configure(bg="#F0F0F0")

# Create labels and entries for username and password
label_username = tk.Label(root, text="Username:", font=("Helvetica", 14))
label_username.pack(pady=10)
entry_username = tk.Entry(root, font=("Helvetica", 14))
entry_username.pack(pady=5)

label_password = tk.Label(root, text="Password:", font=("Helvetica", 14))
label_password.pack(pady=10)
entry_password = tk.Entry(root, show="*", font=("Helvetica", 14))
entry_password.pack(pady=5)

# Create a login button with iPhone-style appearance
login_button = tk.Button(root, text="Login", command=login, font=("Helvetica", 16), bg="#007AFF", fg="black", relief="flat", padx=20, pady=10)
login_button.pack(pady=20)

# Create account button with iPhone-style appearance
create_button = tk.Button(root, text="Create Account", command=createAccount, font=("Helvetica", 16), bg="#007AFF", fg="black", relief="flat", padx=20, pady=10)
create_button.pack()

# Start the Tkinter main loop
root.mainloop()
