module GeocoderStub
  def self.stub_with(address)
    Geocoder.configure(lookup: :test, ip_lookup: :test)

    results = [
      {
          'latitude' => 40.7143528,
          'longitude' => -74.0059731
      }
    ]
    queries = [address.full_address]
    queries.each { |q| Geocoder::Lookup::Test.add_stub(q, results) }
  end
end
Geocoder.configure(lookup: :test, ip_lookup: :test)
Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'coordinates'  => [40.7143528, -74.0059731],
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)