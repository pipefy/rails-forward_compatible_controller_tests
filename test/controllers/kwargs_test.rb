require 'test_helper'

class KwargsControllerTest < ActionController::TestCase
  def setup
    Rails::ForwardCompatibleControllerTests.raise_exception
  end

  %w[get post patch put head delete].each do |verb|
    define_method("test_#{verb}_old_params_only") do
      Rails::ForwardCompatibleControllerTests.ignore

      send(verb.to_sym, :test_kwargs, hello: 'world')
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert_nil assigns(:flash)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_params_only__allows_format_keyword") do
      send(verb.to_sym, :test_kwargs, format: :json)
      assert_equal({ 'format' => 'json' }, assigns(:params))
    end

    define_method("test_#{verb}_old_params_only__outputs_deprecation") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        send(verb.to_sym, :test_kwargs, hello: 'world')
      end
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert_nil assigns(:flash)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_params_only__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        send(verb.to_sym, :test_kwargs, hello: 'world')
      end
    end

    define_method("test_#{verb}_new_params_only") do
      send(verb.to_sym, :test_kwargs, params: { hello: 'world', session: { a: 'foo' } })
      assert_equal({ 'hello' => 'world', 'session' => { 'a' => 'foo' } }, assigns(:params))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert_nil assigns(:flash)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_body_only") do
      Rails::ForwardCompatibleControllerTests.ignore

      body = { hello: 'world' }.to_json

      send(verb.to_sym, :test_kwargs, body)
      assert_equal(body, request.env['RAW_POST_DATA'])
      assert_empty assigns(:params)
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert_nil assigns(:flash)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_body_only__outputs_deprecation") do
      Rails::ForwardCompatibleControllerTests.deprecate

      body = { hello: 'world' }.to_json

      assert_deprecated do
        send(verb.to_sym, :test_kwargs, body)
      end

      assert_equal(body, request.env['RAW_POST_DATA'])
      assert_empty assigns(:params)
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert_nil assigns(:flash)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_body_only__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        send(verb.to_sym, :test_kwargs, { hello: 'world' }.to_json)
      end
    end

    define_method("test_#{verb}_new_body_only") do
      body = { hello: 'world', session: { a: 'foo' } }.to_json

      send(verb.to_sym, :test_kwargs, body: body)

      assert_equal(body, request.env['RAW_POST_DATA'])
      assert_empty assigns(:params)
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert_nil assigns(:flash)
      refute assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_only") do
      Rails::ForwardCompatibleControllerTests.ignore

      xhr verb.to_sym, :test_kwargs, hello: 'world'
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert_nil assigns(:flash)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_only__outputs_deprecation") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        xhr verb.to_sym, :test_kwargs, hello: 'world'
      end
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert_nil assigns(:flash)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_only__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        xhr verb.to_sym, :test_kwargs, hello: 'world'
      end
    end

    define_method("test_xhr_#{verb}_new_params_only") do
      send(verb.to_sym, :test_kwargs, xhr: true, params: { hello: 'world' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert_nil assigns(:flash)
      assert assigns(:xhr)
    end

    define_method("test_#{verb}_old_session_only") do
      Rails::ForwardCompatibleControllerTests.ignore

      send(verb.to_sym, :test_kwargs, nil, sesh: 'shin')
      assert_equal('shin', assigns(:session))
      assert_equal({}, assigns(:params))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_session_only__outputs_deprecation") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        send(verb.to_sym, :test_kwargs, nil, sesh: 'shin')
      end
      assert_equal('shin', assigns(:session))
      assert_equal({}, assigns(:params))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_session_only__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        send(verb.to_sym, :test_kwargs, nil, sesh: 'shin')
      end
    end

    define_method("test_#{verb}_new_session_only") do
      send(verb.to_sym, :test_kwargs, session: { sesh: 'shin' })
      assert_equal('shin', assigns(:session))
      assert_equal({}, assigns(:params))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      refute assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_session_only") do
      Rails::ForwardCompatibleControllerTests.ignore

      xhr(verb.to_sym, :test_kwargs, nil, sesh: 'shin')
      assert_equal('shin', assigns(:session))
      assert_equal({}, assigns(:params))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_session_only__outputs_deprecation") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        xhr(verb.to_sym, :test_kwargs, nil, sesh: 'shin')
      end
      assert_equal('shin', assigns(:session))
      assert_equal({}, assigns(:params))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_session_only__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        xhr(verb.to_sym, :test_kwargs, nil, sesh: 'shin')
      end
    end

    define_method("test_xhr_#{verb}_new_session_only") do
      send(verb.to_sym, :test_kwargs, xhr: true, session: { sesh: 'shin' })
      assert_equal('shin', assigns(:session))
      assert_equal({}, assigns(:params))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      assert assigns(:xhr)
    end

    define_method("test_#{verb}_old_flash_only") do
      Rails::ForwardCompatibleControllerTests.ignore

      send(verb.to_sym, :test_kwargs, nil, nil, flashy: 'flash')
      assert_equal('flash', assigns(:flash))
      assert_equal({}, assigns(:params))
      assert_nil assigns(:hello_header)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_flash_only__outputs_deprecation") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        send(verb.to_sym, :test_kwargs, nil, nil, flashy: 'flash')
      end
      assert_equal('flash', assigns(:flash))
      assert_equal({}, assigns(:params))
      assert_nil assigns(:hello_header)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_flash_only__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        send(verb.to_sym, :test_kwargs, nil, nil, flashy: 'flash')
      end
    end

    define_method("test_#{verb}_new_flash_only") do
      send(verb.to_sym, :test_kwargs, flash: { flashy: 'flash' })
      assert_equal('flash', assigns(:flash))
      assert_equal({}, assigns(:params))
      assert_nil assigns(:hello_header)
      refute assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_flash_only") do
      Rails::ForwardCompatibleControllerTests.ignore

      xhr(verb.to_sym, :test_kwargs, nil, nil, flashy: 'flash')
      assert_equal('flash', assigns(:flash))
      assert_equal({}, assigns(:params))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_flash_only__outputs_deprecation") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        xhr(verb.to_sym, :test_kwargs, nil, nil, flashy: 'flash')
      end
      assert_equal('flash', assigns(:flash))
      assert_equal({}, assigns(:params))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_flash_only__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        xhr(verb.to_sym, :test_kwargs, nil, nil, flashy: 'flash')
      end
    end

    define_method("test_xhr_#{verb}_new_flash_only") do
      send(verb.to_sym, :test_kwargs, xhr: true, flash: { flashy: 'flash' })
      assert_equal('flash', assigns(:flash))
      assert_equal({}, assigns(:params))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_#{verb}_old_params_and_session") do
      Rails::ForwardCompatibleControllerTests.ignore

      send(verb.to_sym, :test_kwargs, { hello: 'world' }, { sesh: 'shin' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_params_and_session__outputs_deprecation") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        send(verb.to_sym, :test_kwargs, { hello: 'world' }, { sesh: 'shin' })
      end
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_params_and_session__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        send(verb.to_sym, :test_kwargs, { hello: 'world' }, { sesh: 'shin' })
      end
    end

    define_method("test_#{verb}_new_params_and_session") do
      send(verb.to_sym, :test_kwargs, params: { hello: 'world' }, session: { sesh: 'shin' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      refute assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_and_session") do
      Rails::ForwardCompatibleControllerTests.ignore

      xhr verb.to_sym, :test_kwargs, { hello: 'world' }, { sesh: 'shin' }
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_and_session__deprecated") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        xhr verb.to_sym, :test_kwargs, { hello: 'world' }, { sesh: 'shin' }
      end
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_and_session__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        xhr verb.to_sym, :test_kwargs, { hello: 'world' }, { sesh: 'shin' }
      end
    end

    define_method("test_xhr_#{verb}_new_params_and_session") do
      send(verb.to_sym, :test_kwargs, xhr: true, params: { hello: 'world' }, session: { sesh: 'shin' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_new_params_and_session__does_not_output_warning") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_not_deprecated do
        send(verb.to_sym, :test_kwargs, xhr: true, params: { hello: 'world' }, session: { sesh: 'shin' })
      end
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:flash)
      assert assigns(:xhr)
    end

    define_method("test_#{verb}_old_params_and_flash") do
      Rails::ForwardCompatibleControllerTests.ignore

      send(verb.to_sym, :test_kwargs, { hello: 'world' }, nil, { flashy: 'flash' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_params_and_flash__outputs_deprecation") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        send(verb.to_sym, :test_kwargs, { hello: 'world' }, nil, { flashy: 'flash' })
      end
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_params_and_flash__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        send(verb.to_sym, :test_kwargs, { hello: 'world' }, nil, { flashy: 'flash' })
      end
    end

    define_method("test_#{verb}_new_params_and_flash") do
      send(verb.to_sym, :test_kwargs, params: { hello: 'world' }, flash: { flashy: 'flash' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      refute assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_and_flash") do
      Rails::ForwardCompatibleControllerTests.ignore

      xhr verb.to_sym, :test_kwargs, { hello: 'world' }, nil, { flashy: 'flash' }
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_and_flash__deprecated") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        xhr verb.to_sym, :test_kwargs, { hello: 'world' }, nil, { flashy: 'flash' }
      end
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_and_flash__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        xhr verb.to_sym, :test_kwargs, { hello: 'world' }, nil, { flashy: 'flash' }
      end
    end

    define_method("test_xhr_#{verb}_new_params_and_flash") do
      send(verb.to_sym, :test_kwargs, xhr: true, params: { hello: 'world' }, flash: { flashy: 'flash' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_new_params_and_flash__does_not_output_warning") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_not_deprecated do
        send(verb.to_sym, :test_kwargs, xhr: true, params: { hello: 'world' }, flash: { flashy: 'flash' })
      end
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert_nil assigns(:session)
      assert assigns(:xhr)
    end

    define_method("test_#{verb}_old_session_and_flash") do
      Rails::ForwardCompatibleControllerTests.ignore

      send(verb.to_sym, :test_kwargs, nil, { sesh: 'shin' }, { flashy: 'flash' })
      assert_equal({}, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_session_and_flash__outputs_deprecation") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        send(verb.to_sym, :test_kwargs, nil, { sesh: 'shin' }, { flashy: 'flash' })
      end
      assert_equal({}, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_session_and_flash__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        send(verb.to_sym, :test_kwargs, nil, { sesh: 'shin' }, { flashy: 'flash' })
      end
    end

    define_method("test_#{verb}_new_session_and_flash") do
      send(verb.to_sym, :test_kwargs, session: { sesh: 'shin' }, flash: { flashy: 'flash' })
      assert_equal({}, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      refute assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_session_and_flash") do
      Rails::ForwardCompatibleControllerTests.ignore

      xhr verb.to_sym, :test_kwargs, nil, { sesh: 'shin' }, { flashy: 'flash' }
      assert_equal({}, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_session_and_flash__deprecated") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        xhr verb.to_sym, :test_kwargs, nil, { sesh: 'shin' }, { flashy: 'flash' }
      end
      assert_equal({}, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_session_and_flash__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        xhr verb.to_sym, :test_kwargs, { sesh: 'shin' }, { flashy: 'flash' }
      end
    end

    define_method("test_xhr_#{verb}_new_session_and_flash") do
      send(verb.to_sym, :test_kwargs, xhr: true, session: { sesh: 'shin' }, flash: { flashy: 'flash' })
      assert_equal({}, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_new_session_and_flash__does_not_output_warning") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_not_deprecated do
        send(verb.to_sym, :test_kwargs, xhr: true, session: { sesh: 'shin' }, flash: { flashy: 'flash' })
      end
      assert_equal({}, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_#{verb}_old_params_and_session_and_flash") do
      Rails::ForwardCompatibleControllerTests.ignore

      send(verb.to_sym, :test_kwargs, { hello: 'world' }, { sesh: 'shin' }, { flashy: 'flash' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_params_and_session_and_flash__outputs_deprecation") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        send(verb.to_sym, :test_kwargs, { hello: 'world' }, { sesh: 'shin' }, { flashy: 'flash' })
      end
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_old_params_and_session_and_flash__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        send(verb.to_sym, :test_kwargs, { hello: 'world' }, { sesh: 'shin' }, { flashy: 'flash' })
      end
    end

    define_method("test_#{verb}_new_params_and_session_and_flash") do
      send(verb.to_sym, :test_kwargs, params: { hello: 'world' }, session: { sesh: 'shin' }, flash: { flashy: 'flash' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_new_params_and_session_and_flash_and_body") do
      session = { sesh: 'shin' }
      params = { hello: 'world' }
      flash = { flashy: 'flash' }
      body = { foo: 'bar' }.to_json

      send(verb.to_sym, :test_kwargs, params: params, session: session, flash: flash, body: body)
      assert_equal(params.stringify_keys, assigns(:params))
      assert_equal(body, request.env['RAW_POST_DATA'])
      assert_equal(session[:sesh], assigns(:session))
      assert_equal(flash[:flashy], assigns(:flash))
      assert_nil assigns(:hello_header)
      refute assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_and_session_and_flash") do
      Rails::ForwardCompatibleControllerTests.ignore

      xhr verb.to_sym, :test_kwargs, { hello: 'world' }, { sesh: 'shin' }, { flashy: 'flash' }
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_and_session_and_flash__deprecated") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        xhr verb.to_sym, :test_kwargs, { hello: 'world' }, { sesh: 'shin' }, { flashy: 'flash' }
      end
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_and_session_and_flash__raises_exception") do
      assert_raise_in_rails_4(Exception) do
        xhr verb.to_sym, :test_kwargs, { hello: 'world' }, { sesh: 'shin' }, { flashy: 'flash' }
      end
    end

    define_method("test_xhr_#{verb}_new_params_and_session_and_flash") do
      send(verb.to_sym, :test_kwargs, xhr: true, params: { hello: 'world' }, session: { sesh: 'shin' }, flash: { flashy: 'flash' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_new_params_and_session_and_format") do
      send(verb.to_sym, :test_kwargs, format: :json, params: { session: { a: "foo" } }, xhr: true)
      assert_equal({ 'session' => { 'a' => 'foo' }, 'format' => 'json' }, assigns(:params))
      assert_nil assigns(:session)
      assert_nil assigns(:flash)
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_new_params_and_session_and_flash__does_not_output_warning") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_not_deprecated do
        send(verb.to_sym, :test_kwargs, xhr: true, params: { hello: 'world' }, session: { sesh: 'shin' }, flash: { flashy: 'flash' })
      end
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('shin', assigns(:session))
      assert_equal('flash', assigns(:flash))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_#{verb}_as_without_format_keyword") do
      Rails::ForwardCompatibleControllerTests.ignore

      send(verb.to_sym, :test_kwargs, as: :json)
      assert_equal({ 'format' => 'json' }, assigns(:params))
    end

    define_method("test_#{verb}_as_with_format_keyword") do
      Rails::ForwardCompatibleControllerTests.ignore

      send(verb.to_sym, :test_kwargs, format: :html, as: :json)
      assert_equal({ 'format' => 'html' }, assigns(:params))
    end
  end
end
