class QuestionsController < ApplicationController
    def random
        @question = Question.order_by_rand.first
    end

    def check
        answer = Answer.find(params[:answer_id])
        if answer.is_correct?
            puts "RIGHT!!!"
        else
            puts "WRONG"
        end
        redirect_to action: "random"
    end
end
