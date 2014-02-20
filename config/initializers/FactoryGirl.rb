if Rails.env.test?
	class ActiveSupport::TestCase
		include FactoryGirl::Syntax::Methods
	end
end
