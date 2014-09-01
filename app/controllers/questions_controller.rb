class QuestionsController < ApplicationController

    before_action :authenticate_user!

    def show
        @question = Question.find params[:id] 
        @answers = @question.answers.shuffle
        @t0 = Result::get_t0
        @if_win = Glicko2::update_rating(
            current_user.rating,
            current_user.deviation,
            current_user.volatility,
            @question.rating,
            @question.deviation, 1)[0] - current_user.rating
        @if_lose = Glicko2::update_rating(
            current_user.rating,
            current_user.deviation,
            current_user.volatility,
            @question.rating,
            @question.deviation, 0)[0] - current_user.rating
        mu, _ = Glicko2::scale_old2new(
                current_user.rating,
                current_user.deviation)
        mu_opp, phi_opp = Glicko2::scale_old2new(
                @question.rating,
                @question.deviation)
        @t_even = Result::get_time(Glicko2::e(mu, mu_opp, phi_opp))
    end

    def random
        @question = Question.order_by_rand.first
        redirect_to @question
    end

    def check
        answer = Answer.find(params[:answer_id])
        question = answer.question
        if answer.is_correct?
            result = Result::get_result params[:time].to_f
        else
            result = 0
        end
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
        if answer.is_correct? and current_user.break_on_success
            redirect_to action: "explain", question_id: question.id, selected_answer_id: params[:answer_id]
        elsif not answer.is_correct? and current_user.break_on_failure
            redirect_to action: "explain", question_id: question.id, selected_answer_id: params[:answer_id]
        elsif params[:is_last_question]
            redirect_to root_path
        else
            redirect_to action: "random"
        end
    end

    def explain
        @question = Question.find params[:question_id]
        @answers = @question.answers
        @selected_answer_id = params[:selected_answer_id].to_i
    end
end
