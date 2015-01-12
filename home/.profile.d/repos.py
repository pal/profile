#!/usr/bin/python
import json, urllib2, os, time, calendar, pickle, requests
#

# Store data in a cache file
# reponame -> clone url

class Repositories:
    CACHE_AGE_LIMIT = 1200
    cachefile = "/tmp/.repocache"

    def print_clone_url(self, name):
        print self._getrepos()[name]

    def print_repo_list(self):
        print "\n".join(self._getrepos())

    def _getrepos(self):
        if (not os.path.isfile(self.cachefile) or calendar.timegm(time.gmtime()) - os.path.getmtime(self.cachefile) > self.CACHE_AGE_LIMIT):
            repos = self._fetch_from_servers()
        else:
            with open(self.cachefile, 'r') as f:
                repos = pickle.load(f)
        return repos

    def _fetch_from_servers(self):
        repos = dict(
            GithubRepoFetcher(os.environ['GITHUB_USER'], os.environ['GITHUB_PASSWORD']).fetch() +
            BitBucketRepoFetcher(os.environ['BITBUCKET_USER'], os.environ['BITBUCKET_PASSWORD']).fetch()
            )
        with open(self.cachefile, 'wb') as f:
            pickle.dump(repos, f)
        return repos

class GithubRepoFetcher:
    #"full_name": "speedledger/zendem",
    GITHUB_SERVER_URL = "https://api.github.com/orgs/speedledger/repos"
    def __init__(self, username, password):
        self.username = username
        self.password = password

    def fetch(self):
        result = requests.get(self.GITHUB_SERVER_URL, auth=(self.username, self.password))
        data = json.loads(result.text)
        repos = {}

        for r in data:
            repos[r['name']] = r['ssh_url']

        return repos.items()

class BitBucketRepoFetcher:
    BITBUCKET_SERVER_URL = "https://api.bitbucket.org/2.0/repositories/speedledger"

    def __init__(self, username, password):
        self.username = username
        self.password = password

    def fetch(self):
        next = self.BITBUCKET_SERVER_URL
        data = {}
        while next:
            part, next = self._fetch_page_from_server(next)
            data = dict(data.items() + part.items())
        return data.items()

    def _fetch_page_from_server(self, url):
        result = requests.get(url, auth=(self.username, self.password))
        data = json.loads(result.text)
        repos = {}

        for r in data['values']:
            for link in filter(lambda x: x == 'clone', r['links']):
                for cloneurl in filter(lambda x: x['name'] == 'https', r['links'][link]):
                    repos[r['name']] = cloneurl['href']

        return repos, data.get('next','')


if __name__=='__main__':
    import sys, traceback
    try:
        funcname = sys.argv[1]
        if len(sys.argv) > 2:
            args = sys.argv[2]
        else: args = None
        func = getattr(Repositories(), funcname)
    except:
        func = None
        print traceback.format_exc()

    if func:
        try:
            if (args): func(args)
            else: func()
        except Exception, err:
            print "Error: executing '%s'" % func
            print traceback.format_exc()
    else:
        print "Undefined function: ", funcname

