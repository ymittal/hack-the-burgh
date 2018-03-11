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


def collect_data_by_leg(perms, depth, out_param):
    locs_pairs_per_depth = set()    # minimize location pairs
    for perm in perms:
        locs_pairs_per_depth.add((perm[depth], perm[depth + 1]))

    locs_pairs_per_depth = list(locs_pairs_per_depth)
    urls_per_depth = map(lambda x:
                         client.getBrowseQuotesURL(country='UK',
                                                   currency='GBP',
                                                   locale='en-GB',
                                                   origin=x[0],
                                                   destination=x[1],
                                                   outbound_dt=out_param),
                         locs_pairs_per_depth)

    return dict(zip(locs_pairs_per_depth,
                    client.launch_reqs(urls_per_depth, locs_pairs_per_depth)))


def calc_min_itinerary(flight_data_perms):
    min_price, min_itinerary = float('inf'), None
    for flight_data_perm in flight_data_perms:
        price = sum(x['flight_data']['price'] for x in flight_data_perm)
        if price < min_price:
            min_price, min_itinerary = price, flight_data_perm

    return flight_data_perm


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

        pair_to_data_dict = collect_data_by_leg(perms, idx, out_param)

        for permIdx, perm in enumerate(perms):
            locations = (perm[idx], perm[idx + 1])
            flight_data = pair_to_data_dict.get(locations)

            if perm[idx + 1] == 'anywhere':
                perms[permIdx][idx + 1] = \
                    flight_data['destination']['SkyscannerCode']

            flight_data_perms[permIdx].append({
                'locations': locations,
                'flight_data': flight_data
            })

    return calc_min_itinerary(flight_data_perms)


@app.route("/createItinerary", methods=['POST'])
def pricesEndpoint():
    # data = eval(request.form.keys()[0])
    data = request.form
    country = data.get('country', 'UK')
    currency = data.get('currency', 'GBP')
    locale = data.get('locale', 'en-GB')
    origin = data.get('origin')
    destination = data.get('destination', 'anywhere')
    num_stops = int(data.get('num_stops', 0))
    wish_list = [e.strip() for e in
                 str(data.get('wish_list', '')).split(',')]
    start_date = data['start_date']
    end_date = data['end_date']

    min_trip = generate_perms(origin=origin,
                              destination=destination,
                              num_stops=num_stops,
                              wish_list=wish_list,
                              out_str=start_date,
                              in_str=end_date)

    return jsonify(min_trip)


if __name__ == "__main__":
    app.run(debug=True)
