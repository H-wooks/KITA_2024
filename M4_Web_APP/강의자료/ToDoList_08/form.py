from flask_wtf import FlaskForm
from wtforms import (
    StringField,
    PasswordField,
    TextAreaField,
    DateField,
    BooleanField,
    SubmitField,
)
from wtforms.validators import DataRequired, Email, EqualTo


class TaskForm(FlaskForm):
    title = StringField("Title", validators=[DataRequired()])
    contents = TextAreaField("Contents", validators=[DataRequired()])
    due_date = DateField("Due Date", validators=[DataRequired()])


class LoginForm(FlaskForm):
    username = StringField("Username", validators=[DataRequired()])
    password = PasswordField("Password", validators=[DataRequired()])


class RegistrationForm(FlaskForm):
    username = StringField("Username", validators=[DataRequired()])
    email = StringField("Email", validators=[DataRequired(), Email()])
    password = PasswordField("Password", validators=[DataRequired()])
    confirm_password = PasswordField(
        "Confirm Password", validators=[DataRequired(), EqualTo("password")]
    )
    submit = SubmitField("Register")


class UserForm(FlaskForm):
    username = StringField("Username", validators=[DataRequired()])
    email = StringField("Email", validators=[DataRequired(), Email()])
    password = PasswordField("Password", validators=[DataRequired()])
    confirm_password = PasswordField(
        "Confirm Password", validators=[DataRequired(), EqualTo("password")]
    )
    is_admin = BooleanField("Admin")
    submit = SubmitField("Submit")


class UpdateProfileForm(FlaskForm):
    username = StringField("Username", validators=[DataRequired()])
    email = StringField("Email", validators=[DataRequired(), Email()])
    password = PasswordField("New Password")
    confirm_password = PasswordField(
        "Confirm Password", validators=[EqualTo("password")]
    )
    submit = SubmitField("Update")



# from flask_migrate import Migrate
# from flask_wtf import FlaskForm
# from wtforms import StringField,PasswordField,BooleanField,SubmitField,TextAreaField, DateField
# from wtforms.validators import DataRequired, Length

# class TaskForm(FlaskForm):
#     title = StringField('Title', validators=[DataRequired()])
#     contents=TextAreaField('내용', validators=[DataRequired()])
#     due_date=DateField('마감일', format="%Y-%m-%d", validators=[DataRequired()])

# class LoginForm(FlaskForm):
#     username=StringField('Username', validators=[DataRequired()])
#     password=PasswordField('Password', validators=[DataRequired()])
#     submit=SubmitField('Login')

# class RegistrationForm(FlaskForm):
#     username=StringField('Username', validators=[DataRequired(), Length(min=4, max=25)])
#     password=PasswordField('Password', validators=[DataRequired(), Length(min=6)])
#     is_admin=BooleanField('Is Admin')
#     submit=SubmitField('Register')

