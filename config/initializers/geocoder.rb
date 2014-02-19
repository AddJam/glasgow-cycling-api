Geocoder.configure(

    # geocoding service
    :lookup => :nominatim,
    # :lookup => :mapquest,
    # :api_key => "Fmjtd%7Cluur2968nq%2Cbw%3Do5-90rs50",

    # set default units to kilometers:
    :units => :km,

    # caching
    :cache => Redis.new,
    :cache_prefix => "GEOCODER-"
)
