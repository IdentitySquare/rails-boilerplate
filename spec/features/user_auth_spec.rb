describe "the signin process", type: :feature do
  before :each do
    User.create!(email: 'user@example.com', password: 'password', first_name: 'John', last_name: "Doe")
  end

  it "signs me in" do
    visit 'users/sign_in'
    debugger
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    expect(page).to have_content 'Success'
  end
end