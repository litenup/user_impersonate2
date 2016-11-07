module UserImpersonate
  module ApplicationHelper
    def current_staff_user
      return unless session[:staff_user_id]
      staff_finder_method = config_value(UserImpersonate::Engine.config, :staff_finder, 'find').to_sym
      staff_class_name = config_value(UserImpersonate::Engine.config, :staff_class, 'User')
      staff_class = staff_class_name.constantize
      @staff_user ||= staff_class.send(staff_finder_method, session[:staff_user_id])
    end

    def method_missing method, *args, &block
      if method.to_s.end_with?('_path') or method.to_s.end_with?('_url')
        if main_app.respond_to?(method)
          main_app.send(method, *args)
        else
          super
        end
      else
        super
      end
    end

    def respond_to?(method)
      if method.to_s.end_with?('_path') or method.to_s.end_with?('_url')
        if main_app.respond_to?(method)
          true
        else
          super
        end
      else
        super
      end
    end

    private

    def config_value(config, sym, default)
      config.respond_to?(sym) ? (config.send(sym) || default) : default
    end
  end
end
