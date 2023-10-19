import tkinter as tk
from tkinter import messagebox
import sqlite3

# creates database and cursor
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
    "Intermediate": 10,
    "Advanced": 10
}

days_nums = {
    "2 Days": 10,
    "3 Days": 8,
    "4 Days": 12,
    "5 Days": 5,
    "6 Days": 4

}

len_vars = {
    "30 mins": 10,
    "45 mins": 8,
    "1 hour": 12,
    "1.5 hours": 5,
    "2 hours": 4

}


# Function to simulate login and transition to the home page
def login():
    conn2 = sqlite3.connect('login_info.db')
    c2 = conn2.cursor()

    c2.execute("SELECT * FROM users")
    allUsers = c2.fetchall()
    username = Login.entry_username.get()
    password = Login.entry_password.get()

    # Simulated authentication logic (replace with actual authentication)
    if (username, password) in allUsers:
        messagebox.showinfo("Login Successful", "Login Successful")
        global globalUser
        globalUser = username
        show_home_screen()
    else:
        messagebox.showerror("Login Failed", "Invalid username or password")
    conn2.commit()
    conn2.close()
    return


# create account function for database
def create_account():
    conn2 = sqlite3.connect('login_info.db')
    c2 = conn2.cursor()

    # Insert into table
    c2.execute("SELECT username FROM users")
    allUsernames = c2.fetchall()
    username = Login.entry_username.get()
    password = Login.entry_password.get()
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
        # Open the home page
        show_home_screen()
    conn2.commit()
    conn2.close()
    return


def hide_frames():
    for frame in root.winfo_children():
        frame.pack_forget()


def back_button():
    button = MyButton(root.winfo_children()[-1], text="Previous Page", command=show_home_screen)
    button.pack(pady=20)


def show_login_screen():
    hide_frames()
    Login.frame.pack()


def show_home_screen():
    hide_frames()
    Home.frame.pack()


# Function to open the meal entry screen
def show_meal_page():
    hide_frames()
    Meal.frame.pack()


# Function to open the workout tracking page
def show_calorie_tracker():
    hide_frames()
    Workout.frame.pack()


def show_workout_settings():
    hide_frames()
    WorkoutSettings.frame.pack()


# Function to calculate calories based on exercise and duration
def calculate_calories():
    exercise = Workout.exercise_var.get()
    duration = Workout.entry_duration.get()
    try:
        duration = float(duration)
        if exercise in exercise_options:
            calorie_burn_rate = exercise_options[exercise]
            calories_burned = duration * calorie_burn_rate
            Workout.calories_var.set(f"{calories_burned:.2f} calories")
        else:
            Workout.calories_var.set("Unknown Exercise")
    except ValueError:
        Workout.calories_var.set("Invalid Duration")


# Function to open the past workout update screen
def show_record_new_workout():
    hide_frames()
    RecordNewWorkout.frame.pack()


def save_workout():
    workout_to_submit = RecordNewWorkout.workout_var.get()
    if workout_to_submit == "Select a workout":
        messagebox.showerror("Error", "Please select a workout from the drop down")
    else:
        RecordNewWorkout.c2.execute("INSERT INTO workoutHistory VALUES (:user, :date, :workout)",
                                {
                                    'user': globalUser,
                                    'date': RecordNewWorkout.entry_date.get(),
                                    'workout': RecordNewWorkout.workout_var.get() + "::" + RecordNewWorkout.entry_sets.get() + "::" + RecordNewWorkout.entry_reps.get() + "::" + RecordNewWorkout.entry_weight.get()
                                })
        RecordNewWorkout.conn2.commit()
        RecordNewWorkout.conn2.close()

        RecordNewWorkout.workout_var.set("Select a workout")
        RecordNewWorkout.entry_date.delete(0, 'end')
        RecordNewWorkout.entry_sets.delete(0, 'end')
        RecordNewWorkout.entry_reps.delete(0, 'end')
        RecordNewWorkout.entry_weight.delete(0, 'end')

        messagebox.showinfo("Workout Submitted Successfully", "Workout Submitted Successfully")


# Function to open the profile information update screen
def show_update_profile_info():
    hide_frames()
    ProfileInfo.frame.pack()


# Root Window
root = tk.Tk()
root.title("StrongEats")
root.geometry("360x650")


# Creates default button style so that you don't have to specify everytime
class MyButton(tk.Button):
    def __init__(self, master=None, **kwargs):
        super().__init__(master, **kwargs)
        self.configure(
            font=("Helvetica", 16),
            bg="#007AFF",
            fg='black',
            relief="flat",
            padx=20,
            pady=10
        )


class MyLabel(tk.Label):
    def __init__(self, master=None, font_size=12, bold=False, **kwargs):
        super().__init__(master, **kwargs)
        font_weight = "bold" if bold else "normal"
        self.configure(
            font=("Helvetica", font_size, font_weight)
        )


# FRAMES (Simulates new pages)
# Login Page Frame
class Login:
    frame = tk.Frame(root)
    login_label = MyLabel(frame, text="Welcome Back", font_size=20, bold=True)
    login_label.pack(pady=20)
    # Create labels and entries for username
    label_username = tk.Label(frame, text="Username")
    label_username.pack(pady=10)
    entry_username = tk.Entry(frame)
    entry_username.pack(pady=5)
    # Create labels and entries for password
    label_password = tk.Label(frame, text="Password")
    label_password.pack(pady=10)
    entry_password = tk.Entry(frame, show="*")
    entry_password.pack(pady=5)
    # Create a login button
    login_button = MyButton(frame, text="Login", command=login)
    login_button.pack(pady=20)
    # Create account button
    create_account_button = MyButton(frame, text="Create Account", command=create_account)
    create_account_button.pack(pady=20)


# Home Page Frame
class Home:
    frame = tk.Frame(root)
    # Create a label for the home page title
    title_label = MyLabel(frame, text="Your Dashboard", font_size=20, bold=True)
    title_label.pack(pady=20)

    # Home Screen Buttons
    calorie_tracker_button = MyButton(frame, text="Track Calories", command=show_calorie_tracker)
    calorie_tracker_button.pack(pady=10)

    new_workout_button = MyButton(frame, text="Record New Workout", command=show_record_new_workout)
    new_workout_button.pack(pady=10)

    add_meal_button = MyButton(frame, text="Add Meal", command=show_meal_page)
    add_meal_button.pack(pady=10)

    workout_settings_button = MyButton(frame, text="Workout Settings", command=show_workout_settings)
    workout_settings_button.pack(pady=10)

    update_profile_info_button = MyButton(frame, text="Update Profile Information", command=show_update_profile_info)
    update_profile_info_button.pack(pady=10)

    logout_button = MyButton(frame, text="Logout", command=show_login_screen)
    logout_button.pack(pady=10)


# Add Meal Frame
class Meal:
    frame = tk.Frame(root)
    # Create labels and widgets for the meal entry screen here
    label_meal = MyLabel(frame, text="Welcome to Meal Tracker", font_size=20, bold=True)
    label_meal.pack(pady=20)
    # Add meal-related widgets here (e.g., food selection, calories, etc.)
    back_button()


# Add Workout Frame
class Workout:
    frame = tk.Frame()
    # Add workout tracking content here
    label_workout = MyLabel(frame, text="Calorie Tracker", font_size=20, bold=True)
    label_workout.pack(pady=20)
    # Dropdown menu for exercise selection
    label_exercise = tk.Label(frame, text="Exercise:")
    label_exercise.pack(pady=10)
    exercise_var = tk.StringVar()
    exercise_dropdown = tk.OptionMenu(frame, exercise_var, *exercise_options.keys())
    exercise_dropdown.config(font=("Helvetica", 12))
    exercise_dropdown.pack(pady=5)
    exercise_var.set(list(exercise_options.keys())[0])  # Set the default option
    label_duration = tk.Label(frame, text="Duration (min):")
    label_duration.pack(pady=10)
    entry_duration = tk.Entry(frame)
    entry_duration.pack(pady=5)
    label_calories = tk.Label(frame, text="Calories Burned:")
    label_calories.pack(pady=10)
    calories_var = tk.StringVar()
    label_calories_value = tk.Label(frame, textvariable=calories_var)
    label_calories_value.pack(pady=5)

    # Button to calculate calories
    calculate_button = tk.Button(frame, text="Calculate Calories", command=calculate_calories)
    calculate_button.pack(pady=20)
    back_button()


# Update Workout Info Frame
class WorkoutSettings:
    frame = tk.Frame()
    label_meal = MyLabel(frame, text="Workout Settings", font_size=20, bold=True)
    label_meal.pack(pady=20)
    label_exercise = MyLabel(frame, text="Experience:")
    label_exercise.pack(pady=10)
    exercise_var = tk.StringVar()
    exercise_dropdown = tk.OptionMenu(frame, exercise_var, *exp_vars.keys())
    exercise_dropdown.config(font=("Helvetica", 12))
    exercise_dropdown.pack(pady=5)
    exercise_var.set(list(exp_vars.keys())[0])  # Set the default option
    label_days = MyLabel(frame, text="How often do you want to work out:")
    label_days.pack(pady=10)
    days_var = tk.StringVar()
    days_dropdown = tk.OptionMenu(frame, days_var, *days_nums.keys())
    days_dropdown.config(font=("Helvetica", 12))
    days_dropdown.pack(pady=5)
    days_var.set(list(days_nums.keys())[0])  # Set the default option
    label_len = MyLabel(frame, text="How long do you want to work out for:")
    label_len.pack(pady=10)
    len_var = tk.StringVar()
    len_dropdown = tk.OptionMenu(frame, len_var, *len_vars.keys())
    len_dropdown.config(font=("Helvetica", 12))
    len_dropdown.pack(pady=5)
    len_var.set(list(len_vars.keys())[0])  # Set the default option
    # Need to attach this to database to save profile info

    save_button = tk.Button(frame, text="Save Changes")
    save_button.pack(pady=10)
    back_button()


# Record New Workout Frame
class RecordNewWorkout:
    frame = tk.Frame()
    # Opens database to access workout history
    conn2 = sqlite3.connect('login_info.db')
    c2 = conn2.cursor()
    # Create labels and widgets for updating past workouts here
    label_past_workout = MyLabel(frame, text="Record New Workout", font_size=20, bold=True)
    label_past_workout.pack(pady=20)

    label_enter_date = MyLabel(frame, text="Enter Date (MM/DD/YYYY):")
    label_enter_date.pack()

    entry_date = tk.Entry(frame, font=("Helvetica", 12))
    entry_date.pack(pady=5)

    label_select_workout = MyLabel(frame, text="Select a workout")
    label_select_workout.pack(pady=10)

    c2.execute("SELECT name FROM exercises")
    workout_options_raw = c2.fetchall()
    workout_options = []
    for item in workout_options_raw:
        workout_options.append(item[0].strip("\'"))
    workout_var = tk.StringVar(frame)
    workout_var.set("Select a workout")
    workout_dropdown = tk.OptionMenu(frame, workout_var, *workout_options)
    workout_dropdown.pack()

    label_sets = MyLabel(frame, text="Enter Sets Done")
    label_sets.pack(pady=10)
    entry_sets = tk.Entry(frame, font=("Helvetica", 12))
    entry_sets.pack(pady=5)

    label_reps = MyLabel(frame, text="Enter Reps Done")
    label_reps.pack(pady=10)
    entry_reps = tk.Entry(frame, font=("Helvetica", 12))
    entry_reps.pack(pady=5)

    label_weight = MyLabel(frame, text="Enter Weight Used")
    label_weight.pack(pady=10)
    entry_weight = tk.Entry(frame, font=("Helvetica", 12))
    entry_weight.pack(pady=5)

    submit_workout_button = tk.Button(frame, text="Submit", command=save_workout)
    submit_workout_button.pack(pady=10)
    # Add widgets to record new workouts here (e.g., select date, exercises, etc.)
    back_button()


class ProfileInfo:
    frame = tk.Frame()
    # Create labels and widgets for updating profile information here
    label_profile = MyLabel(frame, text="Update Profile Information", font_size=20, bold=True)
    label_profile.pack(pady=20)
    # dropdown menus for info
    label_height = MyLabel(frame, text="Height:")
    label_height.pack(pady=10)
    exercise_var = tk.StringVar()
    entry_height = tk.Entry(frame, font=("Helvetica", 12))
    entry_height.pack(pady=5)
    label_weight = MyLabel(frame, text="Weight:")
    label_weight.pack(pady=10)
    entry_weight = tk.Entry(frame, font=("Helvetica", 12))
    entry_weight.pack(pady=5)
    label_calories = MyLabel(frame, text="Goal Weight:")
    label_calories.pack(pady=10)
    calories_var = tk.StringVar()
    entry_calories_value = tk.Entry(frame, font=("Helvetica", 12))
    entry_calories_value.pack(pady=5)
    # Need to attach this to database to save profile info
    save_button = tk.Button(frame, text="Save Changes")
    save_button.pack(pady=10)
    back_button()


# Start the Tkinter main loop
Login.frame.pack()
root.mainloop()
