import grequests as gre
import json


class SkyScannerApiClient:

    BASE_URL = 'http://partners.api.skyscanner.net/apiservices'

    def __init__(self, key):
        self._key = key

    def getBrowseQuotesURL(self,
                           country,
                           currency,
                           locale,
                           origin,
                           destination,
                           outbound_dt,
                           inbound_dt=''):
        return SkyScannerApiClient.BASE_URL \
            + '/browsequotes/v1.0/{}/{}/{}/{}/{}/{}/{}?apiKey={}'.format(
                country,
                currency,
                locale,
                origin,
                destination,
                outbound_dt,
                inbound_dt,
                self._key
            )

    def get_place_from_id(self, places, id):
        for place in places:
            if place['PlaceId'] == id:
                return place
        return {}

    def parse_quotes_data(self, data):
        min_price, min_quote = float('inf'), None
        for quote in data['Quotes']:
            if quote['MinPrice'] < min_price:
                min_price = quote['MinPrice']
                min_quote = quote

        originPlace = self.get_place_from_id(data['Places'],
                                             min_quote['OutboundLeg']['OriginId'])
        destPlace = self.get_place_from_id(data['Places'],
                                           min_quote['OutboundLeg']['DestinationId'])
        return {
            'price': min_quote['MinPrice'],
            'origin': originPlace,
            'destination': destPlace,
            'datetime': min_quote['OutboundLeg']['DepartureDate']
        }

    def launch_reqs(self, urls, locs_pairs):
        result = []

        rs = (gre.get(u) for u in urls)
        for idx, response in enumerate(gre.map(rs)):
            if response.status_code != 200:
                result.append(None)
            else:
                parsed_data = self.parse_quotes_data(
                    json.loads(response._content))
                result.append(parsed_data)

        return result
