require "controller/testing/kwargs/version"
require "rails/test_help"

module Controller
  module Testing
    module Kwargs
      ERROR_MESSAGE = 'Please use Rails 5 syntax. See: https://github.com/appfolio/controller-testing-kwargs'

      class <<self
        @action = :deprecation_warning

        attr_reader :action

        def deprecate
          @action = :deprecation_warning
        end

        def deprecated?
          @action == :deprecation_warning
        end

        def ignore
          @action = nil
        end

        def raise_exception
          @action = :raise_exceptioon
        end

        def raise_exception?
          @action == :raise_exceptioon
        end

        private

        def with_ignore
          previous_action = @action
          @action = nil
          begin
            yield
          ensure
            @action = previous_action
          end
        end
      end

      %i[get post patch put head delete].each do |method|
        define_method(method) do |action, *args|
          request_params = args[0]&.dup
          request_headers = args[1]&.dup

          old_method = false
          xhr = false
          if request_params && request_params.is_a?(Hash)
            xhr = request_params.delete(:xhr)
            if request_params[:params].is_a?(Hash)
              request_params.merge!(request_params.delete(:params) || {})
              request_headers = request_params.delete(:headers) || request_headers
            elsif request_params[:params]
              request_headers = request_params[:headers]
              request_params = request_params[:params]
            elsif request_params[:headers]
              request_headers = request_params[:headers]
              request_params = nil
            else
              old_method = true
            end
          elsif request_headers.is_a?(Hash)
            old_method = true
          end

          raise Exception, ERROR_MESSAGE if Controller::Testing::Kwargs.raise_exception? && old_method
          ActiveSupport::Deprecation.warn(ERROR_MESSAGE) if Controller::Testing::Kwargs.deprecated? && old_method

          Controller::Testing::Kwargs.send(:with_ignore) do
            return xhr(method, action, request_params, request_headers)
          end if xhr
          super(action, request_params, request_headers)
        end
      end

      def xhr(request_method, action, parameters = nil, *args)
        raise Exception ERROR_MESSAGE if Controller::Testing::Kwargs.raise_exception?
        ActiveSupport::Deprecation.warn(ERROR_MESSAGE) if Controller::Testing::Kwargs.deprecated?
        super(request_method, action, parameters, *args)
      end
    end
  end
end

ActionController::TestCase.prepend(Controller::Testing::Kwargs)
ActionDispatch::IntegrationTest.prepend(Controller::Testing::Kwargs)
