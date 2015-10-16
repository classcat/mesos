#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os,sys

import json
import urllib2
import oauth2 as oauth

from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider


KEYSPACE_NAME="cc_twitter"

CASSANDRA_CLUSTER="119.81.160.203"
#CASSANDRA_CLUSTER="192.168.0.50"

TWITTER_URL = 'https://stream.twitter.com/1.1/statuses/sample.json'

CONSUMER_KEY="czB9dWwUgCtIVteis8cA"
CONSUMER_SECRET="Wo229FJ5j2OgshCHG8ijQ9hDv5SgdfELz5XuL2f8"



ACCESS_TOKEN_KEY="427314069-dBoQmPmtTuJNifZaTctD5ZcpmKxnD5RjEjzfcCfT"
ACCESS_TOKEN_SECRET="8st9n8a04JP259t2COsEFP0iy2L5GQelWbn8USfZRl4"



def streaming():
    consumer = oauth.Consumer(key=CONSUMER_KEY, secret=CONSUMER_SECRET)
    token = oauth.Token(key=ACCESS_TOKEN_KEY, secret=ACCESS_TOKEN_SECRET)

    request = oauth.Request.from_consumer_and_token(consumer, token, http_url=TWITTER_URL)
    request.sign_request(oauth.SignatureMethod_HMAC_SHA1(), consumer, token)
    res = urllib2.urlopen(request.to_url())

    for r in res:
        data = json.loads(r)

        if data.has_key('delete'):
            continue

        if not data.has_key('lang'):
            continue

        lang = data['lang']

        if lang == 'ja':
            pass
        elif lang == 'en':
            pass
        else:
            continue

        id_str = data['id_str']
        lang = data['lang']
        text = data['text']
        created_at = data['created_at']
        timestamp_ms = int(data['timestamp_ms'])

        print(id_str)
#        print(timestamp_ms)

        session.execute(
            """
            INSERT INTO tweets (id_str, lang, text, created_at, timestamp_ms)
            VALUES (%s, %s, %s, %s, %s)
            """,
            (id_str, lang, text, created_at, timestamp_ms)
        )

    pass


if __name__ == '__main__':
#    pool = ConnectionPool('mykeyspace2', ['localhost:9160'])
#    pool = ConnectionPool('demo', ['192.168.0.50:9042'])
#    pool = ConnectionPool('mykeyspace2', ['localhost:9042'])
#    col_fam = ColumnFamily(pool, 'cc_tweets')

    auth_provider = PlainTextAuthProvider(username='classcat', password='ClassCat')
    cluster = Cluster([CASSANDRA_CLUSTER], auth_provider=auth_provider)
    session = cluster.connect(KEYSPACE_NAME)

    streaming()


### End of Script ###
