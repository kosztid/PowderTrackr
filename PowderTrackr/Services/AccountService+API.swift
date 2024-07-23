extension AccountService {
    public func updateLocation(xCoord: String, yCoord: String) {
        if userID == "" {
            return
        }
        let location = Location(id: "location_" + userID, name: userName, xCoord: xCoord, yCoord: yCoord)
        guard let data = location.data else { return }

        DefaultAPI.currentPositionsPut(currentPosition: data) { _, error in
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

        DefaultAPI.leaderBoardsPut(leaderBoard: leaderBoard) { _, error in
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

        DefaultAPI.usersPut(user: user) { _, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
    }
}
