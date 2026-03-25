enum foodstaus {
    case expired 
    case expiringSoon
    case fresh
}

func checkExpiration(expirationDate: Date) -> FoodStatus {
    let today = Date()

    let differnece = Calander.current.dateComponents([.day], from: today, to: expirationDate)
    let days = difference.day ?? 0

    if days < 0 {
        return .expired
    } else if days <= 3 {
        return .expiringSoon
    } else {
        return .fresh
    }
}