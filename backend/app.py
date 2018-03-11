from flask import Flask, request, jsonify
from scanner import SkyScannerApiClient
from datetime import datetime, timedelta

import json
import itertools
import requests


DT_FRMT = '%Y-%m-%d'

app = Flask(__name__)
client = SkyScannerApiClient(key='ha116833657313495842086282694234')


@app.route("/")
def main():
    return "Hello, world!"


def generate_perms(origin,
                   destination,
                   num_stops,
                   wish_list,
                   out_str,
                   in_str):
    links = wish_list
    if len(wish_list) < num_stops:
        links += ['anywhere'] * (num_stops - len(wish_list))

    perms = list(itertools.permutations(links))
    perms = map(lambda p: [origin] + list(p) + [destination], perms)

    out_dt = datetime.strptime(out_str, DT_FRMT)
    in_dt = datetime.strptime(in_str, DT_FRMT)
    leg_duration = abs(in_dt - out_dt).days // (num_stops)

    flight_data_perms = []
    for _ in range(len(perms)):
        flight_data_perms.append([])

    out_param = None
    for idx in range(num_stops + 1):
        if idx == num_stops:
            out_param = in_str
        else:
            out_param = (out_dt + timedelta(days=idx * leg_duration)) \
                .strftime(DT_FRMT)

        list_pairs_per_depth = set()    # minimize location pairs
        for perm in perms:
            list_pairs_per_depth.add((perm[idx], perm[idx + 1]))

        urls_per_depth = map(lambda x:
                             client.getBrowseQuotesURL(country='UK',
                                                       currency='GBP',
                                                       locale='en-GB',
                                                       origin=x[0],
                                                       destination=x[1],
                                                       outbound_dt=out_param),
                             list_pairs_per_depth)

        pair_to_data_dict = dict(zip(list_pairs_per_depth,
                                     client.launch_reqs(urls_per_depth)))

        print(pair_to_data_dict)

        for permIdx, perm in enumerate(perms):
            locations = (perm[idx], perm[idx + 1])
            flight_data_perms[permIdx].append({
                'locations': locations,
                'flight_data': pair_to_data_dict.get(locations)
            })


@app.route("/createItinerary", methods=['POST'])
def pricesEndpoint():
    print(request.form)
    country = str(request.form.get('country', 'UK'))
    currency = str(request.form.get('currency', 'GBP'))
    locale = str(request.form.get('locale', 'en-GB'))
    origin = str(request.form['origin'])
    destination = str(request.form.get('destination', 'anywhere'))
    num_stops = int(request.form.get('num_stops', 0))
    wish_list = eval(request.form.get('wish_list', []))
    start_date = str(request.form['start_date'])
    end_date = str(request.form['end_date'])

    generate_perms(origin=origin,
                   destination=destination,
                   num_stops=num_stops,
                   wish_list=wish_list,
                   out_str=start_date,
                   in_str=end_date)

    return jsonify({})


if __name__ == "__main__":
    app.run(debug=True)
