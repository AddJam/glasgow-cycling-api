Geocoder.configure(

    # geocoding service
    :lookup => :nominatim,

    # set default units to kilometers:
    :units => :km,

    # caching
    :cache => Redis.new,
    :cache_prefix => "GEOCODER-"
)
