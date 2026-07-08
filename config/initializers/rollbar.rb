Rollbar.configure do |config|
  # Without configuration, Rollbar is enabled in all environments.
  # To disable in specific environments, set config.enabled=false.

  config.access_token = 'a045b17c4757478385e1b7feb69e2106'

  # Here we'll disable in 'test':
  if Rails.env.test? || Rails.env.development?
    config.enabled = false
  end

  # By default, Rollbar will try to call the `current_user` controller method
  # to fetch the logged-in user object, and then call that object's `id`
  # method to fetch this property. To customize:
  # config.person_method = "my_current_user"
  # config.person_id_method = "my_id"

  # Additionally, you may specify the following:
  # config.person_username_method = "username"
  # config.person_email_method = "email"

  # If you want to attach custom data to all exception and message reports,
  # provide a lambda like the following. It should return a hash.
  # config.custom_data_method = lambda { {:some_key => "some_value" } }

  # Add exception class names to the exception_level_filters hash to
  # change the level that exception is reported at. Note that if an exception
  # has already been reported and logged the level will need to be changed
  # via the rollbar interface.
  # Valid levels: 'critical', 'error', 'warning', 'info', 'debug', 'ignore'
  # 'ignore' will cause the exception to not be reported at all.
  # config.exception_level_filters.merge!('MyCriticalException' => 'critical')
  #
  # You can also specify a callable, which will be called with the exception instance.
  # config.exception_level_filters.merge!('MyCriticalException' => lambda { |e| 'critical' })

  # Enable asynchronous reporting (uses girl_friday or Threading if girl_friday
  # is not installed)
  # config.use_async = true
  # Supply your own async handler:
  # config.async_handler = Proc.new { |payload|
  #  Thread.new { Rollbar.process_from_async_handler(payload) }
  # }

  # Enable asynchronous reporting (using sucker_punch)
  # config.use_sucker_punch

  # Enable delayed reporting (using Sidekiq)
  # config.use_sidekiq
  # You can supply custom Sidekiq options:
  # config.use_sidekiq 'queue' => 'default'

  # If your application runs behind a proxy server, you can set proxy parameters here.
  # If https_proxy is set in your environment, that will be used. Settings here have precedence.
  # The :host key is mandatory and must include the URL scheme (e.g. 'http://'), all other fields
  # are optional.
  #
  # config.proxy = {
  #   host: 'http://some.proxy.server',
  #   port: 80,
  #   user: 'username_if_auth_required',
  #   password: 'password_if_auth_required'
  # }

  # If you run your staging application instance in production environment then
  # you'll want to override the environment reported by `Rails.env` with an
  # environment variable like this: `ROLLBAR_ENV=staging`. This is a recommended
  # setup for Heroku. See:
  # https://devcenter.heroku.com/articles/deploying-to-a-custom-rails-environment
  config.environment = ENV['ROLLBAR_ENV'].presence || Rails.env

  # Filter non-actionable client errors out of the exception tracker.
  #
  # Bots constantly probe for paths that don't exist (POST /, OPTIONS /,
  # GET /app/etc/local.xml, HEAD /backup, path-traversal strings, malformed
  # multipart bodies, etc.). Rails handles all of these correctly — it returns
  # a 4xx — so they are not application bugs. At bot volume they generate
  # thousands of events that exhaust the error-tracking quota and bury real
  # errors. Drop them at the source.
  #
  # Tradeoff: this also silences a genuinely broken *internal* link (a typo'd
  # `link_to` that now 404s). That's acceptable — those surface in dev/test and
  # in user reports, and it's far cheaper than thousands of bot 404s.
  #
  # Note: we deliberately do NOT ignore ActiveRecord::RecordNotFound or
  # AbstractController::ActionNotFound — those can signal real bugs and stay
  # reportable.
  #
  # Rollbar matches these keys against `exception.class.name` exactly — there is
  # no walk up the ancestor chain (rollbar 3.x, notifier.rb#filtered_level) —
  # so each concrete class a bot can trigger must be listed by name.
  config.exception_level_filters.merge!(
    # No route matches [VERB] "/path" — bot probing for paths that don't exist.
    "ActionController::RoutingError" => "ignore",
    # Bots send garbage in the Accept header / URL (e.g. path-traversal probes
    # like "../../../etc/services", SQLi strings), which Rails rejects with a
    # 406 before routing.
    "ActionDispatch::Http::MimeNegotiation::InvalidType" => "ignore",
    # Malformed multipart bodies, bad parameter encoding, and invalid
    # query/path params. Rails wraps the underlying Rack/encoding error and
    # re-raises it under this single class, so the one key covers all three
    # ("Invalid request/query/path parameters: ...").
    "ActionController::BadRequest" => "ignore",
    # Malformed JSON (or other) request bodies. Unlike the encoding/query cases
    # above, this is NOT wrapped into ActionController::BadRequest, so it needs
    # its own key.
    "ActionDispatch::Http::Parameters::ParseError" => "ignore"
  )
end
