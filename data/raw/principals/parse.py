import os

from pprint import pprint
import pandas as pd

abbr = {'delaware': 'DE', 'north dakota': 'ND', 'american samoa': 'AS', 'guam': 'GU', 'washington': 'WA', 'rhode island': 'RI', 'tennessee': 'TN', 'iowa': 'IA', 'nevada': 'NV', 'maine': 'ME', 'colorado': 'CO', 'mississippi': 'MS', 'south dakota': 'SD', 'palau': 'PW', 'new jersey': 'NJ', 'oklahoma': 'OK', 'wyoming': 'WY', 'minnesota': 'MN', 'north carolina': 'NC', 'illinois': 'IL', 'new york': 'NY', 'arkansas': 'AR', 'puerto rico': 'PR', 'indiana': 'IN', 'maryland': 'MD', 'louisiana': 'LA', 'texas': 'TX', 'district of columbia': 'DC', 'arizona': 'AZ', 'wisconsin': 'WI', 'virgin islands': 'VI', 'michigan': 'MI', 'kansas': 'KS', 'utah': 'UT', 'virginia': 'VA', 'oregon': 'OR', 'connecticut': 'CT', 'montana': 'MT', 'california': 'CA', 'new mexico': 'NM', 'alaska': 'AK', 'vermont': 'VT', 'georgia': 'GA', 'marshall islands': 'MH', 'northern mariana islands': 'MP', 'pennsylvania': 'PA', 'florida': 'FL', 'hawaii': 'HI', 'kentucky': 'KY', 'missouri': 'MO', 'nebraska': 'NE', 'new hampshire': 'NH', 'idaho': 'ID', 'west virginia': 'WV', 'south carolina': 'SC', 'ohio': 'OH', 'alabama': 'AL', 'massachusetts': 'MA'}

def augment():
    dfs = {}
    # filter out other files
    files = (fd for fd in os.listdir('.') if '.' not in fd)
    for f in files:
        headers = tuple([s.replace('"', '') for s in open(f).readlines()[1].split(',')])
        df = pd.read_csv(f, skiprows=1, sep=',', names=headers)
        dfs[abbr[f.lower()]] = df
    return dfs

def openline(f, line):
    return open(f).readlines()[line]

if __name__ == "__main__":
    dfs = augment()