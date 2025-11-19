# app.py
from flask import Flask, render_template, request, redirect, url_for
import psycopg2

app = Flask(__name__)

# Database connection details (will be configured later)
DB_HOST = 'your_database_vm_ip'
DB_NAME = 'todo_db'
DB_USER = 'your_db_user'
DB_PASSWORD = 'your_db_password'

def get_db_connection():
    conn = None
    try:
        conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASSWORD)
    except psycopg2.Error as e:
        print(f"Error connecting to database: {e}")
    return conn

def init_db():
    conn = get_db_connection()
    if conn:
        cur = conn.cursor()
        cur.execute("""
            CREATE TABLE IF NOT EXISTS todos (
                id SERIAL PRIMARY KEY,
                task VARCHAR(255) NOT NULL,
                completed BOOLEAN NOT NULL DEFAULT FALSE
            )
        """)
        conn.commit()
        cur.close()
        conn.close()

@app.route('/')
def index():
    conn = get_db_connection()
    if conn:
        cur = conn.cursor()
        cur.execute("SELECT id, task, completed FROM todos ORDER BY id DESC")
        todos = cur.fetchall()
        cur.close()
        conn.close()
        return render_template('index.html', todos=todos)
    return "Error connecting to the database."

@app.route('/add', methods=['POST'])
def add_todo():
    task = request.form['task']
    conn = get_db_connection()
    if conn:
        cur = conn.cursor()
        cur.execute("INSERT INTO todos (task) VALUES (%s)", (task,))
        conn.commit()
        cur.close()
        conn.close()
    return redirect(url_for('index'))

@app.route('/complete/<int:todo_id>')
def complete_todo(todo_id):
    conn = get_db_connection()
    if conn:
        cur = conn.cursor()
        cur.execute("UPDATE todos SET completed = TRUE WHERE id = %s", (todo_id,))
        conn.commit()
        cur.close()
        conn.close()
    return redirect(url_for('index'))

@app.route('/delete/<int:todo_id>')
def delete_todo(todo_id):
    conn = get_db_connection()
    if conn:
        cur = conn.cursor()
        cur.execute("DELETE FROM todos WHERE id = %s", (todo_id,))
        conn.commit()
        cur.close()
        conn.close()
    return redirect(url_for('index'))

if __name__ == '__main__':
    with app.app_context():
        init_db()
    app.run(debug=True, host='0.0.0.0')