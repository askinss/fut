class TestAnswersController < ApplicationController
	def new
		@case = Case.find_by_title params[:case_id] 
		@questions = Question.all
		@test_answer = TestAnswer.new
	end

	def create
		@test_answer= TestAnswer.new(params[:test_answer])
		@test_answer.result = TestAnswer.calculate_fair_use(@test_answer)
		@test_answer.save

		unless params[:case_id]
			redirect_to @test_answer
		else
			@c = Case.find(params[:case_id])
			if  @c.court_decision.nil?
				@c.court_decision = @test_answer
				@c.save 
				redirect_to case_path(@c.title)
			else
				@ca = CaseAnswer.new(:test_answer_id => @test_answer.id,:case_id => @c.id)
				@ca.owner = Visitor.last
				@ca.save
				redirect_to case_case_answer_path(@c.title,@ca)				
			end
		end				
	end
	def show
		@test_answer= TestAnswer.find(params[:id])
		@answers_of_test=[@test_answer.purpose,@test_answer.character,@test_answer.use,@test_answer.nature,@test_answer.amount,@test_answer.impact] 
		@result = @test_answer.result ? "Fair Use" : "Not Fair Use"	
		@fair_use_test= FairUseTest.new
	end

	def destroy
		@test_answer= TestAnswer.find(params[:id])
		@test_answer.destroy
		redirect_to home_path
	end
end
