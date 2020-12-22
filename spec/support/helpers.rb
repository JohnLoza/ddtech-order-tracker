def set_session(args)
  post test_sessions_path(session_vars: args)
  expect(response).to have_http_status(:created)

  args.each_key do |arg|
    expect(session[arg]).to be_present
  end
end
