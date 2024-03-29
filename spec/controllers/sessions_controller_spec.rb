require 'spec_helper'

describe SessionsController do
	describe "GET new" do
		it "renders the new template for unauthenticated users" do
			get :new
			expect(response).to render_template :new
		end
		
		it "redirects to home page for authenticated users" do
			session[:user_id] = Fabricate(:user).id
			get :new
			expect(response).to redirect_to home_path
		end
	end

	describe "POST create" do
		context "with valid credentials" do
			let(:chase) { Fabricate(:user) }

			before do
				post :create, email: chase.email, password: chase.password
			end

			it "puts the signed in user in the session" do
				expect(session[:user_id]).to eq(chase.id)
			end

			it "redirects to the home path" do
				expect(response).to redirect_to home_path
			end

			it "sets the notice" do
				expect(flash[:notice]).not_to be_blank
			end
		end

		context "with invalid credentials" do
			before do
				chase = Fabricate(:user)
				post :create, email: chase.email, password: chase.password + 'sadffdsfsd'
			end

			it "does not put the signed in user in the session" do
				expect(session[:user_id]).to be_nil
			end

			it "redirects to sign in page" do
				expect(response).to redirect_to sign_in_path
			end

			it "sets the error message" do
				expect(flash[:error]).not_to be_blank
			end
		end
	end

	describe "GET destroy" do
		before do
			session[:user_id] = Fabricate(:user).id
			get :destroy 
		end

		it "clears the session" do
			expect(session[:user_id]).to be_nil
		end

		it "redirects to root path" do 
			expect(response).to redirect_to root_path
		end

		it "sets the notice" do
			expect(flash[:notice]).not_to be_blank
		end
	end
end