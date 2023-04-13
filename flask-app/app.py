from flask import Flask, render_template, request
import mysql.connector

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        user_details = request.form
        username = user_details['username']
        email = user_details['email']
        password = user_details['password']

        conn = mysql.connector.connect(user='<user>', password='<password>', host='<host>', database='<database>')
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (username, email, password) VALUES (%s, %s, %s)", (username, email, password))
        conn.commit()

        return render_template('register.html', success=True)

    return render_template('register.html')

if __name__ == '__main__':
    app.run(debug=True)


