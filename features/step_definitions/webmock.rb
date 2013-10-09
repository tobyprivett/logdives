Given /^the geocoder service is running$/ do
  WebMock.disable_net_connect!(:allow_localhost => true)
  stub_request(:get, "http://maps.google.com/maps/api/geocode/json?language=en&latlng=,&sensor=false").
  with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
  to_return(:status => 200, :body => "", :headers => {})
end
