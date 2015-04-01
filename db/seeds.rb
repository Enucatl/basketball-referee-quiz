# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless Rails.env.production?
  User.create(
    username: "guest",
    email: "guest@guest.com",
    password: "guest",
    password_confirmation: "guest",
    rating: 1500,
    deviation: 350,
    volatility: 0.06,
    break_on_success: false,
    break_on_failure: true
  )
end

if Rails.env.production?
  files = Dir.glob("/home/deploy/basketball-referee-generator/art*.json")
else
  files = ARGV[1..-1]
end

files.each do |filename|
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
      Question.find_or_initialize_by(text: q[:question]) do |question|
        question.update(
          text: q[:question],
          tag: File.basename(filename, ".json"),
          explanation: q[:explanation],
          rating: 1500,
          deviation: 350,
          volatility: 0.06
        )
        puts question.to_json
        Answer.where(question_id: question.id).each do |old_answer|
          answer.destroy
        end
        q[:answers].each_with_index do |a, i|
          question.answers.create(
            text: a,
            is_correct?: if i == 0 then true else false end)
        end
      end
    end
  end
end

p "database now has #{Question.count} questions and #{Answer.count} answers"
