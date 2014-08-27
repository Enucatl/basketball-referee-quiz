class QuestionsController < ApplicationController

    before_action :authenticate_user!

    def random
        @question = Question.order_by_rand.first
    end

    def check
        answer = Answer.find(params[:answer_id])
        question = answer.question
        if answer.is_correct?
            puts "RIGHT!!!"
            result = Result::get_result params[:time].to_f
        else
            puts "WRONG"
            result = 0
        end
        puts current_user.to_json
        new_user_rating, new_user_deviation, new_user_volatility = Glicko2::update_rating(
            current_user.rating,
            current_user.deviation,
            current_user.volatility,
            question.rating,
            question.deviation,
            result)
        new_question_rating, new_question_deviation, new_question_volatility = Glicko2::update_rating(
            question.rating,
            question.deviation,
            question.volatility,
            current_user.rating,
            current_user.deviation,
            1 - result)
        current_user.update_attributes(
            rating: new_user_rating, 
            deviation: new_user_deviation,
            volatility: new_user_volatility)
        question.update_attributes(
            rating: new_question_rating,
            deviation: new_question_deviation,
            volatility: new_question_volatility)
        redirect_to action: "random"
    end
end
