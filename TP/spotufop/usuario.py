import pandas as pd

from db import with_connection

class Usuario:
    def users(self):

        @with_connection
        def all(conn):
            cur = conn.cursor()
            cur.execute("SELECT * FROM Usuario")

            columns = [desc[0] for desc in cur.description]
            tuples = [row for row in cur]

            df = pd.DataFrame(data=tuples, columns=columns)

            print(df)

        print(f"Coletando todos os usuários do SpotUFOP...")
        all()
    
    def all_listeners(self):

        @with_connection
        def all_listeners_(conn):
            cur = conn.cursor()
            cur.execute('''SELECT U.nome AS ouvinte
                        FROM Usuario AS U
                        WHERE U.email IN (SELECT O.email
                                          FROM Ouvinte AS O
                                          WHERE U.email = O.email)
                        ORDER BY ouvinte ASC''')

            columns = [desc[0] for desc in cur.description]
            tuples = [row for row in cur]

            df = pd.DataFrame(data=tuples, columns=columns)

            print(df)
            
        print(f"Coletando todos os ouvintes do SpotUFOP...")
        all_listeners_()

    def by_like(self, content):

        @with_connection
        def by_like_(conn):
            cur = conn.cursor()
            cur.execute('''SELECT C.nome_playlist
                        FROM Curte_Playlist AS C JOIN Usuario AS U ON (C.ouvinte = U.email)
                        WHERE U.nome = '{content}' '''.format(content = content))

            columns = [desc[0] for desc in cur.description]
            tuples = [row for row in cur]

            df = pd.DataFrame(data=tuples, columns=columns)

            print(df)
            
        print(f"Obtendo todas as playlists curtidas por {content}...".format(content = content))
        by_like_()
            
