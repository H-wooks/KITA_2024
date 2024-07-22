from flask import Flask, render_template, redirect, url_for, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField
from wtforms.validators import DataRequired

app= Flask(__name__)
# app.config.from_pyfile('config.py')
app.config['SECRET_KEY'] = 'e0becc233352d084345c18ee11f061580edcd84fb9d7fe43'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///example.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db=SQLAlchemy(app)                      ## DB를 Flask 객체 app에다 연동

class Task(db.Model):
    id=db.Column(db.Integer, primary_key=True)
    content=db.Column(db.String(200), nullable=False)

class TaskForm(FlaskForm):
    content=StringField('Title', validators=[DataRequired()])
    submit=SubmitField('Add Task')

@app.route('/', methods=['GET', 'POST'])
def index():
    form = TaskForm()
    if form.validate_on_submit():
        new_task = Task(content=form.content.data)
        db.session.add(new_task)
        db.session.commit()
        return redirect(url_for('index'))
    return render_template('index.html', form=form)

@app.route('/tasks')
def tasks():
    tsasks=Task.query.all()
    return jsonify([{'id':task.id, 'content':task.content} for task in tasks])

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)
    