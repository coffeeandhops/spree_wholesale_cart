module GeocoderStub
  def self.stub_with(address)
    Geocoder.configure(lookup: :test)

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
