#!/usr/bin/python
import json, urllib2, os, time, calendar, pickle, requests
#
CACHE_AGE_LIMIT = 1200
cachefile = "/tmp/.repocache"
reposerverurl = "https://api.bitbucket.org/2.0/repositories/speedledger"
username = os.environ['BITBUCKET_USER']
password = os.environ['BITBUCKET_PASSWORD']

def print_clone_url(name):
    print getrepos()[name]

def print_repo_list():
    print "\n".join(getrepos())

def getrepos():
    if (not os.path.isfile(cachefile) or calendar.timegm(time.gmtime()) - os.path.getmtime(cachefile) > CACHE_AGE_LIMIT):
        repos = fetch_from_server(reposerverurl)
        with open(cachefile, 'wb') as f:
            pickle.dump(repos, f)
    else:
        with open(cachefile, 'r') as f:
            repos = pickle.load(f)
    return repos

def fetch_from_server( serverurl ):
    next = serverurl
    data = {}
    while next:
        part, next = fetch_page_from_server(next)
        data = dict(data.items() + part.items())
    return data

def fetch_page_from_server( url ):
    result = requests.get(url, auth=(username, password))
    data = json.loads(result.text)
    repos = {}

    for r in data['values']:
        for link in filter(lambda x: x == 'clone', r['links']):
            for cloneurl in filter(lambda x: x['name'] == 'https', r['links'][link]):
                repos[r['name']] = cloneurl['href']

    return repos, data.get('next','')

if __name__=='__main__':
    import sys
    try:
        func = sys.argv[1]
    except: func = None
    if func:
        try:
            exec func
        except:
            print "Error: incorrect syntax '%s'" % func

