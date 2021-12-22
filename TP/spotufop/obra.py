import pandas as pd

from db import with_connection

class Obra:
    def all(self):

        @with_connection
        def _all_(conn):
            cur = conn.cursor()
            cur.execute("SELECT * FROM Obra")

            columns = [desc[0] for desc in cur.description]
            tuples = [row for row in cur]

            df = pd.DataFrame(data=tuples, columns=columns)

            print(df)

        print(f"Coletando todas as obras do SpotUFOP...")
        _all_()

    def episode(self, name):

        @with_connection
        def episode_(conn):
            cur = conn.cursor()
            cur.execute('''SELECT C.nome AS podcast, O.nome AS episodio, O.duracao
                        FROM Obra AS O JOIN Episodio AS E ON (O.registro = E.registro) 
                        JOIN Podcast AS P ON (E.podcast = P.selo) 
                        JOIN Coletanea AS C ON (P.selo = C.selo)
                        WHERE C.nome = '{name}' '''.format(name = name))

            columns = [desc[0] for desc in cur.description]
            tuples = [row for row in cur]

            df = pd.DataFrame(data=tuples, columns=columns)

            print(df)

        print(f"Coletando todos os episódios de um determinado podcast...")
        episode_()
    
    def music(self, name):
        
        @with_connection
        def music_(conn):    
            cur = conn.cursor()
            cur.execute('''SELECT Coletanea.nome AS album, Obra.nome AS musica, Obra.duracao
                        FROM Obra NATURAL JOIN Musica
                        JOIN Album ON (Musica.album = Album.selo)
                        JOIN Coletanea ON (Album.selo = Coletanea.selo)
                        WHERE Coletanea.nome = '{name}' '''.format(name = name))

            columns = [desc[0] for desc in cur.description]
            tuples = [row for row in cur]

            df = pd.DataFrame(data=tuples, columns=columns)

            print(df)

        print(f"Coletando todas as músicas de um determinado álbum...")
        music_()
    
    def remove(self, code=None):

        @with_connection
        def delete(conn):
            cur = conn.cursor()
            cur.execute(f"DELETE FROM Obra WHERE registro='{code}'")
            
            print(cur.statusmessage)

        if not code:
            self.all()
            code = input("\nSelecione o registro da obra que deseja remover: ")

        delete()