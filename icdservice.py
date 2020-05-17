import requests
import urllib3

token_endpoint = 'https://icdaccessmanagement.who.int/connect/token'
client_id = '4b3e1a69-2c05-4fbe-8465-ee3c27a85f80_64e075fa-722c-458e-b5b8-3ee5c5f68844'
client_secret = 'nq0/u59msP6HRyO2d1Ox0cW0QyS4h9gemOYAB/aprfQ='
scope = 'icdapi_access'
grant_type = 'client_credentials'

urllib3.disable_warnings()

# get the OAUTH2 token

# set data to post
payload = {'client_id': client_id,
           'client_secret': client_secret,
           'scope': scope,
           'grant_type': grant_type,
           'q': ''}

# make request
r = requests.post(token_endpoint, data=payload, verify=False).json()
token = r['access_token']


def search_term(term):
    # access ICD API
    uri = 'https://id.who.int/icd/entity/search'

    payload['q']= term

    # HTTP header fields to set
    headers = {'Authorization': 'Bearer ' + token,
               'Accept': 'application/json',
               'Accept-Language': 'en',
               'API-Version': 'v2'}

    destination_entities = []
    results = []
    j = {}
    r = requests.Response()

    try:
        # make request
        r = requests.get(uri, headers=headers, verify=False, params=payload)

        if r.status_code == 404:
            j['definition']['@value'] = "N/A"
        if r.ok:
            j = r.json()
        else:
            r.raise_for_status
            # raise RuntimeError("Something bad happened")

    except LookupError:
        return "Invalid Query"

    except requests.exceptions.RequestException as e:
        return e

    finally:
        destination_entities += j['destinationEntities']

        for entity in destination_entities:
            id = entity['id'].lstrip('http://id.who.int/icd/entity/')
            result = {
                'title': entity['title'],
                'id': id,
                'score': entity['score'],
                'description': get_entity_description(id)
            }
            results.append(result)

        return results


#
def get_entity_description(id):
    uri = 'https://id.who.int/icd/entity/' + str(id)

    # HTTP header fields to set
    headers = {'Authorization': 'Bearer ' + token,
               'Accept': 'application/json',
               'Accept-Language': 'en',
               'API-Version': 'v2'}

    j = {}

    # make request
    try:
        r = requests.get(uri, headers=headers, verify=False)

        if r.status_code == 404:
            j['definition']['@value'] = "N/A"
        if r.ok:
            j = r.json()
        else:
            r.raise_for_status
            # raise RuntimeError("Something bad happened")

    except LookupError:
        return "Invalid Query"

    except requests.exceptions.RequestException as e:
        return e

    finally:
        # print(j['definition']['@value'])
        if 'definition' in j:
            return j['definition']['@value']
        else:
            return "N/A"
