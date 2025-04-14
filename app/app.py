import os
import time
from flask import Flask, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['STATIC_FOLDER'] = os.environ.get('STATIC_FOLDER', 'static')

db = SQLAlchemy(app)


class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    completed = db.Column(db.Boolean, default=False)

    def __repr__(self):
        return f'<Task {self.title}>'


@app.route('/')
def index():
    tasks = Task.query.all()
    return jsonify({
        "message": "Task API",
        "tasks_count": len(tasks),
        "env_test": os.environ.get('TEST_ENV_VAR', 'not set')
    })


@app.route('/tasks')
def get_tasks():
    tasks = Task.query.all()
    result = [{"id": task.id, "title": task.title, "completed": task.completed} for task in tasks]
    return jsonify(result)


def wait_for_db():
    max_tries = 30
    for i in range(max_tries):
        try:
            db.engine.connect()
            print("Database is available!")
            return True
        except Exception as e:
            print(f"Database not available yet (attempt {i + 1}/{max_tries}): {e}")
            time.sleep(1)
    return False


def initialize_database():
    db.create_all()
    
    if not Task.query.first():
        tasks = [
            Task(title="Изучить Docker", completed=True),
            Task(title="Изучить Flask", completed=True),
            Task(title="Создать приложение", completed=False)
        ]
        db.session.add_all(tasks)
        db.session.commit()
        print("Test data created")


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))
