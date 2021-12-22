import os
import psycopg2 as postgres
from dotenv import load_dotenv

load_dotenv()

DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

def with_connection(f):

    def with_connection_(*args, **kwargs):
        conn = postgres.connect(dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)
        try:
            rv = f(conn, *args, **kwargs)
        except Exception:
            conn.rollback()
            raise
        else:
            conn.commit()
        finally:
            conn.close()
        return rv
    return with_connection_