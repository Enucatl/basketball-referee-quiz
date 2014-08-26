class QuestionsController < ApplicationController
    def random
        @question = Question.order_by_rand.first
    end
end
