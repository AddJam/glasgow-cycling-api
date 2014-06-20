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
                    description: "Search for routes, filterable by location",
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
                }
            ]
         },
        {
            title: "Authentication",
            endpoints: [
                {
                    route: '/signup.json',
                    test_endpoint: '/signup.json',
                    test_output: '{ "user_token": "zAj1U5YtPsjGefs7QB-l" }',
                    type: 'POST',
                    description: "Create a new user account.",
                    input: [
                        {
                            name: 'user[email]',
                            value: 'user@example.com',
                            required: true
                        },
                        {
                            name: 'user[password]',
                            value: 'newpassword',
                            required: true
                        },
                        {
                            name: 'user[first_name]',
                            value: 'John',
                            required: true
                        },
                        {
                            name: 'user[last_name]',
                            value: 'Smith',
                            required: true
                        },
                        {
                            name: 'user[year_of_birth]',
                            value: '1990',
                            required: true
                        },
                        {
                            name: 'user[gender]',
                            value: '(undisclosed|male|female)',
                            required: true
                        }
                    ]
                }
            ]
        },
        {
            title: "Statistics",
            endpoints: [
                {
                    route: '/stats/hours.json',
                    test_endpoint: '/stats/hours.json',
                    type: 'GET',
                    description: "Stats for the authenticated user, per hour.",
                    input: [
                        {
                            name: "num_hours",
                            value: "2",
                            required: true
                        }
                    ]
                },
                {
                    route: '/stats/days.json',
                    test_endpoint: '/stats/days.json',
                    type: 'GET',
                    description: "Stats for the authenticated user, per day.",
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
                    description: "Stats for the authenticated user, per week.",
                    input: [
                        {
                            name: "num_weeks",
                            value: "3",
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
