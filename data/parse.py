import os, sys
from collections import defaultdict

from pprint import pprint
import pandas as pd
from pymongo import MongoClient

from fuzzywuzzy import process
from django.utils import encoding

abbr = {'delaware': 'DE', 'north dakota': 'ND', 'washington': 'WA', 'rhode island': 'RI', 'tennessee': 'TN', 'iowa': 'IA', 'nevada': 'NV', 'maine': 'ME', 'colorado': 'CO', 'mississippi': 'MS', 'south dakota': 'SD', 'palau': 'PW', 'new jersey': 'NJ', 'oklahoma': 'OK', 'wyoming': 'WY', 'minnesota': 'MN', 'north carolina': 'NC', 'illinois': 'IL', 'new york': 'NY', 'arkansas': 'AR', 'puerto rico': 'PR', 'indiana': 'IN', 'maryland': 'MD', 'louisiana': 'LA', 'texas': 'TX', 'district of columbia': 'DC', 'arizona': 'AZ', 'wisconsin': 'WI', 'virgin islands': 'VI', 'michigan': 'MI', 'kansas': 'KS', 'utah': 'UT', 'virginia': 'VA', 'oregon': 'OR', 'connecticut': 'CT', 'montana': 'MT', 'california': 'CA', 'new mexico': 'NM', 'alaska': 'AK', 'vermont': 'VT', 'georgia': 'GA', 'marshall islands': 'MH', 'northern mariana islands': 'MP', 'pennsylvania': 'PA', 'florida': 'FL', 'hawaii': 'HI', 'kentucky': 'KY', 'missouri': 'MO', 'nebraska': 'NE', 'new hampshire': 'NH', 'idaho': 'ID', 'west virginia': 'WV', 'south carolina': 'SC', 'ohio': 'OH', 'alabama': 'AL', 'massachusetts': 'MA'}

def augment():
    dfs = {}
    # filter out other files
    path = 'raw/principals/'
    files = (fd for fd in os.listdir(path) if '.' not in fd)
    for f in files:
        str_headers = open(path + f).readlines()[1].split(',')
        headers = tuple([s.replace('"', '').strip().lower() for s in str_headers])
        df = pd.read_csv(path + f, skiprows=1, sep=',', names=headers)
        dfs[abbr[f.lower()[:2]]] = df
        df._state = f
    return dfs

def openline(f, line):
    return open(f).readlines()[line]

def load():
    dfs = augment()
    columns = {df._state: set(df.columns) for df in dfs.values()}

    # field name normalization
    fields = {'principal': ['principal name', 'principals name', 'principal', 'last', 'last name'],
              'school': ['school name', 'schools name', 'school', 'name', "school's name"],
              'email': ['principals email', 'principal email', 'email', 'e-mail', 'emailaddress', 'principalsemail'],
              'zip': ['zip', 'areac', 'zipplus4', 'mail city', 'zip code'],
              'city': ['city', 'town', 'mail zip'],
              'phone': ['phone', 'telephone']}

    for state, cols in columns.items():
        state = abbr[state.lower()]
        for f in fields:
            for field_name in fields[f]:
                if field_name in cols:
                    try:
                        dfs[state][f] = dfs[state][field_name]
                    except ValueError:
                        # key returns two columns?
                        dfs[state][f] = dfs[state][field_name].values[:,0]
                    break
    return dfs

def normalize_zip(zipcode):
    if zipcode:
        return str(zipcode).strip()[:5]
    return None

def normalize_phone(phone):
    if phone:
        return "".join([c for c in str(phone) if c.isdigit()])[-7:]
    return None

def mapping(dfs, field_name, normalizer):
    d = defaultdict(set)
    for state in dfs:
        for i in range(len(dfs[state].values)):
            try:
                field = normalizer(dfs[state][field_name].values[i])
                d[field].add((dfs[state]['school'].values[i], i))
            except KeyError:
                # no zip code
                pass
    return d

def insert_dummy(collection, school):
    collection.update({"_id": school["_id"]},  {"$set": {'principal': "", 'email': ""}});

def augment_school(dfs, collection, school):

    global i, x, n
    i += 1

    try:
        name = school['name'].strip().lower().decode('ascii', errors='ignore')
        methods = [('zip', by_zip, normalize_zip), ('phone', by_phone, normalize_phone)]
        for field, dict, normalizer in methods:
            normalized = normalizer(school['zip'])
            options = {str(r[0]).decode('ascii', errors='ignore'): r[1] for r in dict[normalized]}
            match = process.extractOne(name, options.keys())
            if match and match[1] >= 75:
                x += 1
                print "%i %i %f\r" % (i, n, float(x)/i),
                sys.stdout.flush()

                index = options[match[0]]

                # print name, match

                principal = dfs[school['state']]['principal'].values[index]
                email = dfs[school['state']]['email'].values[index]

                # insert information into db
                collection.update({"_id": school["_id"]},  {"$set": {'principal': principal, 'email': email}});

                return
        else:
            insert_dummy(collection, school)

    # occur very rarely, but break execution
    except UnicodeDecodeError as e:
        print e
    except UnicodeEncodeError as e:
        print e
    except KeyError as e:
        print e
    except IndexError as e:
        insert_dummy(collection, school)
        print e

if __name__ == "__main__":
    db = MongoClient()['thank-a-teacher']
    n = db.publicschools.count() + db.privateschools.count()
    i = 0
    x = 0

    dfs = load()
    by_zip = mapping(dfs, 'zip', normalize_zip) 
    by_phone = mapping(dfs, 'phone', normalize_phone)
    
    schools = list(db.privateschools.find())
    print "Private: ", len(schools)
    for school in schools:
        augment_school(dfs, db.privateschools, school)

    schools = list(db.publicschools.find())
    print "Public: ", len(schools)
    for school in schools:
        augment_school(dfs, db.publicschools, school)
