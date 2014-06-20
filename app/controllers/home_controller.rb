class HomeController < ApplicationController
  def index
    @num_routes = Route.count
    @sections = [
        {
            title: "Route Search",
            endpoints: [
                {
                    route: '/routes.json',
                    test_endpoint: '/routes.json',
                    type: 'GET',
                    input: [
                        {
                            name: 'source_maidenhead',
                            value: 'FA00BD21',
                            required: true
                        },
                        {
                            name: 'dest_maidenhead',
                            value: 'FA00BD25',
                            required: false
                        }
                    ],
                    output: [
                        {
                            name: "Street",
                            value: "Banana Road"
                        }
                    ]
                }
            ]
        },
        {
            title: "Statistics",
            endpoints: []
        },
        {
            title: "Route Capture",
            endpoints: []
        }
    ]
  end
end
