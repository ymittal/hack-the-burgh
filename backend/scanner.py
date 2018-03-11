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

    def parse_quotes_data(self, data):
        min_price, min_quote = float('inf'), None
        for quote in data['Quotes']:
            if quote['MinPrice'] < min_price:
                min_price = quote['MinPrice']
                min_quote = quote

        # TODO: add carrier data
        return {
            'price': min_quote['MinPrice'],
            'originId': min_quote['OutboundLeg']['OriginId'],
            'destId': min_quote['OutboundLeg']['DestinationId'],
            'datetime': min_quote['OutboundLeg']['DepartureDate']
        }

    def launch_reqs(self, urls):
        result = []

        rs = (gre.get(u) for u in urls)
        for response in gre.map(rs):
            if response.status_code != 200:
                result.append(None)
            else:
                parsed_data = self.parse_quotes_data(
                    json.loads(response._content))
                result.append(parsed_data)

        return result
