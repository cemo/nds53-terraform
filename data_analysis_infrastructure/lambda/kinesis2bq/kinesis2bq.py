import base64
import datetime
import json
import os
import sys

import boto3

sys.path.append(os.path.join(os.path.abspath(os.path.dirname(__file__)), 'vendor'))
from gcloud import bigquery
from oauth2client.service_account import ServiceAccountCredentials

BQ_CREDENTIALS = os.environ['BQ_CREDENTIALS']
BQ_PROJECT = os.environ['BQ_PROJECT']
BQ_DATASET = os.environ['BQ_DATASET']
BQ_TABLE = os.environ['BQ_TABLE']

def handler(event, context):
    rows = []

    for r in event['Records']:
        payload = r['kinesis']['data']
        try:
            data = json.loads(base64.b64decode(payload))
            row = []
            for key in ['time', 'tag', 'value']:
                if key == 'time':
                    row.append(datetime.datetime.fromtimestamp(data[key]))
                else:
                    row.append(data[key])
            rows.append(tuple(row))
        except Exception as e:
            print('Invalid data "{0}": {1}'.format(payload, e))
            pass

    if len(rows) == 0:
        return

    kms = boto3.client('kms')
    blob = base64.b64decode(BQ_CREDENTIALS)
    dec = kms.decrypt(CiphertextBlob = blob)
    keyfile_dict = json.loads(dec['Plaintext'])
    credentials = ServiceAccountCredentials.from_json_keyfile_dict(keyfile_dict)

    bq = bigquery.Client(credentials = credentials, project = BQ_PROJECT)
    dataset = bq.dataset(BQ_DATASET)
    table = dataset.table(BQ_TABLE)
    table.reload()
    res = table.insert_data(rows)

    print(res)
