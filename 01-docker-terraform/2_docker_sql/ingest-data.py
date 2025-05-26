#!/usr/bin/env python
# coding: utf-8

import os
import argparse
import pandas as pd
from time import time
from sqlalchemy import create_engine

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    url = params.url
    table_name = params.table_name
    csv_name = 'output.csv'
    
    os.system(f"curl -o {csv_name} {url}")

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000)

    df = next(df_iter)

    engine.connect()

    df.tpep_pickup_datetime=pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime=pd.to_datetime(df.tpep_dropoff_datetime)

    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

    while True:
        t_start = time()
        
        df = next(df_iter)

        df.tpep_pickup_datetime=pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime=pd.to_datetime(df.tpep_dropoff_datetime)

        df.to_sql(name=table_name, con=engine, if_exists='append')

        t_end = time()

        print('inserted another chunk..., took %.3f second' % (t_end - t_start))
        

parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres',)

# user
# password
# host
# port
# database name
# table name, 
# url of the csv

if __name__ == '__main__':
    parser.add_argument('user', help='user name for postgres')    
    parser.add_argument('password', help='password for postgres')
    parser.add_argument('host', help='host  for postgres')
    parser.add_argument('port', help='port for postgres')
    parser.add_argument('db', help='user name for postgres')
    parser.add_argument('table_name', help='name of table where we will write the results to')
    parser.add_argument('url', help='url of csv file')

    args = parser.parse_args()
    
    main(args)



