app = angular.module 'noiseAlert.app', ['message.resource']

app.config ['$interpolateProvider',
    ($interpolateProvider)->
        $interpolateProvider.startSymbol('{[{')
        $interpolateProvider.endSymbol('}]}')]

app.controller 'noiseController', ['$scope', '$interval', 'Message', ($scope, $interval, Message)->
    $scope.phoneNumber = '+1'

    class TopNoises
        constructor: (max_size)->
            @max_size = max_size
            @storage = []
            @changed = false

        push: (newEntry)->
            @storage.push newEntry
            @storage.sort((a,b)-> b.cumulativeVolume - a.cumulativeVolume)
            if @storage.length > @max_size
                popedEntry = @storage.pop()
                if popedEntry != newEntry
                    @changed = true
            else
                @changed = true                        
        clear: ()->
            @changed = false

    # describe 'TopNoises', ()->
    #     topNoises = {}
    #     beforeEach (()->
    #         topNoises = new TopNoises(3))

    #     it 'should keep 3 highest entries, sorted', ()->
    #         entries = []
    #         entries.push
    #             cumulativeVolume: 10
    #             timestamp: 'nov 10'
    #         entries.push                
    #             cumulativeVolume: 7
    #             timestamp: 'nov 10'
    #         entries.push
    #             cumulativeVolume: 40
    #             timestamp: 'nov 10'
    #         entries.push
    #             cumulativeVolume: 21
    #             timestamp: 'nov 10'
                
    #         topNoises.push entries[0]
    #         expect(topNoises.changed).toBe(true)
    #         topNoises.push entries[2]
    #         topNoises.push entries[1]
    #         topNoises.push entries[3]

    #         expect(topNoises.storage.length).toBe(3)
    #         expect(topNoises.storage[0]).toEqual(entries[2])
    #         expect(topNoises.storage[1]).toEqual(entries[3])
    #         expect(topNoises.storage[2]).toEqual(entries[0])

    $scope.noiseData =
        instant: 0
        progress: 0
        cumulativeVolume: 0
        threshold: 0.2
        topNoises: new TopNoises(3)    

    timeoutId = $interval (()->
        $scope.noiseProgress = $scope.noiseData.progress
        $scope.instant = $scope.noiseData.instant
        if $scope.noiseData.topNoises.changed
            message = new Message
                text: "Top noises have changed"
                contacts: [$scope.phoneNumber]
            message.$send
                username: '408627'
                api_key: '0f2a9701964627b0317748402e33cffee97e77a6'
            $scope.noiseData.topNoises.clear()
        ),
        200
]
.config ['$resourceProvider', ($resourceProvider)->
  $resourceProvider.defaults.stripTrailingSlashes = false;
]
