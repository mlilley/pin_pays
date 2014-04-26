require_relative '../../spec_helper'


# todo:
#
#   - test api_get performs a request using a query string created from the
#     supplied query hash
#
#   - test api_post, api_put use the supplied body hash in the request body
#
#   - test api_get, api_put, api_post request using basic auth generated
#     from the secret key
#
#   - test api_response properly converts the api's json response data into
#     a hash
#
#   - test api_paginated_response properly converts the api's paginated type
#     responses into a hash with results and pagination keys
#
#   - test symbolize_keys actually converts a hash's keys from strings to
#     symbols, and does so recursively for values that are hashes, and hashes
#     inside array values
