import pandas as pd

from db import with_connection

class Podcaster:
    def podcasters(self):

        @with_connection
        def all(conn):
            cur = conn.cursor()
            cur.execute('''SELECT U.nome AS podcaster
                        FROM Usuario AS U
                        WHERE U.email IN (SELECT P.email
                                          FROM Podcaster AS P
                                          WHERE U.email = P.email)
                        ORDER BY podcaster ASC''')

            columns = [desc[0] for desc in cur.description]
            tuples = [row for row in cur]

            df = pd.DataFrame(data=tuples, columns=columns)

            print(df)

        print(f"Coletando todos os podcasters do SpotUFOP...")
        all()
    
    def by_gender(self, content):

        @with_connection
        def by_gender_(conn):
            cur = conn.cursor()
            cur.execute('''SELECT U.nome
                        FROM Usuario AS U JOIN Podcaster AS P ON (U.email = P.email)
                        WHERE U.genero = '{content}' '''.format(content = content))

            columns = [desc[0] for desc in cur.description]
            tuples = [row for row in cur]

            df = pd.DataFrame(data=tuples, columns=columns)

            print(df)
            
        print(f"Coletando os podcasters baseado no gênero...")
        by_gender_()