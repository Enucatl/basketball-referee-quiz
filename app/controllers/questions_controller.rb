class QuestionsController < ApplicationController

    before_action :authenticate_user!

    def random
        @question = Question.order_by_rand.first
    end

    def check
        answer = Answer.find(params[:answer_id])
        question = answer.question
        puts question.rating
        if answer.is_correct?
            puts "RIGHT!!!"
            user_result = Result::get_result params[:time].to_f
        else
            puts "WRONG"
            user_result = 0
        end
        puts user_result
        redirect_to action: "random"
    end
end
