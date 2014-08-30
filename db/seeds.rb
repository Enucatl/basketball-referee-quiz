# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(
    username: "CiccioPasticcio",
    email: "ciccio@pst.com",
    password: "FxE6YDOLR8omCm5leRdN",
    password_confirmation: "FxE6YDOLR8omCm5leRdN",
    rating: 1500,
    deviation: 350,
    volatility: 0.06,
    break_on_success: false,
    break_on_failure: true
)

ARGV[1..-1].each do |filename|
    text = File.read filename
    data = JSON.parse text
    data.each do |d|
        qs = QuestionGenerator.generate_questions(
            d["question_template"],
            d["answers"],
            d["explanation"],
            d["template_substitutions"]
        )
        qs.each do |q|
            question = Question.create(
                text: q[:question],
                tag: File.basename(filename, ".json"),
                explanation: q[:explanation],
                rating: 1500,
                deviation: 350,
                volatility: 0.06
            )
            puts question.to_json
            q[:answers].each_with_index do |a, i|
                question.answers.create(
                    text: a,
                    is_correct?: if i == 0 then true else false end)
            end
        end
    end
end
