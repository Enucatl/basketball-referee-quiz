class StaticPagesController < ApplicationController
    def home
    end

    def guide
        @t0 = Result::get_t0
        @t1 = Result::get_t1
        @tau = Result::get_tau
    end

    def about
    end
end
