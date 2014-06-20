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
                            required: true,
                            in_request: true
                        },
                        {
                            name: 'dest_maidenhead',
                            value: 'FA00BD25',
                            required: false,
                            in_request: true
                        }
                    ],
                    output: [
                        {

                        }
                    ]
                }
            ]
         },
        {
            title: "Statistics",
            endpoints: [
                {
                    route: '/stats/days.json',
                    test_endpoint: '/stats/days.json',
                    type: 'GET',
                    input: [
                        {
                            name: "num_days",
                            value: "5",
                            required: true
                        }
                    ]
                },
                {
                    route: '/stats/weeks.json',
                    test_endpoint: '/stats/weeks.json',
                    type: 'GET',
                    input: [
                        {
                            name: "num_weeks",
                            value: "3",
                            required: true
                        }
                    ]
                },
                {
                    route: '/stats/months.json',
                    test_endpoint: '/stats/months.json',
                    type: 'GET',
                    input: [
                        {
                            name: "num_months",
                            value: "2",
                            required: true
                        }
                    ]
                }
            ]
        },
        {
            title: "Route Capture",
            endpoints: []
        }
    ]
    end
end
