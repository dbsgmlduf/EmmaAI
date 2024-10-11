import mysql.connector
from mysql.connector import Error
import os
import hashlib

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host=os.environ.get('DB_HOST'),
            database=os.environ.get('DB_DATABASE'),
            user=os.environ.get('DB_USER'),
            password=os.environ.get('DB_PASSWORD')
        )
        return connection
    except Error as e:
        print("MySQL 연결 오류:", e)
        return None

def initialize_database():
    try:
        connection = get_db_connection()
        if connection is not None:
            cursor = connection.cursor()

            # 테이블 존재여부 확인
            cursor.execute("""
                SELECT COUNT(*)
                FROM information_schema.tables
                WHERE table_schema = %s
                AND table_name = 'user'
            """, (os.environ.get('DB_DATABASE'),))

            if cursor.fetchone()[0] == 0:
                # 테이블이 없으면 테이블 생성
                cursor.execute("""
                    CREATE TABLE user (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        name VARCHAR(255) NOT NULL,
                        email VARCHAR(255) NOT NULL,
                        password VARCHAR(64) NOT NULL,
                        licenseKey VARCHAR(255) NOT NULL,
                        UNIQUE KEY unique_email (email),
                        UNIQUE KEY unique_licenseKey (licenseKey)
                    )
                """)
                print("사용자 테이블이 성공적으로 생성되었습니다.")
            else:
                print("사용자 테이블이 이미 존재합니다.")

            connection.commit()
    except Error as e:
        print("데이터베이스 초기화 오류:", e)
    finally:
        if 'cursor' in locals() and cursor is not None:
            cursor.close()
        if 'connection' in locals() and connection.is_connected():
            connection.close()

def insert_user(name, email, password, licenseKey):
    try:
        connection = get_db_connection()
        if connection is not None:
            cursor = connection.cursor()

            # 이메일 중복 체크
            check_email_query = "SELECT COUNT(*) FROM user WHERE email = %s"
            cursor.execute(check_email_query, (email,))
            email_count = cursor.fetchone()[0]
            if email_count > 0:
                return "EMAIL_EXISTS"
            
            # 라이센스 키 중복 체크
            check_license_query = "SELECT COUNT(*) FROM user WHERE licenseKey = %s"
            cursor.execute(check_license_query, (licenseKey,))
            license_count = cursor.fetchone()[0]
            
            if license_count > 0:
                return "LICENSE_EXISTS"
             
            insert_query = """
            INSERT INTO user (name, email, password, licenseKey)
            VALUES (%s, %s, %s, %s)
            """
            hashed_pw = hashlib.sha256(password.encode()).hexdigest()
            record = (name, email, hashed_pw, licenseKey)

            cursor.execute(insert_query, record)
            connection.commit()

            return True
    except Error as e:
        print("MySQL 데이터 삽입 오류:", e)
        return False
    finally:
        if 'cursor' in locals() and cursor is not None:
            cursor.close()
        if 'connection' in locals() and connection.is_connected():
            connection.close()

def get_user(email, password):
    try:
        connection = get_db_connection()
        if connection is not None:
            cursor = connection.cursor(dictionary=True)

            select_query = """
            SELECT * FROM user
            WHERE email = %s AND password = %s
            """
            hashed_pw = hashlib.sha256(password.encode()).hexdigest()
            cursor.execute(select_query, (email, hashed_pw))
            user = cursor.fetchone()

            if user:
                return True, user
            else:
                return False, None
            
    except Error as e:
        print("MySQL 데이터 조회 오류:", e)
        return False, "MySQL 데이터 조회 오류"
    finally:
        if 'cursor' in locals() and cursor is not None:
            cursor.close()
        if 'connection' in locals() and connection.is_connected():
            connection.close()

def get_user_by_license(licenseKey):
    try:
        connection = get_db_connection()
        if connection is not None:
            cursor = connection.cursor(dictionary=True)

            select_query = """
            SELECT * FROM user
            WHERE licenseKey = %s
            """
            cursor.execute(select_query, (licenseKey,))
            user = cursor.fetchone()

            if user:
                return True, user
            else:
                return False, None
            
    except Error as e:
        print("MySQL 데이터 조회 오류:", e)
        return False, "MySQL 데이터 조회 오류"
    finally:
        if 'cursor' in locals() and cursor is not None:
            cursor.close()
        if 'connection' in locals() and connection.is_connected():
            connection.close()