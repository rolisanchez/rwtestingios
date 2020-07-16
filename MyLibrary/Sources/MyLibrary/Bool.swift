public extension Bool {
    init?<Integer: BinaryInteger>(bit: Integer){
        switch bit {
            case 0:
                self = false
            case 1:
                self = true
            default:
                return nil
        }
    }
}
