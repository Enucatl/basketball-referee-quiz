module QuestionGenerator
    def self.generate_questions question_template, answers, explanation, template_substitutions
        #generate all possible questions from the template with random
        #answers. The question template is substituted with all the possible
        #cases (using Array#product to get the cartesian product) from
        #template_substitutions.
        #Answers is an array of arrays from which different possibilities
        #for the answers are sampled. The first element is the right answer.
        #Explanation is a reference or comment shown in case that the user
        #wants to know why an answer is correct.
        #template_substitutions must have the same length as the number of
        #required parameters in the question_template
        if template_substitutions.length > 1
            template_substitutions[0].product(*template_substitutions[1..-1]).map do |subs|
                {
                    question: question_template % subs,
                    explanation: explanation,
                    answers: answers.map(&:sample)
                }
            end
        elsif template_substitutions.length == 1
            template_substitutions.map do |sub|
                {
                    question: question_template % sub,
                    explanation: explanation,
                    answers: answers.map(&:sample)
                }
            end
        else
            [{
                question: question_template,
                explanation: explanation,
                answers: answers.map(&:sample)
            }]
        end
    end
end
