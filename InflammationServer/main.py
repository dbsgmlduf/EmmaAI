from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
from mysql.connector import Error
from user_insert import insert_user, get_user, initialize_database
from dotenv import load_dotenv
import os

load_dotenv() 

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

initialize_database()

@app.route('/test')
def main():
    success_message = "flask connect"
    return jsonify({
        'success_message': success_message
    })

@app.route('/insert_user', methods=['POST'])
def insert_user_route():
    try:
        data = request.get_json()
        name = data['name']
        email = data['email']
        password = data['password']
        licenseKey = data['licenseKey']

        result = insert_user(name, email, password, licenseKey)

        if result == True:
            return jsonify({'message': '1'})
        elif result == "EXIST":
            return jsonify({'message': '2'})
        else:
            return jsonify({'message': '0'})
        
    except Exception as error:
        return jsonify({'message': '0'})

@app.route('/get_user', methods=['POST'])
def get_user_route():
    try:
        data = request.get_json()
        email = data['email']
        password = data['password']

        success, result = get_user(email, password)

        if success:
            return jsonify({'message': '1', 'user': result})
        else:
            return jsonify({'message': '0'})
        
    except Exception as error:
        return jsonify({'message': '0'})

if __name__ == '__main__':
    app.run(debug=True)