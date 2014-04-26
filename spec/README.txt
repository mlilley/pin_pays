
How To Run Tests
----------------

1. update spec_helper.rb with your pin payments testing secret key

2. optionally delete spec/fixtures/vcr/*.yml, if you want to run tests against
   the real pin payments api, instead of against previously captured api
   response fixtures.

3. run the tests
   $ rake test