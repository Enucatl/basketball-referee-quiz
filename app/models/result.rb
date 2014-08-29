module Result
    #In case of an unsolved problem the result of the user vs. problem
    #'match' will be 0:1. If a problem is solved, the result is depending on
    #the elapsed time. The first t0 seconds are for free and the result will
    #be 1:0. After t0 seconds the result is linearly decreasing with 1/2:1/2
    #at t1 seconds. After t1 seconds the decrease of the result is
    #exponential with constant tau
    @@t0 = 1
    @@t1 = 3
    @@delta = @@t1 - @@t0
    @@m = - 0.5 / @@delta
    @@tau = 5
    @@k = - 1 / @@tau

    def self.get_result(time)
        if time < @@t0
            return 1
        elsif time > @@t0 and time < @@t1
            return @@m * (time - @@t0) + 1
        else
            return 0.5 * Math.exp(@@k * (time - @@t1))
        end
    end

    def self.get_time(result)
        if result == 1
            return @@t0
        elsif result < 1 and result > 0.5
            return @@t0 + 2 * @@delta * (1 - result)
        else
            return @@t1 - @@tau * Math.log(2 * result) 
        end
    end

    def self.get_t0
        @@t0
    end
    def self.get_t1
        @@t1
    end
    def self.get_tau
        @@tau
    end
end
