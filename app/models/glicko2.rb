module Glicko2

    @@tau = 0.3
    @@epsilon = 1e-6

    #http://www.glicko.net/glicko.html
    def self.scale_old2new rating, deviation
        mu = (rating - 1500) / 173.7178
        phi = deviation / 173.7178
        return mu, phi
    end

    def self.scale_new2old mu, phi
        rating = 173.7178 * mu + 1500
        deviation = 173.7178 * phi
        return rating, deviation
    end

    def self.g phi
        1 / Math.sqrt(1 + 3 * phi ** 2 / Math::PI ** 2)
    end

    def self.e mu, mu_opp, phi_opp
        1 / (1 + Math.exp(-g(phi_opp) * (mu - mu_opp)))
    end

    def self.v mu, mu_opp, phi_opp
        e_ = e mu, mu_opp, phi_opp
        1 / (g(phi_opp) ** 2 * e_ * (1 - e_))
    end

    def self.delta result, mu, mu_opp, phi_opp
        v(mu, mu_opp, phi_opp) * g(phi_opp) * (result - e(mu, mu_opp, phi_opp))
    end

    def self.new_volatility volatility, phi, delta_, v_
        a = Math.log(volatility ** 2)
        f = lambda do |x|
            ex = Math.exp x 
            up1 = ex * (delta_ ** 2 - phi ** 2 - v_ - ex)
            up2 = (x - a)
            down1 = 2 * (phi ** 2 + v_ + ex) ** 2
            down2 = @@tau ** 2
            up1 / down1 - up2 / down2
        end
        big_A = a
        if delta_ ** 2 > phi ** 2 + v_
            big_B = Math.log(delta_ ** 2 - phi ** 2 - v_)
        else
            k = 1
            while f.call(a - k * @@tau) < 0
                k += 1
            end
            big_B = a - k * @@tau
        end
        fA = f.call(big_A)
        fB = f.call(big_B)
        while (big_B - big_A).abs > @@epsilon
            big_C = big_A + (big_A - big_B) * fA / (fB - fA)
            fC = f.call(big_C)
            if fC * fB < 0
                big_A = big_B
                fA = fB
            else
                fA /= 2
            end
            big_B = big_C
            fB = fC
        end
        Math.exp(big_A / 2)
    end

    def self.new_rating mu, phi, result, new_volatility, v_, g_, e
        phi_star = Math.sqrt(phi ** 2 + new_volatility ** 2)
        new_phi = 1 / Math.sqrt(1 / phi_star ** 2 + 1 / v_)
        new_mu = mu + new_phi ** 2 * g_ * (result - e)
        return new_mu, new_phi
    end

    def self.update_rating rating, deviation, volatility, rating_opp, deviation_opp, result
        mu, phi = scale_old2new rating, deviation
        mu_opp, phi_opp = scale_old2new rating_opp, deviation_opp
        g_ = g phi
        e_ = e mu, mu_opp, phi_opp
        v_ = v mu, mu_opp, phi_opp
        delta_ = delta result, mu, mu_opp, phi_opp
        new_v = new_volatility volatility, phi, delta_, v_
        new_mu, new_phi = new_rating mu, phi, result, new_v, v_, g_, e_
        new_rating, new_deviation = scale_new2old new_mu, new_phi
        return new_rating, new_deviation, new_v
    end

end
