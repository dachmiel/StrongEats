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
'''c.execute("""CREATE TABLE exercises (
          name text,
          type text,
          muscles text)""")'''
'''c.execute("""CREATE TABLE workoutHistory (
          user text,
          date text,
          workout text)""")'''

# Initializing a variable to store username globally - used to reference user data in databases
globalUser = ""

# List of exercise options with corresponding calorie burn rates (per minute)
exercise_options = {
    "Running": 10,
    "Cycling": 8,
    "Swimming": 12,
    "Weightlifting": 5,
    "Yoga": 4,
    "Other": 6
}

exp_vars = {
    "Beginner": 10,
    "Intermediate" : 10,
    "Advanced": 10
    }

days_nums ={
    "2 Days": 10,
    "3 Days": 8,
    "4 Days": 12,
    "5 Days": 5,
    "6 Days": 4

    }

len_vars= {
    "30 mins": 10,
    "45 mins": 8,
    "1 hour": 12,
    "1.5 hours": 5,
    "2 hours": 4

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
        # Set username variable
        global globalUser
        globalUser = username
        # Close the login window
        root.destroy()
        # Open the workout tracking page
        open_home_page()
        #update_profile_info()
        #update_workout_info()
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
        # Set username variable
        globalUser = username
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

    # Opens database to access workout history
    conn2 = sqlite3.connect('login_info.db')
    c2 = conn2.cursor()

    # Create labels and widgets for updating past workouts here
    label_past_workout = tk.Label(past_workout_window, text="Update Past Workout", font=("Helvetica", 20, "bold"))
    label_past_workout.pack(pady=20)

    # Add widgets to update past workouts here (e.g., select date, exercises, etc.)
    def save_workout():
        workout_to_submit = workout_var.get()
        if workout_to_submit == "Select a workout":
            messagebox.showerror("Error", "Please select a workout from the drop down")
        else:
            conn2 = sqlite3.connect('login_info.db')
            c2 = conn2.cursor()
            c2.execute("INSERT INTO workoutHistory VALUES (:user, :date, :workout)",
                    {
                            'user': globalUser,
                            'date': entry_date.get(),
                            'workout': workout_var.get() + "::" + entry_sets.get() + "::" + entry_reps.get() + "::" + entry_weight.get()
                    })
            conn2.commit()
            conn2.close()

            workout_var.set("Select a workout")
            entry_date.delete(0, 'end')
            entry_sets.delete(0, 'end')
            entry_reps.delete(0, 'end')
            entry_weight.delete(0, 'end')

            messagebox.showinfo("Workout Submitted Successfully", "Workout Submitted Successfully")
    
    label_enter_date = tk.Label(past_workout_window, text = "Enter Date (MM/DD/YYYY):", font=("Helvetica", 12))
    label_enter_date.pack()
    entry_date = tk.Entry(past_workout_window, font=("Helvetica", 12))
    entry_date.pack(pady = 5)
    
    label_select_workout = tk.Label(past_workout_window, text = "Select a workout", font=("Helvetica", 12))
    label_select_workout.pack(pady = 10)

    c2.execute("SELECT name FROM exercises")
    workout_options_raw = c2.fetchall()
    workout_options = []
    for item in workout_options_raw:
        workout_options.append(item[0].strip("\'"))
    workout_var = tk.StringVar(past_workout_window)
    workout_var.set("Select a workout")
    workout_dropdown = tk.OptionMenu(past_workout_window, workout_var, *workout_options)
    workout_dropdown.pack()

    label_sets = tk.Label(past_workout_window, text = "Enter Sets Done", font=("Helvetica", 12))
    label_sets.pack(pady = 10)
    entry_sets = tk.Entry(past_workout_window, font=("Helvetica", 12))
    entry_sets.pack(pady = 5)
    label_reps = tk.Label(past_workout_window, text = "Enter Reps Done", font=("Helvetica", 12))
    label_reps.pack(pady = 10)
    entry_reps = tk.Entry(past_workout_window, font=("Helvetica", 12))
    entry_reps.pack(pady = 5)
    label_weight = tk.Label(past_workout_window, text = "Enter Weight Used", font=("Helvetica", 12))
    label_weight.pack(pady = 10)
    entry_weight = tk.Entry(past_workout_window, font=("Helvetica", 12))
    entry_weight.pack(pady = 5)

    submit_workout_button = tk.Button(past_workout_window, text="Submit", command=save_workout, font=("Helvetica", 16), bg="#007AFF", fg="black", relief="flat", padx=20, pady=10)
    submit_workout_button.pack(pady=10)


# Function to open the profile information update screen
def update_profile_info():
    profile_window = tk.Tk()
    profile_window.title("Update Profile Information")
    profile_window.geometry("360x650")

    # Create labels and widgets for updating profile information here
    label_profile = tk.Label(profile_window, text="Update Profile Information", font=("Helvetica", 20, "bold"))
    label_profile.pack(pady=20)

    #dropdown menus for info
    label_height = tk.Label(profile_window, text="Height:", font=("Helvetica", 12))
    label_height.pack(pady=10)
    exercise_var = tk.StringVar()
    entry_height = tk.Entry(profile_window, font=("Helvetica", 12))
    entry_height.pack(pady=5)


    label_weight = tk.Label(profile_window, text="Weight:", font=("Helvetica", 12))
    label_weight.pack(pady=10)
    entry_weight = tk.Entry(profile_window, font=("Helvetica", 12))
    entry_weight.pack(pady=5)

    label_calories = tk.Label(profile_window, text="Goal Weight:", font=("Helvetica", 12))
    label_calories.pack(pady=10)
    calories_var = tk.StringVar()
    entry_calories_value = tk.Entry(profile_window,font=("Helvetica", 12))
    entry_calories_value.pack(pady=5)


#Need to attach this to database to save profile info 
    save_button = tk.Button(profile_window, text="Save Changes") 
    save_button.pack(pady=10)



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

def update_workout_info():
    workout_window = tk.Tk()
    workout_window.title("Workout Setup")
    workout_window.geometry("360x650")

     # Dropdown menu for exercise selection
    label_exercise = tk.Label(workout_window, text="Experience:", font=("Helvetica", 12))
    label_exercise.pack(pady=10)
    exercise_var = tk.StringVar()
    exercise_dropdown = tk.OptionMenu(workout_window, exercise_var, *exp_vars.keys())
    exercise_dropdown.config(font=("Helvetica", 12))
    exercise_dropdown.pack(pady=5)
    exercise_var.set(list(exp_vars.keys())[0])  # Set the default option

    label_days = tk.Label(workout_window, text="How often do you want to work out:", font=("Helvetica", 12))
    label_days.pack(pady=10)
    days_var = tk.StringVar()
    days_dropdown = tk.OptionMenu(workout_window, days_var, *days_nums.keys())
    days_dropdown.config(font=("Helvetica", 12))
    days_dropdown.pack(pady=5)
    days_var.set(list(days_nums.keys())[0])  # Set the default option

    label_len = tk.Label(workout_window, text="How long do you want to work out for:", font=("Helvetica", 12))
    label_len.pack(pady=10)
    len_var = tk.StringVar()
    len_dropdown = tk.OptionMenu(workout_window, len_var, *len_vars.keys())
    len_dropdown.config(font=("Helvetica", 12))
    len_dropdown.pack(pady=5)
    len_var.set(list(len_vars.keys())[0])  # Set the default option

#Need to attach this to database to save profile info 
    save_button = tk.Button(workout_window, text="Save Changes") 
    save_button.pack(pady=10)


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

'''
    # TEMPORARY
entry_name = tk.Entry(root)
entry_name.pack(pady= 5)
entry_type = tk.Entry(root)
entry_type.pack(pady= 5)
entry_muscles = tk.Entry(root)
entry_muscles.pack(pady= 5)

    
def newLift():
    conn2 = sqlite3.connect('login_info.db')
    c2 = conn2.cursor()
    
    name = entry_name.get()
    type1 = entry_type.get()
    muscles = entry_muscles.get()
    c2.execute("INSERT INTO exercises VALUES (:name, :type, :muscles)", 
                {
                    'name': name,
                    'type': type1,
                    'muscles': muscles
                    })
    c2.execute("SELECT * FROM exercises")
    allEx = c2.fetchall()
    print(allEx)
    entry_name.delete(0, 'end')
    entry_type.delete(0, 'end')
    entry_muscles.delete(0, 'end')
    conn2.commit()
    conn2.close()

def printData():
    conn2 = sqlite3.connect('login_info.db')
    c2 = conn2.cursor()
    c2.execute("SELECT * FROM exercises")
    allEx = c2.fetchall()
    print(allEx)

lift_button = tk.Button(root, text="Submit", command=newLift, font=("Helvetica", 16), bg="#007AFF", fg="black", relief="flat", padx=20, pady=10)
lift_button.pack(pady=20)

print_button = tk.Button(root, text="Print", command=printData, font=("Helvetica", 16), bg="#007AFF", fg="black", relief="flat", padx=20, pady=10)
print_button.pack(pady=20)
    # TEMPORARY
'''

# Start the Tkinter main loop
root.mainloop()
