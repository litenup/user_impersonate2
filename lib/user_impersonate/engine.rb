module UserImpersonate
  class Engine < ::Rails::Engine
    isolate_namespace UserImpersonate
    
    initializer "user_impersonate.devise_helpers" do
      if Object.const_defined?("Devise")
        require "user_impersonate/devise_helpers"
        Devise.include_helpers(UserImpersonate::DeviseHelpers)
      end
    end

    initializer 'user_impersonate.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper UserImpersonate::ApplicationHelper
      end
    end

    config.to_prepare do
      ::ApplicationController.helper(UserImpersonate::ApplicationHelper)
      ::ApplicationController.send(:include, UserImpersonate::ApplicationHelper)
    end
  end
end
