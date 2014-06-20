class HomeController < ApplicationController
  def index
    @num_routes = Route.count
    @sections = [
        {
            title: "Route Search",
            endpoints: [
                {
                    route: '/routes.json',
                    test_endpoint: 'routes.json',
                    type: 'GET',
                    description: "Search for routes, filterable by location",
                    input: [
                        {
                            name: 'user_only',
                            value: false,
                            required: false,
                            in_request: false
                        },
                        {
                            name: 'start_maidenhead',
                            value: 'FA00BD21',
                            required: false,
                            in_request: false
                        },
                        {
                            name: 'end_maidenhead',
                            value: 'FA00BD25',
                            required: false,
                            in_request: false
                        },
                        {
                            name: 'source_lat',
                            value: '55.429',
                            required: false,
                            in_request: false
                        },
                        {
                            name: 'source_long',
                            value: '-4.295',
                            required: false,
                            in_request: false
                        },
                        {
                            name: 'dest_lat',
                            value: '55.425',
                            required: false,
                            in_request: false
                        },
                        {
                            name: 'dest_long',
                            value: '-4.295',
                            required: false,
                            in_request: false
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
                    test_endpoint: 'signup.json',
                    test_output: '{ "user_token": "zAj1U5YtPsjGefs7QB-l" }',
                    type: 'POST',
                    description: "Create a new user account.",
                    input: [
                        {
                            name: 'user[email]',
                            value: 'user@example.com',
                            required: true,
                            in_request: true
                        },
                        {
                            name: 'user[password]',
                            value: 'newpassword',
                            required: true,
                            in_request: true
                        },
                        {
                            name: 'user[first_name]',
                            value: 'John',
                            required: true,
                            in_request: true
                        },
                        {
                            name: 'user[last_name]',
                            value: 'Smith',
                            required: true,
                            in_request: true
                        },
                        {
                            name: 'user[year_of_birth]',
                            value: '1990',
                            required: true,
                            in_request: true
                        },
                        {
                            name: 'user[gender]',
                            value: '(undisclosed|male|female)', #TODO single value in output
                            required: true,
                            in_request: true
                        }
                    ]
                },
                {
                    route: '/signin.json',
                    test_endpoint: 'signin.json',
                    test_output: '{ "user_token": "dkf-tadUuAMrTfxjwbGl" }',
                    type: 'GET',
                    description: "Signin and obtain authentication token for user account",
                    input: [
                        {
                            name: 'user[email]',
                            value: 'user@example.com',
                            required: true,
                            in_request: true
                        },
                        {
                            name: 'user[password]',
                            value: 'password',
                            required: true,
                            in_request: true
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
                    test_endpoint: 'stats/hours.json',
                    test_output: '{
                        "overall": {
                          "distance": 0.221798945812421,
                          "avg_speed": 114.41249999999998,
                          "min_speed": 113.904,
                          "max_speed": 114.948,
                          "routes_started": 13,
                          "routes_completed": 0
                        },
                        "hours": [
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400313600
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400317200
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400320800
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400324400
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400328000
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400331600
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400335200
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400338800
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400342400
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400346000
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400349600
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400353200
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400356800
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400360400
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400364000
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400367600
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400371200
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400374800
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400378400
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400382000
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400385600
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400389200
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400392800
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400396400
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400400000
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400403600
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400407200
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400410800
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400414400
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400418000
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400421600
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400425200
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400428800
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400432400
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400436000
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400439600
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400443200
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400446800
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400450400
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400454000
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400457600
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400461200
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400464800
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400468400
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400472000
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400475600
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400479200
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400482800
                          },
                          {
                            "distance": 0.221798945812421,
                            "avg_speed": 114.41249999999998,
                            "min_speed": 113.904,
                            "max_speed": 114.948,
                            "routes_started": 13,
                            "routes_completed": 0,
                            "time": 1400486400
                          },
                          {
                            "distance": 0,
                            "avg_speed": 0,
                            "min_speed": 0,
                            "max_speed": 0,
                            "routes_started": 0,
                            "routes_completed": 0,
                            "time": 1400490000
                          }
                        ]
                      }',
                    type: 'GET',
                    description: "Stats for the authenticated user, per hour.",
                    input: [
                        {
                            name: "num_hours",
                            value: "50",
                            required: true,
                            in_request: true
                        }
                    ]
                },
                {
                    route: '/stats/days.json',
                    test_endpoint: 'stats/days.json',
                    test_output: '{
                          "overall": {
                            "distance": 0.307071410471152,
                            "avg_speed": 77.16266666666667,
                            "min_speed": 27.108,
                            "max_speed": 91.584,
                            "routes_started": 12,
                            "routes_completed": 12
                          },
                          "days": [
                            {
                              "distance": 0,
                              "avg_speed": 0,
                              "min_speed": 0,
                              "max_speed": 0,
                              "routes_started": 0,
                              "routes_completed": 0,
                              "time": 1401926400
                            },
                            {
                              "distance": 0.307071410471152,
                              "avg_speed": 77.16266666666667,
                              "min_speed": 27.108,
                              "max_speed": 91.584,
                              "routes_started": 12,
                              "routes_completed": 12,
                              "time": 1402012800
                            }
                          ]
                        }',
                    type: 'GET',
                    description: "Stats for the authenticated user, per day.",
                    input: [
                        {
                            name: "num_days",
                            value: "2",
                            required: true,
                            in_request: true
                        }
                    ]
                },
                {
                    route: '/stats/weeks.json',
                    test_endpoint: 'stats/weeks.json',
                    test_output: '{
                      "overall": {
                        "distance": 0.0,
                        "avg_speed": 57.24,
                        "min_speed": 57.24,
                        "max_speed": 57.24,
                        "routes_started": 2,
                        "routes_completed": 2
                      },
                      "weeks": [
                        {
                          "distance": 0,
                          "avg_speed": 0,
                          "min_speed": 0,
                          "max_speed": 0,
                          "routes_started": 0,
                          "routes_completed": 0,
                          "time": 1396224000
                        },
                        {
                          "distance": 0,
                          "avg_speed": 0,
                          "min_speed": 0,
                          "max_speed": 0,
                          "routes_started": 0,
                          "routes_completed": 0,
                          "time": 1396828800
                        },
                        {
                          "distance": 0,
                          "avg_speed": 0,
                          "min_speed": 0,
                          "max_speed": 0,
                          "routes_started": 0,
                          "routes_completed": 0,
                          "time": 1397433600
                        },
                        {
                          "distance": 0,
                          "avg_speed": 0,
                          "min_speed": 0,
                          "max_speed": 0,
                          "routes_started": 0,
                          "routes_completed": 0,
                          "time": 1398038400
                        },
                        {
                          "distance": 0,
                          "avg_speed": 0,
                          "min_speed": 0,
                          "max_speed": 0,
                          "routes_started": 0,
                          "routes_completed": 0,
                          "time": 1398643200
                        },
                        {
                          "distance": 0,
                          "avg_speed": 0,
                          "min_speed": 0,
                          "max_speed": 0,
                          "routes_started": 0,
                          "routes_completed": 0,
                          "time": 1399248000
                        },
                        {
                          "distance": 0,
                          "avg_speed": 0,
                          "min_speed": 0,
                          "max_speed": 0,
                          "routes_started": 0,
                          "routes_completed": 0,
                          "time": 1399852800
                        },
                        {
                          "distance": 0,
                          "avg_speed": 0,
                          "min_speed": 0,
                          "max_speed": 0,
                          "routes_started": 0,
                          "routes_completed": 0,
                          "time": 1400457600
                        },
                        {
                          "distance": 0,
                          "avg_speed": 0,
                          "min_speed": 0,
                          "max_speed": 0,
                          "routes_started": 0,
                          "routes_completed": 0,
                          "time": 1401062400
                        },
                        {
                          "distance": 0.0,
                          "avg_speed": 57.24,
                          "min_speed": 57.24,
                          "max_speed": 57.24,
                          "routes_started": 2,
                          "routes_completed": 2,
                          "time": 1401667200
                        }
                      ]
                    }',
                    type: 'GET',
                    description: "Stats for the authenticated user, per week.",
                    input: [
                        {
                            name: "num_weeks",
                            value: "3",
                            required: true,
                            in_request: true
                        }
                    ]
                }
            ]
        },
        {
            title: "Route Capture",
            endpoints: [
                {
                route: '/routes.json',
                test_endpoint: 'routes.json',
                type: 'POST',
                description: 'Submit a new route to the API. Route will be trimmed to conform to *fuzzy* zones. Mimumum leangth 500m',
                input: [
                        {
                            name: "points[kph]",
                            value: "6.02",
                            required: true,
                            in_request: true
                        },
                        {
                            name: "points[course]",
                            value: "178.0",
                            required: true,
                            in_request: true
                        },
                        {
                            name: "points[time]",
                            value: "1402046642",
                            required: true,
                            in_request: true
                        },
                        {
                            name: "horizontal_accuracy",
                            value: 5,
                            required: true,
                            in_request: true
                        },
                        {
                            name: "vertical_accuracy",
                            value: 5,
                            required: true,
                            in_request: true
                        },
                        {
                            name: "altitude",
                            value: 2,
                            required: true,
                            in_request: true
                        },
                        {
                            name: "long",
                            value: 55.5,
                            required: true,
                            in_request: true
                        },
                        {
                            name: "lat",
                            value: -4.5,
                            required: true,
                            in_request: true
                        },
                    ]
                }
            ]
        },
        {
            title: "Route Details",
            endpoints: [
                {
                route: '/routes/find/:id.json',
                test_endpoint: 'routes/find/1.json',
                type: 'GET',
                description: 'Get the full route details for a given route id. This has each route point collected by the user.',
                input: [
                    {
                        name: "id",
                        value: "1",
                        required: true
                    }
                ]
            }
            ]
        }
    ]
    end
end
