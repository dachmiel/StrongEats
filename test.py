
import tkinter as tk
from tkinter import messagebox

# Function to simulate login and transition to the home page
def login():
    username = entry_username.get()
    password = entry_password.get()

    # Simulated authentication logic (replace with actual authentication)
    if username == "login" and password == "p":
        messagebox.showinfo("Login Successful", "Welcome, " + username + "!")
        # Close the login window
        root.destroy()
        # Open the home page (you can replace this with your actual home page code)
        open_home_page()
    else:
        messagebox.showerror("Login Failed", "Invalid username or password")

# Function to open the home page (replace with your actual home page code)
def open_home_page():
    home_window = tk.Tk()
    home_window.title("Home Page")
    home_window.geometry("300x200")

    # Add home page content here (e.g., labels, buttons, etc.)
    label_home = tk.Label(home_window, text="Welcome to the Home Page!")
    label_home.pack(pady=20)

    home_window.mainloop()

# Create the main login window
root = tk.Tk()
root.title("Mobile Login Screen")
root.geometry("300x400")

# Create labels and entries for username and password
label_username = tk.Label(root, text="Username:")
label_username.pack(pady=10)
entry_username = tk.Entry(root)
entry_username.pack(pady=5)

label_password = tk.Label(root, text="Password:")
label_password.pack(pady=10)
entry_password = tk.Entry(root, show="*")  # Password entry
entry_password.pack(pady=5)

# Create a login button
login_button = tk.Button(root, text="Login", command=login)
login_button.pack(pady=20)

# Start the Tkinter main loop
root.mainloop()
