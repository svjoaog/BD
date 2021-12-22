import pandas as pd

from db import with_connection

class Artista:
    def artists(self):

        @with_connection
        def all(conn):
            cur = conn.cursor()
            cur.execute('''SELECT U.nome AS artista
                        FROM Usuario AS U
                        WHERE U.email IN (SELECT A.email
                                          FROM Artista AS A
                                          WHERE U.email = A.email)
                        ORDER BY artista ASC''')

            columns = [desc[0] for desc in cur.description]
            tuples = [row for row in cur]

            df = pd.DataFrame(data=tuples, columns=columns)

            print(df)

        print(f"Coletando todos os artistas do SpotUFOP...")
        all()
    
    def by_musical_genre(self):
        
        @with_connection
        def by_musical_genre_(conn):
            cur = conn.cursor()
            cur.execute('''SELECT A.genero_musical, COUNT(*) AS quantidade
                        FROM Artista AS A
                        GROUP BY A.genero_musical
                        ORDER BY A.genero_musical ASC''')

            columns = [desc[0] for desc in cur.description]
            tuples = [row for row in cur]

            df = pd.DataFrame(data=tuples, columns=columns)

            print(df)

        print(f"Coletando a quantidade de artistas para cada gênero musical...")
        by_musical_genre_()

    def upgrade_artist(self, artist=None):

        @with_connection
        def update(conn):
            cur = conn.cursor()
            cur.execute('''UPDATE Artista 
                        SET numero_integrantes = numero_integrantes - 1
                        WHERE funcao = 'Banda' AND email IN (SELECT Usuario.email 
									                         FROM Usuario 
									                         WHERE Usuario.nome = '{artist}') '''.format(artist = artist))
            print(cur.statusmessage)

        if not artist:
            self.artists()
            artist = input("\nSelecione o nome da banda que deseja atualizar o numero de integrantes: ")
        
        update()
    
    def employment_relationship(self, initial, final):

        @with_connection
        def by_date(conn):
            cur = conn.cursor()
            cur.execute('''SELECT Gravadora.nome AS gravadora, Usuario.nome AS artista, Artista.funcao 
                        FROM Usuario JOIN Artista ON (Usuario.email = Artista.email) 
                        JOIN Artista_Gravadora ON (Artista.email = Artista_Gravadora.artista)
                        JOIN Gravadora ON (Artista_Gravadora.gravadora = Gravadora.cnpj)
                        WHERE Artista_Gravadora.data_inicio BETWEEN '{initial}' AND '{final}'
                        ORDER BY artista ASC'''.format(initial = initial, final = final))

            columns = [desc[0] for desc in cur.description]
            tuples = [row for row in cur]

            df = pd.DataFrame(data=tuples, columns=columns)

            print(df)

        print(f"Coletando todos os vínculos entre artistas e gravadoras no período entre {initial} e {final}...".format(initial = initial, final = final))
        by_date()

    def by_record_company(self, email):

        @with_connection
        def by_email(conn):
            cur = conn.cursor()
            cur.execute('''SELECT Usuario.nome 
                        FROM Usuario JOIN Artista_Gravadora
                        ON Usuario.email = Artista_Gravadora.artista
                        WHERE Artista_Gravadora.gravadora IN (SELECT Artista_Gravadora.gravadora 
									                          FROM Artista_Gravadora JOIN Artista ON (Artista_Gravadora.artista = Artista.email) 
									                          WHERE Artista.email = '{email}') 
	                    AND 
                            Usuario.email IN (SELECT Artista.email 
                            FROM Artista
                            WHERE Artista.email <> '{email}') 
                        ORDER BY Usuario.nome ASC'''.format(email = email))

            columns = [desc[0] for desc in cur.description]
            tuples = [row for row in cur]

            df = pd.DataFrame(data=tuples, columns=columns)

            print(df)

        print(f"Coletando todos os artistas que foram/estão vinculados à mesma gravadora que determinado artista...")
        by_email()


        

        

