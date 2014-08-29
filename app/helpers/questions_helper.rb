module QuestionsHelper

    def explain_answer_class selected_id, answer_id, answer_is_correct
        if answer_is_correct
            return "list-group-item-success"
        elsif selected_id == answer_id and not answer_is_correct
            return "list-group-item-danger"
        else
            return ""
        end
    end
end
