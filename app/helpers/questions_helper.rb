module QuestionsHelper

    def explain_answer_class selected_id, answer_id, answer_is_correct
        if answer_is_correct
            return "list-group-item-success"
        elsif answer_id == selected_id 
            return "list-group-item-danger"
        else
            return ""
        end
    end
end
