extension AccountService {
    public func createFriendList() {
        let friendlist = Friendlist(id: userID, friends: [])
        guard let data = friendlist.data else { return }
        
        DefaultAPI.userfriendListsPut(userfriendList: data) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else { }
        }
    }
    
    public func createLocation(xCoord: String, yCoord: String) {
        let location = Location(id: "location_" + userID, name: userName, xCoord: xCoord, yCoord: yCoord)
        guard let data = location.data else { return }
        
        DefaultAPI.currentPositionsPut(currentPosition: data) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
    }
    
    public func updateLocation(xCoord: String, yCoord: String) {
        if userID == "" {
            return
        }
        let location = Location(id: "location_" + userID, name: userName, xCoord: xCoord, yCoord: yCoord)
        guard let data = location.data else { return }
        
        DefaultAPI.currentPositionsPut(currentPosition: data) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
    }
    
    func createUserTrackedPaths() {
        let trackedPaths = TrackedPathModel(id: userID, tracks: [])
        guard let data = trackedPaths.data else { return }
        DefaultAPI.userTrackedPathsPut(userTrackedPaths: data) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
    }
    
    func createLeaderBoardEntity() {
        let leaderBoard = LeaderBoard(id: userID, name: userName, distance: 0.0, totalTimeInSeconds: 0.0)
        
        DefaultAPI.leaderBoardsPut(leaderBoard: leaderBoard) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
    }
    
    func updateLeaderboard(time: Double, distance: Double) {
        if userID == "" {
            return
        }
        let leaderBoard = LeaderBoard(id: userID, name: userName, distance: distance, totalTimeInSeconds: time)
        
        DefaultAPI.leaderBoardsPut(leaderBoard: leaderBoard) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
    }
    
    func addUser(email: String) {
        if userID == "" {
            return
        }
        let user = User(id: userID, name: userName, email: email)
        
        DefaultAPI.usersPut(user: user) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
    }
}
